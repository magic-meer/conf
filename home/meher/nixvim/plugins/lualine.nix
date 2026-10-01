{ lib, ... }: {
  plugins.lualine = {
    enable = true;
    settings = {
      options = {
        theme = "auto";
        globalstatus = true;
        icons_enabled = true;
        disabled_filetypes = {
          statusline = [ "neo-tree" ];
        };
        component_separators = "";
        section_separators = "";
      };
      sections = {
        lualine_a = [
          # Transparent left margin spacer
          {
            __unkeyed-1.__raw = "function() return '' end";
            color.bg = "";
            left_padding = 2;
            right_padding = 1;
          }
          # Mode in its own bubble
          {
            __unkeyed-1 = "mode";
            separator.left = "";
            separator.right = "";
          }
        ];
        lualine_b = [
          # File / VCS info in one bubble
          {
            __unkeyed-1 = "filename";
            separator.left = "";
          }
          "branch"
          {
            __unkeyed-1 = "diff";
            separator.right = "";
          }
        ];
        lualine_c = [
          # LSP status in its own bubble: the symbol under the cursor plus the
          # attached client names (see LspInfo in extraConfigLua below).
          {
            __unkeyed-1.__raw = "function() return LspInfo.status() end";
            separator.left = "";
            separator.right = "";
          }
        ];
        lualine_x = [
          # OpenCode agent server + status
          {
            __unkeyed-1.__raw = "function() return require('opencode').statusline() end";
            separator.left = "";
            separator.right = "";
          }
          # File metadata in one bubble
          {
            __unkeyed-1 = "filetype";
            separator.left = "";
          }
          "fileformat"
          {
            __unkeyed-1 = "encoding";
            separator.right = "";
          }
        ];
        lualine_y = [
          # Diagnostics + progress in one bubble
          {
            __unkeyed-1 = "diagnostics";
            separator.left = "";
          }
          {
            __unkeyed-1 = "progress";
            separator.right = "";
          }
        ];
        lualine_z = [
          # Location in its own bubble
          {
            __unkeyed-1 = "location";
            separator.left = "";
            separator.right = "";
          }
          # Transparent right margin spacer
          {
            __unkeyed-1.__raw = "function() return '' end";
            color.bg = "";
            left_padding = 1;
            right_padding = 2;
          }
        ];
      };
    };
  };

  # Replaces lsp-status.nvim, which is unmaintained and calls the removed
  # `vim.lsp.buf_get_clients()` on every statusline redraw (Nvim 0.12 prints a
  # deprecation notice for it). This uses `vim.lsp.get_clients()` and resolves
  # the symbol under the cursor with a plain documentSymbol request.
  #
  # Diagnostic counts and LSP progress are already covered by lualine's own
  # `diagnostics` and `progress` components in lualine_y, so this only renders
  # the enclosing symbol and the attached client names.
  #
  # extraConfigLuaPre (not extraConfigLua) so LspInfo exists before
  # lualine.setup() below performs its first render.
  extraConfigLuaPre = ''
    LspInfo = { symbols = {} }

    -- Nvim 0.12 dropped `vim.lsp.handlers.symbol_kind`, so the icon table is
    -- keyed off the still-public `vim.lsp.protocol.SymbolKind` enum.
    local kind_icons = {
      [vim.lsp.protocol.SymbolKind.Class] = "󰠱",
      [vim.lsp.protocol.SymbolKind.Struct] = "󰆼",
      [vim.lsp.protocol.SymbolKind.Enum] = "󰕘",
      [vim.lsp.protocol.SymbolKind.Interface] = "󰖩",
      [vim.lsp.protocol.SymbolKind.Namespace] = "󰌗",
      [vim.lsp.protocol.SymbolKind.Module] = "󰏗",
      [vim.lsp.protocol.SymbolKind.Method] = "󰊕",
      [vim.lsp.protocol.SymbolKind.Function] = "󰊕",
    }

    local function kind_icon(kind)
      -- DocumentSymbol reports a number, SymbolInformation a name string.
      local name = type(kind) == "string" and kind or vim.lsp.protocol.SymbolKind[kind]
      return kind_icons[vim.lsp.protocol.SymbolKind[name]] or "󰊕"
    end

    -- Ask the first client attached to the current buffer for its document
    -- symbols and remember the innermost one covering the cursor.
    function LspInfo.refresh()
      local bufnr = vim.api.nvim_get_current_buf()
      local client = vim.lsp.get_clients({ bufnr = bufnr })[1]
      if not (client and client.server_capabilities.documentSymbolProvider) then
        LspInfo.symbols[bufnr] = nil
        return
      end

      local line = vim.api.nvim_win_get_cursor(0)[1] - 1
      local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
      vim.lsp.buf_request(bufnr, "textDocument/documentSymbol", params, function(_, result)
        if not result or vim.api.nvim_get_current_buf() ~= bufnr then
          return
        end
        local name, kind, span
        for _, symbol in ipairs(result) do
          local range = symbol.range or symbol.selectionRange
          if range and range.start.line <= line and line <= range["end"].line then
            local width = range["end"].line - range.start.line
            if not span or width < span then
              name, kind, span = symbol.name, symbol.kind, width
            end
          end
        end
        LspInfo.symbols[bufnr] = name and { name = name, kind = kind } or nil
        vim.cmd.redrawstatus()
      end)
    end

    function LspInfo.status()
      local clients = vim.lsp.get_clients({ bufnr = 0 })
      if #clients == 0 then
        return ""
      end

      local parts = {}
      local symbol = LspInfo.symbols[vim.api.nvim_get_current_buf()]
      if symbol and symbol.name ~= "" then
        table.insert(parts, kind_icon(symbol.kind) .. " " .. symbol.name)
      end

      local names = {}
      for _, client in ipairs(clients) do
        table.insert(names, client.name)
      end
      table.insert(parts, "[" .. table.concat(names, " ") .. "]")
      return table.concat(parts, " ")
    end

    vim.api.nvim_create_autocmd("CursorHold", {
      group = vim.api.nvim_create_augroup("lualine_lsp_info", { clear = true }),
      callback = LspInfo.refresh,
    })
  '';
}

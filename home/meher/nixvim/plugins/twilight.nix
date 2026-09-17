{
  # Twilight is installed and configured but NEVER auto-enabled: it only acts
  # when you run `:Twilight` (toggle). Nothing dims on startup or on entering
  # buffers.
  plugins.twilight = {
    enable = true;

    settings = {
      # Structural scopes: expand to the top-most ancestor function/method/table/
      # if-statement around the cursor (what makes twilight feel "scope aware").
      treesitter = true;
      context = 10;
      dimming = {
        alpha = 0.25;
      };
    };
  };

  extraConfigLua = ''
    local has_parser = function(buf)
      local ok, parser = pcall(vim.treesitter.get_parser, buf)
      return ok and parser ~= nil
    end

    -- Twilight sets guibg on the `Twilight` group from the current Normal
    -- background, which shows a solid block behind every dimmed line when the
    -- colorscheme/transparency is set up a certain way. Force the group to be
    -- foreground-only so dimmed lines stay see-through.
    local function fix_twilight_hl()
      local fg = 0xffffff
      local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = "Normal" })
      if ok and hl and hl.fg then
        fg = hl.fg
      end
      local function blend(hex, alpha)
        local r = bit.band(bit.rshift(hex, 16), 0xff)
        local g = bit.band(bit.rshift(hex, 8), 0xff)
        local b = bit.band(hex, 0xff)
        local blend_channel = function(c)
          return math.floor(c * alpha + 0.5)
        end
        return string.format("#%02x%02x%02x", blend_channel(r), blend_channel(g), blend_channel(b))
      end
      vim.api.nvim_set_hl(0, "Twilight", { fg = blend(fg, 0.25) })
    end

    -- Re-apply after any colorscheme change (twilight recolors first).
    vim.api.nvim_create_autocmd("ColorScheme", { callback = fix_twilight_hl })

    -- `:Twilight` toggles dimming for the current buffer. Twilight assumes a
    -- treesitter parser exists and crashes otherwise (get_parser() returns nil
    -- without error, which defeats twilight's own pcall guard), so only enable
    -- when the buffer actually has one.
    vim.api.nvim_create_user_command("Twilight", function()
      local twilight = require("twilight")
      if require("twilight.view").enabled then
        twilight.disable()
      elseif has_parser(vim.api.nvim_get_current_buf()) then
        twilight.enable()
        fix_twilight_hl()
      else
        vim.notify("Twilight needs a treesitter parser in this buffer", vim.log.levels.WARN)
      end
    end, {})
  '';
}
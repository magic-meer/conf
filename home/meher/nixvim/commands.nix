{ ... }: {
  programs.nixvim.extraConfigLua = ''
    -- :format — format via the attached LSP of the language (ruff for python,
    -- nixd/nixfmt for nix, qmlls for qml)
    vim.api.nvim_create_user_command("format", function()
      local ok = pcall(vim.lsp.buf.format, { async = false, timeout_ms = 4000 })
      if not ok then
        vim.notify("No formatter available for this file", vim.log.levels.WARN)
      end
    end, {})

    -- The only real way out of nixvim (other than the dashboard entry)
    vim.api.nvim_create_user_command("exitnixvim", function()
      vim.cmd("qa")
    end, {})

    -- :q and friends never exit nvim — they close the current buffer and
    -- homecoming reopens when the last file is closed
    for _, quit in ipairs({ "q", "qa", "qall", "wq", "wqa", "x", "xit", "ZQ", "q!", "qa!", "qall!" }) do
      vim.keymap.set("c", quit .. "<CR>", "HomecomingCloseCurrBuf<CR>", { noremap = true })
    end

    -- When every real file buffer is gone, welcome the dashboard back
    vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
      callback = function()
        local real = 0
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if
            vim.api.nvim_buf_is_valid(buf)
            and vim.api.nvim_buf_is_loaded(buf)
            and vim.bo[buf].buftype == ""
            and vim.api.nvim_buf_get_name(buf) ~= ""
          then
            real = real + 1
          end
        end
        if real == 0 then
          vim.schedule(function()
            vim.cmd("Homecoming")
          end)
        end
      end,
    })

    -- neo-tree extras: "d" = move to trash with undo history ("u"), "I" = file info
    local trash_dir = vim.fn.expand("~/.local/share/Trash")
    local trash_undo_stack = {}

    local function trashed_name_for(orig)
      local args = {
        "grep", "-l", "OriginalPath=" .. orig, trash_dir .. "/info/*",
      }
      local hits = vim.fn.systemlist(args)
      if #hits == 0 then
        return nil
      end
      local newest, name = 0, nil
      for _, info_file in ipairs(hits) do
        local mtime = vim.fn.getftime(info_file)
        if mtime > newest then
          newest = mtime
          name = vim.fn.fnamemodify(info_file, ":t:r")
        end
      end
      return name
    end

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "neo-tree",
      callback = function()
        local function current_state()
          return require("neo-tree.sources.common.views").get_state("filesystem")
        end

        local function current_node()
          local state = current_state()
          local node = state.tree:get_node()
          if not node or node.type == "message" then
            return nil, state
          end
          return node, state
        end

        -- "t" / "<S-t>": open without stealing focus. Folders just expand.
        local function open_quiet(cmd)
          local node, state = current_node()
          if not node then
            return
          end
          if node.type == "directory" then
            require("neo-tree.sources.filesystem").toggle_directory(state, node)
            return
          end
          local orig_tab = vim.api.nvim_get_current_tabpage()
          vim.cmd(cmd .. " " .. vim.fn.fnameescape(node.path))
          vim.api.nvim_set_current_tabpage(orig_tab)
          if cmd == "vsplit" then
            vim.cmd("wincmd p")
          end
        end

        vim.keymap.set("n", "t", function()
          open_quiet("tabnew")
        end, { buffer = 0, silent = true, desc = "Open in background tab" })

        vim.keymap.set("n", "<S-t>", function()
          open_quiet("vsplit")
        end, { buffer = 0, silent = true, desc = "Open in background split" })

        vim.keymap.set("n", "d", function()
          local state = current_state()
          local node = state.tree:get_node()
          if not node or node.type == "message" then
            return
          end
          local path = node.path
          local res = vim.fn.system({ "gio", "trash", path })
          if vim.v.shell_error ~= 0 then
            vim.notify("gio trash failed: " .. res, vim.log.levels.ERROR)
            return
          end
          local name = trashed_name_for(path)
          if name then
            table.insert(trash_undo_stack, {
              orig = path,
              trashed = trash_dir .. "/files/" .. name,
            })
          end
          require("neo-tree.sources.filesystem").refresh(state)
        end, { buffer = 0, silent = true, desc = "Move to trash" })

        vim.keymap.set("n", "u", function()
          local entry = table.remove(trash_undo_stack)
          if not entry then
            vim.notify("Nothing to undo", vim.log.levels.WARN)
            return
          end
          local parent = vim.fn.fnamemodify(entry.orig, ":h")
          vim.fn.system({ "mkdir", "-p", parent })
          local res = vim.fn.system({ "mv", entry.trashed, entry.orig })
          if vim.v.shell_error ~= 0 then
            vim.notify("Undo failed: " .. res, vim.log.levels.ERROR)
            table.insert(trash_undo_stack, 1, entry)
            return
          end
          local info_file = trash_dir
            .. "/info/"
            .. vim.fn.fnamemodify(entry.trashed, ":t")
            .. ".trashinfo"
          vim.fn.system({ "rm", "-f", info_file })
          local state = current_state()
          require("neo-tree.sources.filesystem").refresh(state)
          vim.notify("Restored from trash: " .. vim.fn.fnamemodify(entry.orig, ":t"))
        end, { buffer = 0, silent = true, desc = "Undo move to trash" })

        vim.keymap.set("n", "I", function()
          local state = current_state()
          local node = state.tree:get_node()
          if not node or node.type == "message" then
            return
          end
          local info = vim.fn.system(
            "stat -c '%n|%s bytes|%y' " .. vim.fn.shellescape(node.path)
          )
          vim.notify(info, vim.log.levels.INFO, { title = "File info" })
        end, { buffer = 0, silent = true, desc = "File info" })
      end,
    })
  '';
}
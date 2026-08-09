{ ... }: {
  programs.nixvim.extraConfigLua = ''
      -- :Format — format via the attached LSP of the language (ruff for python,
      -- nixd/nixfmt for nix, qmlls for qml)
      vim.api.nvim_create_user_command("Format", function()
        local ok = pcall(vim.lsp.buf.format, { async = false, timeout_ms = 4000 })
        if not ok then
          vim.notify("No formatter available for this file", vim.log.levels.WARN)
        end
      end, {})

      -- The only real way out of nixvim (other than the dashboard entry)
      vim.api.nvim_create_user_command("ExitNixvim", function()
        vim.cmd("qa")
      end, {})

      -- :q / :wq / :x close the current buffer instead of quitting nvim; the
      -- dashboard reopens when the last file is gone. Bang-quits (q!, wq!,
      -- qa!, qall) and :ExitNixvim are the real ways out.
      for _, quit in ipairs({ "q", "qw", "wq", "quit", "x", "xit" }) do
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
              pcall(vim.cmd, "Homecoming")
            end)
          end
        end,
      })

      -- Open the dashboard on startup when launching without files
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          if vim.fn.argc() == 0 then
            vim.schedule(function()
              pcall(vim.cmd, "Homecoming")
            end)
          end
        end,
      })

      -- neo-tree extras: d = move to trash with undo history (u), I = file info.
      -- Trash is implemented in pure lua (no gio/trash-cli dependency), writing
      -- the same ~/.local/share/Trash/{files,info} layout other trash tools use.
      local trash_dir = vim.fn.expand("~/.local/share/Trash")
      local trash_undo_stack = {}

      local function move_to_trash(path)
        local files_dir = trash_dir .. "/files"
        local info_dir = trash_dir .. "/info"
        vim.fn.system({ "mkdir", "-p", files_dir, info_dir })
        local basename = vim.fn.fnamemodify(path, ":t")
        local name = basename
        local n = 1
        while
          vim.fn.filereadable(files_dir .. "/" .. name) == 1
          or vim.fn.isdirectory(files_dir .. "/" .. name) == 1
        do
          n = n + 1
          name = basename .. " (" .. n .. ")"
        end
        local res = vim.fn.system({ "mv", path, files_dir .. "/" .. name })
        if vim.v.shell_error ~= 0 then
          vim.notify("trash failed: " .. res, vim.log.levels.ERROR)
          return false
        end
        local info = {
          "[Trash Info]",
          "Path=" .. vim.uri_encode(path, "%XX"),
          "DeletionDate=" .. os.date("!%Y-%m-%dT%H:%M:%S"),
        }
        vim.fn.writefile(info, info_dir .. "/" .. name .. ".trashinfo")
        table.insert(trash_undo_stack, { orig = path, trashed = files_dir .. "/" .. name })
        return true
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
            local node, state = current_node()
            if not node then
              return
            end
            if move_to_trash(node.path) then
              require("neo-tree.sources.filesystem").refresh(state)
            end
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
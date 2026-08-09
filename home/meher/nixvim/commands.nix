{ ... }: {
  programs.nixvim.extraConfigLua = ''
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
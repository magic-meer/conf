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
  '';
}
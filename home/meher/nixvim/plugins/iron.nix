{ ... }: {
  # Run python code in an interactive REPL (loads lazily with python)
  programs.nixvim.plugins.iron = {
    enable = true;
    settings = {
      highlight = true;
      ignore_blank_lines = true;
      repl_definition.python.command = [ "python3" ];
      repl_open_cmd.__raw = "require('iron.view').split.vertical.botright(80)";
      keymaps = {
        open_repl = "<leader>ro";
        send_motion = "<leader>rc";
        visual_send = "<leader>rc";
        send_line = "<leader>rl";
        send_file = "<leader>rf";
        send_paragraph = "<leader>rp";
        close_repl = "<leader>rq";
        restart = "<leader>rr";
      };
    };
    lazyLoad = {
      enable = true;
      settings.ft = [ "python" ];
    };
  };
}

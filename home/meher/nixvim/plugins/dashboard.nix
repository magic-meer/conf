{ ... }: {
   plugins.dashboard = {
      enable = true;
      settings = {
         theme = "hyper";
         config = {
            header = [
               "███╗   ██╗██╗██╗  ██╗██╗   ██╗██╗███╗   ███╗"
               "████╗  ██║██║╚██╗██╔╝██║   ██║██║████╗ ████║"
               "██╔██╗ ██║██║ ╚███╔╝ ██║   ██║██║██╔████╔██║"
               "██║╚██╗██║██║ ██╔██╗ ╚██╗ ██╔╝██║██║╚██╔╝██║"
               "██║ ╚████║██║██╔╝ ██╗ ╚████╔╝ ██║██║ ╚═╝ ██║"
               "╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝"
            ];
            shortcut = [
               {
                  icon = " ";
                  desc = "Open Terminal";
                  group = "String";
                  action = "terminal";
                  key = "t";
               }
            ];
         };
      };
   };

   # `project.action` must be a *string* here, and specifically a string that is
   # also a valid Lua chunk. Both halves matter:
   #
   # 1. Why not a real function: dashboard's db:cache_opts() (init.lua:149) runs
   #    `string.dump(self.opts.config.project.action)` and writes the resulting
   #    *bytecode* into ~/.cache/nvim/dashboard/conf as JSON. On the next start
   #    that stale bytecode is read back and executed by the theme, which is the
   #    E5108/E3 error that reappears on every dashboard open and never clears.
   #    A string is JSON-safe, so nothing is ever dumped.
   #
   # 2. Why the string has to compile as Lua: the theme (hyper.lua:328) tries
   #    `loadstring(action)` first and, when that succeeds, calls the chunk with
   #    the project path as a vararg. So `...` receives the path *without* any
   #    shell/Ex quoting, which is what makes spaces work. Falling through to the
   #    `vim.cmd(action .. path)` branch instead would concatenate the path raw
   #    into a command line, breaking on "~/things/FA26 - 7th sem/ANNaDL" and on
   #    the default "Telescope find_files cwd=", which then makes telescope treat
   #    the first path segment as a sub-command.
   extraConfigLua = ''
      local project = require("dashboard").opts.config.project or {}
      project.action = 'require("telescope.builtin").find_files({ cwd = ... })'
      require("dashboard").opts.config.project = project
   '';
}

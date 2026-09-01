{
   ...
}: {
   plugins.notify = {
      enable = true;
      settings = {
         timeout = 5000;
         top_down = false;
         # A valid hex silences the "no background highlight" validation warning.
         # The window itself is made transparent via winblend in on_open (below),
         # so the terminal blur shows through.
         background_colour = "#000000";
         on_open.__raw = ''
           function(win)
             vim.api.nvim_win_set_option(win, "winblend", 30)
           end
         '';
      };
   };
}

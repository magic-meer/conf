{ ... }: {
  programs.nixvim.plugins = {
    # Python debugging: nvim-dap + python adapter + UI (all load lazily with python)
    dap = {
      enable = true;
      configurations.python = [
        {
          type = "python";
          request = "launch";
          name = "Launch file";
          program.__raw = "vim.fn.expand('%:p')";
          console = "integratedTerminal";
        }
      ];

      # Glowing dot breakpoint (like vscode) with the line highlighted
      signs.dapBreakpoint = {
        text = "●";
        texthl = "DapBreakpoint";
        linehl = "DapBreakpointLine";
      };
      signs.dapBreakpointCondition = {
        text = "●";
        texthl = "DapBreakpointCondition";
        linehl = "DapBreakpointLine";
      };
      signs.dapBreakpointRejected = {
        text = "●";
        texthl = "DapBreakpointRejected";
        linehl = "DapBreakpointLine";
      };

      extensionConfigLua = ''
        vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#f7768e" })
        vim.api.nvim_set_hl(0, "DapBreakpointCondition", { fg = "#f7768e" })
        vim.api.nvim_set_hl(0, "DapBreakpointRejected", { fg = "#565f89" })
        vim.api.nvim_set_hl(0, "DapBreakpointLine", { bg = "#f7768e33" })
      '';
      lazyLoad = {
        enable = true;
        settings = {
          ft = [ "python" ];
          keys = [
            {
              __unkeyed-1 = "<leader>db";
              __unkeyed-3 = "<cmd>DapToggleBreakpoint<CR>";
              desc = "Toggle breakpoint";
            }
            {
              __unkeyed-1 = "<leader>dc";
              __unkeyed-3 = "<cmd>DapContinue<CR>";
              desc = "Continue";
            }
            {
              __unkeyed-1 = "<leader>do";
              __unkeyed-3 = "<cmd>DapStepOver<CR>";
              desc = "Step over";
            }
            {
              __unkeyed-1 = "<leader>di";
              __unkeyed-3 = "<cmd>DapStepInto<CR>";
              desc = "Step into";
            }
            {
              __unkeyed-1 = "<leader>dx";
              __unkeyed-3 = "<cmd>DapTerminate<CR>";
              desc = "Terminate session";
            }
          ];
        };
      };
    };

    dap-python = {
      enable = true;
      lazyLoad = {
        enable = true;
        settings.ft = [ "python" ];
      };
    };

    dap-ui = {
      enable = true;
      settings = {
        layouts = [
          {
            elements = [
              {
                id = "scopes";
                size = 0.25;
              }
            ];
            position = "left";
            size = 40;
          }
        ];
        floating = {
          max_height = 20;
          max_width = 70;
          border = "rounded";
        };
      };
      lazyLoad = {
        enable = true;
        settings.ft = [ "python" ];
      };
    };
  };
}

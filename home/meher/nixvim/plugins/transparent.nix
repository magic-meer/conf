{ ... }: {
   plugins.transparent = {
      enable = true;
      settings = {
         extra_groups = [
            # noice popups (cmdline, bottom-right, confirm)
            "NoiceCmdlinePopup"
            "NoiceCmdlinePopupBorder"
            "NoiceCmdlinePopupTitle"
            "NoicePopup"
            "NoicePopupBorder"
            "NoicePopupMenu"
            "NoicePopupMenuSelected"
            "NoicePopupMenuBorder"
            "NormalFloat"
            "FloatBorder"
            # nvim-notify
            "NotifyBackground"
            "NotifyBorder"
            "NotifyTitle"
            "NotifyErrorBorder"
            "NotifyWarnBorder"
            "NotifyInfoBorder"
            "NotifyDebugBorder"
            "NotifyTraceBorder"
            "NotifyErrorTitle"
            "NotifyWarnTitle"
            "NotifyInfoTitle"
            "NotifyDebugTitle"
            "NotifyTraceTitle"
         ];
      };
   };
}

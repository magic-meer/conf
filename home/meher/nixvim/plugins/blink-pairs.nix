{ ... }: {
   # Saghen/blink.pairs — standalone auto-pairs for blink.cmp 1.x (the Rust
   # rewrite dropped the built-in `blink.pairs` that existed in 0.x). Provides
   # auto-closing, backspace-to-unpair, skipping over the closing bracket when
   # typing it, and matching-bracket highlight via MatchParen.
   plugins.blink-pairs = {
      enable = true;
      settings = {
         mappings = {
            enabled = true;
            cmdline = true;
            # Auto-pairs handled by the plugin; Tab/Enter are left to blink-cmp.
         };
         highlights = {
            enabled = true;
            cmdline = true;
            # Depth-based colors; defaults to (undefined) BlinkPairsOrange/
            # Purple/Blue. The v0.6.0 defaults + MatchParen cover bracket
            # matching without extra groups.
         };
      };
   };
}
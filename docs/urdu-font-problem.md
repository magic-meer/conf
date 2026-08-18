Your diagnosis is right, and here's precisely why the fallback-list approach fails: fontconfig's fallback chain is coverage-based, not preference-based. It walks your family list and stops at the first font that has a glyph for the codepoint — it doesn't care how ugly that glyph is. DejaVu and Anka both already carry Arabic-block glyphs, so Nastaliq sitting later in the list never gets reached. There's no "gap" for it to fill.

What you actually need isn't a fallback reorder — it's a rule that fires based on what script the text run is, and overrides the family list for that run specifically, regardless of what else covers it. That's what fontconfig's lang test combined with <edit mode="prepend"> does. Pango (which drives font resolution for GTK and most fontconfig-aware toolkits) tags each run of text with a language during itemization and queries fontconfig with that tag — so you can intercept just the Arabic-script runs and force Nastaliq to the front without touching anything else.

Add this wherever you already set your other fonts.* / stylix.fonts options:

nix
fonts.packages = with pkgs; [
  noto-fonts
];

fonts.fontconfig.localConf = ''
  <match>
    <test name="lang" compare="contains"><string>ar</string></test>
    <test qual="any" name="family"><string>sans-serif</string></test>
    <edit name="family" mode="prepend"><string>Noto Nastaliq Urdu</string></edit>
  </match>
  <match>
    <test name="lang" compare="contains"><string>ar</string></test>
    <test qual="any" name="family"><string>serif</string></test>
    <edit name="family" mode="prepend"><string>Noto Nastaliq Urdu</string></edit>
  </match>
  <match>
    <test name="lang" compare="contains"><string>ar</string></test>
    <test qual="any" name="family"><string>monospace</string></test>
    <edit name="family" mode="prepend"><string>Noto Nastaliq Urdu</string></edit>
  </match>
'';

fonts.fontconfig.localConf is a plain NixOS option, documented as taking higher priority than whatever defaultFonts gets set to. Stylix's stylix.fonts.* drives that same defaultFonts-style mechanism under the hood, so this composes on top cleanly — you're not fighting Stylix, you're adding a rule it has no knob for. It's additive with anything else in your config too, so no risk of clobbering existing fonts.packages entries.

Two things that actually matter here:

Use ar, not ur. This is the part that trips people up. Unicode doesn't distinguish "Urdu" from "Arabic" at the codepoint level — they're both the Arabic script block. Pango can only tag a run as ur if something explicitly told it the language (a locale, an HTML lang="ur" attribute). Plain typed text with no such markup — which is most of what you'll actually hit — gets tagged with the script's default/sample language, and for Arabic script that's ar. Match only on ur and the rule will silently never fire. If you also want to catch cases where something does explicitly mark text as Urdu, duplicate the three blocks with ur in place of ar. (This exact bleed-through, in reverse, is a known enough issue that ArchWiki has a section called "Excluding Arabic script from other languages" for people who want to keep Nastaliq out of their plain-Arabic text — worth a skim if you ever want to split the two more precisely.)

Reconsider the monospace block. Nastaliq's whole visual identity is diagonal, connected, variable-width strokes — it doesn't survive being forced into fixed-width cells. Urdu pasted into a terminal with that third block active will likely look worse, not better. You may want to drop it and let monospace Urdu keep falling through to Anka/DejaVu.

Confirm the family name you actually get once installed with fc-list | grep -i nastaliq after rebuilding — if you're using a different Nastaliq font than Noto's (Jameel Noori Nastaleeq, Awami Nastaliq, etc.), swap the string, and note most non-Noto Nastaliq fonts aren't in nixpkgs, so you'd need an overlay or a fetched derivation for those.

After nixos-rebuild switch, verify directly rather than trusting an app's rendering:

fc-match -a "sans:lang=ar" | head -3

Nastaliq should be first. Restart whatever app you're testing in, since font resolution is typically cached per-process at startup.

One honest limitation: this works for anything going through Pango/fontconfig's script-aware fallback — GTK, Qt, LibreOffice, most desktop apps. Terminal emulators and other things that render a raw codepoint stream with no language tagging at all may not honor it, since they never construct a pattern with lang=ar to begin with — that's a per-app fix if you hit it, not a fontconfig one.

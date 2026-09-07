# Cliamp — YouTube Music Authentication / Configuration Issue

**Date documented:** 2026-09-05  
**System:** NixOS, Home Manager, flakes  
**User:** meher  
**Cliamp version:** 1.63.2  
**yt-dlp version:** 2026.08.19  
**Browser:** Zen Browser (Firefox-based), with multiple profiles

---

## Summary

I attempted to configure **Cliamp** (`bjarneo/cliamp`) declaratively on NixOS and get **YouTube Music (YT Music)** working with an existing Google/YouTube login in Zen Browser.

The Cliamp package itself installs and runs correctly. `yt-dlp` is also installed and can successfully access the logged-in YouTube session from the Zen profile.

However, **Cliamp's YouTube Music provider consistently fails with:**

```text
YouTube: no credentials available (configure client_id/client_secret in config.toml)
```

The browser-cookie approach was also attempted through both declarative configuration and `cliamp setup`, but Cliamp did not successfully authenticate.

At this point, this is being documented as a likely **Cliamp-side issue/bug or a mismatch between the current Cliamp release and its documented/browser-cookie authentication behavior**, rather than a NixOS, Zen Browser, or `yt-dlp` authentication problem.

---

# 1. Goal

The intended setup was:

- Install Cliamp declaratively through Nix/Home Manager.
- Keep the configuration in a separate `cliamp.nix` module.
- Import that module from the main Home Manager configuration.
- Initially configure **YouTube Music only**.
- Use an existing Google/YouTube account.
- Prefer browser-cookie authentication through Zen Browser.
- Avoid putting Google passwords or OAuth tokens into the Nix configuration.
- Potentially use `agenix` later for OAuth client secrets if OAuth becomes necessary.
- Add Spotify later, after YouTube Music works.

---

# 2. Cliamp Installation

The upstream project is:

https://github.com/bjarneo/cliamp

The Cliamp flake was added as a flake input:

```nix
cliamp.url = "github:bjarneo/cliamp";
```

The package was installed through Home Manager using:

```nix
inputs.cliamp.packages.${pkgs.stdenv.hostPlatform.system}.default
```

`yt-dlp` was also installed declaratively.

The resulting versions were verified:

```text
cliamp version 1.63.2
yt-dlp 2026.08.19
```

Therefore the basic installation works.

---

# 3. Initial Declarative Configuration

The initial `cliamp.nix` contained:

```nix
{ config, pkgs, inputs, ... }:

{
  home.packages = [
    inputs.cliamp.packages.${pkgs.stdenv.hostPlatform.system}.default
    pkgs.yt-dlp
  ];

  xdg.configFile."cliamp/config.toml".text = ''
    [ytmusic]
    cookies_from = "firefox:~/.config/zen"
    expand_playlist = true
  '';
}
```

The generated configuration was verified.

Cliamp still returned:

```text
YouTube: no credentials available (configure client_id/client_secret in config.toml)
```

---

# 4. Zen Browser Profile Layout

Zen Browser has multiple profiles on this system.

Relevant directory:

```text
~/.config/zen/
```

Contents included:

```text
default.deleted
Profile Groups
profiles.ini
School
tumg9xef.Default Profile
```

The cookie databases were found with:

```fish
find ~/.config/zen -maxdepth 2 -type f -name "cookies.sqlite"
```

Result:

```text
/home/meher/.config/zen/tumg9xef.Default Profile/cookies.sqlite
/home/meher/.config/zen/default.deleted/cookies.sqlite
```

The active/default profile containing the desired YouTube session is:

```text
~/.config/zen/tumg9xef.Default Profile
```

There is also a separate:

```text
~/.config/zen/School
```

profile.

---

# 5. Critical Test: yt-dlp Browser Authentication Works

The following command was run against the Zen root:

```fish
yt-dlp \
  --cookies-from-browser "firefox:~/.config/zen" \
  --print "%(channel)s" \
  "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
```

It successfully returned:

```text
Rick Astley
```

This proves that:

1. Zen's cookies can be accessed.
2. `yt-dlp` can decrypt/read the cookies.
3. The Zen browser profile path is usable.
4. The Google/YouTube login session is valid.
5. YouTube authentication itself is not fundamentally broken.
6. NixOS is not preventing `yt-dlp` from accessing the browser session.

The explicit profile path was also tested:

```fish
yt-dlp \
  --cookies-from-browser "firefox:~/.config/zen/tumg9xef.Default Profile" \
  --print "%(channel)s" \
  "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
```

This also returned:

```text
Rick Astley
```

Therefore the exact Zen profile containing the YouTube session is confirmed to work with `yt-dlp`.

---

# 6. Explicit Cliamp Profile Configuration Attempt

Because Cliamp continued to report missing credentials, the configuration was changed to explicitly identify the Zen profile:

```toml
[ytmusic]
cookies_from = "firefox:~/.config/zen/tumg9xef.Default Profile"
expand_playlist = true
```

The generated file was verified.

`cliamp --provider ytmusic` still returned:

```text
YouTube: no credentials available (configure client_id/client_secret in config.toml)
```

This is significant because the exact same browser profile works with `yt-dlp`.

---

# 7. Home Manager File-Permission Problem

An additional problem was discovered while experimenting with `cliamp setup`.

Home Manager had generated:

```text
~/.config/cliamp/config.toml
```

with permissions:

```text
-r-------- 1 meher users ...
```

Cliamp's setup wizard attempted to modify `config.toml` and failed with:

```text
failed to write ~/.config/cliamp/config.toml
permission denied
```

The reason was that Home Manager was declaratively managing the file using:

```nix
xdg.configFile."cliamp/config.toml".text = ...
```

This made the generated configuration effectively read-only.

A backup conflict also occurred:

```text
Existing file '/home/meher/.config/cliamp/config.toml.home.backup'
would be clobbered by backing up
'/home/meher/.config/cliamp/config.toml'
```

The backup was removed:

```fish
rm ~/.config/cliamp/config.toml.home.backup
```

and the NixOS rebuild then succeeded.

---

# 8. Home Manager Configuration Was Verified

After rebuilding, the configuration was inspected using:

```fish
sed -n '1,20l' ~/.config/cliamp/config.toml
```

The result showed the expected configuration:

```text
[ytmusic]
cookies_from = "firefox:~/.config/zen"
expand_playlist = true
```

(or, during the explicit-profile test:)

```text
[ytmusic]
cookies_from = "firefox:~/.config/zen/tumg9xef.Default Profile"
expand_playlist = true
```

Thus the configuration was definitely reaching:

```text
~/.config/cliamp/config.toml
```

---

# 9. Declarative vs Mutable Configuration

The initial approach used Home Manager to fully own:

```text
~/.config/cliamp/config.toml
```

This caused a conflict with Cliamp's setup wizard because Cliamp itself wants to write to the same file.

The approach was therefore reconsidered.

A Home Manager activation-based approach was proposed so that Home Manager would create the initial file only if it didn't already exist:

```nix
home.activation.cliampConfig = config.lib.dag.entryAfter [ "writeBoundary" ] ''
  cliamp_config="$HOME/.config/cliamp/config.toml"

  mkdir -p "$HOME/.config/cliamp"

  if [ ! -e "$cliamp_config" ]; then
    cat > "$cliamp_config" <<'EOF'
theme = ""

[ytmusic]
expand_playlist = true
EOF
  fi

  chmod u+rw "$cliamp_config"
'';
```

The intention was to allow Cliamp to own mutable runtime/authentication configuration while still declaring the initial configuration through Nix.

---

# 10. Cliamp Setup Wizard Attempt

Cliamp's interactive setup was then tested:

```fish
cliamp setup
```

Under the YouTube Music section, the setup offered:

- Use default credentials
- Use browser credentials

The browser credential option was selected.

Firefox was selected as the browser.

Cliamp then failed with:

```text
failed to write ~/.config/cliamp/config.toml
permission denied
```

This established that the setup wizard itself expects to modify:

```text
~/.config/cliamp/config.toml
```

and that making the configuration declaratively managed/read-only conflicts with this setup flow.

---

# 11. Important Result

The following chain has been independently verified:

```text
Zen Browser
    ↓
logged-in Google/YouTube session
    ↓
cookies.sqlite
    ↓
yt-dlp
    ↓
SUCCESS
    ↓
"Rick Astley"
```

But:

```text
Zen Browser
    ↓
logged-in Google/YouTube session
    ↓
Cliamp
    ↓
FAIL
    ↓
"YouTube: no credentials available"
```

And Cliamp's setup wizard is also unable to write its configuration when Home Manager owns the file.

Therefore the failure is not simply "YouTube is not logged in."

---

# 12. OAuth Was Considered

Cliamp reports:

```text
YouTube: no credentials available
(configure client_id/client_secret in config.toml)
```

Therefore Google OAuth credentials were considered as an alternative.

The intended architecture would be:

```text
Nix/Home Manager
       ↓
Cliamp configuration
       ↓
Google OAuth client_id
       ↓
agenix → client_secret
       ↓
Cliamp
       ↓
interactive Google login
       ↓
OAuth credentials/token
```

Important distinction:

- Nix can declaratively manage the OAuth configuration.
- `agenix` can protect the client secret.
- The actual Google account login is still an interactive OAuth operation.
- The resulting authentication token should not be committed to the Nix repository.

No Google OAuth application was created yet because the browser-cookie method was expected to work and `yt-dlp` proved that the browser session itself is valid.

---

# 13. Current Conclusion

At the end of troubleshooting:

### Working

- NixOS installation ✅
- Flakes ✅
- Home Manager ✅
- Cliamp package installation ✅
- Cliamp version 1.63.2 ✅
- yt-dlp version 2026.08.19 ✅
- Zen Browser ✅
- Multiple Zen profiles identified ✅
- Google/YouTube login in Zen ✅
- `yt-dlp --cookies-from-browser` with Zen root ✅
- `yt-dlp --cookies-from-browser` with exact Zen profile ✅
- YouTube video access through yt-dlp ✅
- Declarative Cliamp installation ✅

### Not working

- Cliamp YouTube Music authentication ❌
- Cliamp browser-cookie authentication through setup ❌
- Cliamp's `cookies_from` configuration producing usable YT Music credentials ❌
- Cliamp setup while `config.toml` is Home Manager managed ❌

---

# 14. Likely Cause

The evidence points toward one or more of:

1. A Cliamp 1.63.2 bug/regression in YouTube Music authentication.
2. A mismatch between the current Cliamp documentation and the actual authentication implementation.
3. A problem in Cliamp's handling of `cookies_from` for Firefox/Zen profiles.
4. A distinction between yt-dlp's browser-cookie authentication and Cliamp's own YT Music authentication path.
5. Cliamp's current YT Music provider requiring OAuth credentials despite the documented browser-cookie workflow.
6. A configuration-management conflict when Home Manager makes `config.toml` immutable.

The fact that **the exact same Zen profile works successfully with yt-dlp** is the strongest evidence against the browser session itself being the problem.

---

# 15. Current Configuration State

The intended modular Nix structure is:

```text
nixconfig/
├── flake.nix
└── home/
    └── meher/
        └── cliamp.nix
```

Cliamp is intended to remain in its own imported module.

Spotify is intentionally **not configured yet**.

The next troubleshooting step, if continuing with Cliamp, should be to inspect the exact Cliamp 1.63.2 source/issues related to:

- `ytmusic`
- `cookies_from`
- browser authentication
- Firefox/Zen cookie extraction
- `client_id` / `client_secret`
- credential loading
- config file writing

before adding further complexity such as Google OAuth or agenix.

---

# 16. Useful Reproduction Commands

Check versions:

```fish
cliamp --version
yt-dlp --version
```

Inspect Cliamp configuration:

```fish
cat ~/.config/cliamp/config.toml
```

Inspect exact line structure:

```fish
sed -n '1,20l' ~/.config/cliamp/config.toml
```

Inspect Zen profiles:

```fish
ls -la ~/.config/zen
```

Find browser cookie databases:

```fish
find ~/.config/zen -maxdepth 2 -type f -name "cookies.sqlite"
```

Prove yt-dlp can access the default Zen profile:

```fish
yt-dlp \
  --cookies-from-browser "firefox:~/.config/zen/tumg9xef.Default Profile" \
  --print "%(channel)s" \
  "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
```

Run Cliamp:

```fish
cliamp --provider ytmusic
```

Run its setup:

```fish
cliamp setup
```

---

# 17. Recommendation

Do **not** delete or recreate the entire Nix configuration because of this issue.

Keep the Cliamp module isolated.

For now, treat YouTube Music support as **blocked by a Cliamp authentication/configuration issue**.

If Cliamp is updated in the future, retest the browser-cookie method first.

If browser authentication remains broken, investigate the OAuth route using an agenix-protected client secret rather than putting credentials directly into the Git-tracked Nix configuration.

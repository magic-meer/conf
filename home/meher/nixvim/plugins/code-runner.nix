{ pkgs, ... }: {
  # code_runner.nvim — run the current file/project for many languages, in a
  # floating Snacks terminal. Not packaged in nixpkgs, so we build it from a
  # pinned commit. fetchgit (not fetchFromGitHub): GitHub regenerates its
  # archive tarballs (gzip embeds a timestamp), so their hash changes on every
  # re-download; a git fetch is content-addressed and stable for a pinned rev.
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      pname = "code_runner.nvim";
      version = "0-unstable-2026-09-17";
      src = pkgs.fetchgit {
        url = "https://github.com/CRAG666/code_runner.nvim.git";
        rev = "ae11f6cb469ee5547cd0e076ecb41d74a7322cb8";
        hash = "sha256-BTd5gQgocJNygy2BeLHNxBnWl1kVsNAzFFG4Y0ucuJM=";
      };
      meta.homepage = "https://github.com/CRAG666/code_runner.nvim";
    })
  ];

  extraConfigLua = ''
    require('code_runner').setup({
      -- Show output in a floating Snacks terminal (snacks.terminal.open is
      -- used, which supports a plain string command; input() prompts work).
      mode = 'snacks',
      filetype = {
        -- Run from the file's directory ($dir) so relative paths resolve.
        python = { 'cd $dir &&', 'python3 -u $file' },
        -- java/kotlin use the system-wide JDK (pkgs.jdk21) and kotlinc.
        java = {
          'cd $dir &&',
          'javac $fileName &&',
          'java $fileNameWithoutExt',
        },
        kotlin = {
          'cd $dir &&',
          'kotlinc $fileName -include-runtime -d /tmp/$fileNameWithoutExt.jar &&',
          'java -jar /tmp/$fileNameWithoutExt.jar',
        },
        sh = 'bash $file',
        bash = 'bash $file',
        zsh = 'zsh $file',
        fish = 'fish $file',
      },
    })
  '';
}
{ pkgs, ... }: {
  # code_runner.nvim — run the current file/project for many languages, in a
  # floating Snacks terminal. Not packaged in nixpkgs, so we build it from a
  # pinned commit via fetchFromGitHub.
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      pname = "code_runner.nvim";
      version = "0-unstable-2026-09-17";
      src = pkgs.fetchFromGitHub {
        owner = "CRAG666";
        repo = "code_runner.nvim";
        rev = "ae11f6cb469ee5547cd0e076ecb41d74a7322cb8";
        hash = "sha256-qGLlH6pOaz8UyLZwNAFF/cX9e9Fad9Pm0A0yUjhjKoc=";
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
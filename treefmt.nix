{
  projectRootFile = ".git/config";
  programs = {
    mdformat.enable = true;
    nixfmt.enable = true;

    shellcheck = {
      enable = true;
      external-sources = true;
    };
  };
}

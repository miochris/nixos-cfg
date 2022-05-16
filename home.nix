{ config, lib, pkgs, ... }:

let
  vimsettings = import ./vim.nix;
  packages = import ./packages.nix;

  inherit (lib) mkIf;
  inherit (pkgs.stdenv) isLinux isDarwin;

in {
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "qiang";
  home.homeDirectory = "/home/qiang";

  home.sessionVariables = { EDITOR = "vim"; };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.11";

  nixpkgs.config.allowUnfree = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = packages pkgs true;
  # programs.neovim = vimsettings pkgs;
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh_nix";
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "vi-mode" "autojump" ];
      theme = "robbyrussell";
      # theme = "trapd00r";
    };
    shellAliases = {
      ssht = "ssh thorium.corp.hanson.as";
      k = "kubectl";
      kg = "kubectl get po";
      kd = "kubectl delete pod";
      kdp = "kubectl describe pod";
      kl = "kubectl logs -f";
      kdev = "kubectl config use-context smk-dev";
      kmn = "kubectl config use-context minikube";
      kstg =
        "kubectl config use-context arn:aws:eks:eu-west-1:928238300371:cluster/Staging-Master";
      kci =
        "kubectl config use-context arn:aws:eks:eu-west-1:928238300371:cluster/CI-Master";
      kprod =
        "kubectl config use-context arn:aws:eks:eu-west-1:928238300371:cluster/Production-Master";
      guc = "git log origin/master..HEAD";
      gpo = "git rev-parse --abbrev-ref HEAD | xargs git push origin -f";
      kt = "kubetail";
      cb = "cargo build";
      ct = "cargo test";
      cr = "cargo run";
      jll = "jl -format=logfmt";
      deploy_apps = "~/bin/deploy_apps";
    };
  };
  # programs.git = {
  #   enable = true;
  #   # userName = "qiang";
  #   # core.editor = "vim";
  # };

  xdg.enable = true;

  xsession = {
    enable = true;
    windowManager.i3 = rec {
      enable = true;
      package = pkgs.i3; # i3-gaps
      config = {
        modifier = "Mod4";
        # bars = [ ];
        # gaps = {
        #   inner = 12;
        #   outer = 5;
        #   smartGaps = true;
        #   smartBorders = "off";
        # };

        startup = [
          #{ command = "exec firefox"; }
          #{ command = "exec steam"; }
          #{ command = "exec Discord"; }
        ]
        # ++ lib.optionals isDesktop [
        #   { command = "xrand --output HDMI-0 --right-of DP-4"; notification = false; }
        # ]
        ;
        assigns = {
          # "1: web" = [{ class = "^Firefox$"; }];
        };

        keybindings = import ./i3-keybindings.nix config.modifier;
      };
      # extraConfig = ''
      #   for_window [class="^.*"] border pixel 2
      #   #exec systemctl --user import-environment
      # '' + lib.optionalString isDesktop ''
      #   workspace "2: web" output HDMI-0
      #   workspace "7" output HDMI-0
      # '';
    };
  };

  home.file.".zshrc".text = ''
    # test zshrc file
  '';

  # home.file.".zshrc" = {
  #   source = ../../git/dotfile/zshrc;

  # };

  home.file.".config/git/config" = {
    source = ./dotfile/git_config;
  };
  home.file.".vimrc" = { source = ./dotfile/vimrc; };
  # home.file.".config/i3/config" = {
  #   source = ../../git/dotfile/i3/config;
  # };
  home.file.".config/i3status/config" = {
    source = ./dotfile/i3status_config;
  };
  home.file.".config/rofi/config.rasi".text = ''
    configuration {
     modi: "window,drun,ssh,combi";
     font: "hack 26";
     combi-modi: "window,drun,ssh";
    }
    @theme "solarized"
  '';

  home.file.".vim/autoload/plug.vim" = { source = ./dotfile/plug.vim; };

  programs.direnv.enable = true;

}

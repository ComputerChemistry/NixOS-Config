{pkgs, inputs, ...}: let 

	python-packages = pkgs.python3.withPackages(
	ps: 
	   with ps; [
		requests 
		pyquery
		]
	); 
in {
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = (with pkgs; [
     vim 
     tree
     git
     fzf
     zsh
     appimage-run
     unzip
     clang
     gnumake
     cmake
     meson
     doxygen
     gcc
     rustc 
     rustup 
     go
     zig_0_13
     racket
     jdk23
     maven
     nodejs_24
     udisks2
     pulseaudio
     pavucontrol
     pamixer
     emacs
     zathura
     spotify
     #spicetify-cli
     xdg-user-dirs
     foliate
     neofetch
     fastfetch
     whitesur-icon-theme
     cpufrequtils
     killall
     btop
     htop 
     alacritty
     kitty
     neovim
     wget
     curl 
     qbittorrent-enhanced
     zip
     yazi
     blueman
     lxappearance
     eww
     bspwm
     dunst
     xclip
     xdotool
     xdg-user-dirs-gtk
     i3lock-color
     maim
     nautilus
     xfce.thunar
     sxhkd
     brightnessctl 
     playerctl
     ncmpcpp
     cava
     polkit_gnome
     gtk-engine-murrine
     jq 
     rofi
     imagemagick
     xxHash
     xorg.xdpyinfo 
     xdg-user-dirs
     xdg-utils
     networkmanagerapplet
     polybar
     picom 
     feh
     obs-studio
     discord
     brave
     wasistlos
     teams-for-linux
  ]) ++ [
    python-packages			
 ];

# Fonts  
fonts = {
    packages = with pkgs; [
      dejavu_fonts
      fira-code
      fira-code-symbols
      font-awesome
      hackgen-nf-font
      ibm-plex
      inter
      jetbrains-mono
      material-icons
      maple-mono.NF
      minecraftia
      nerd-fonts.im-writing
      nerd-fonts.blex-mono
      nerd-fonts.jetbrains-mono
      nerd-fonts.ubuntu-mono
      nerd-fonts.symbols-only
      noto-fonts
      noto-fonts-emoji
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-monochrome-emoji
      powerline-fonts
      roboto
      roboto-mono
      symbola
      terminus_font
      victor-mono
    ];
  };

programs = {

  firefox.enable  = true; 
  git.enable = true; 
  nm-applet.indicator = true;
  
  thunar.enable = true; 

	thunar.plugins = with pkgs.xfce; [
	exo 
	mousepad 
	thunar-archive-plugin
	thunar-volman 
	tumbler
	];
	
	virt-manager.enable = false; 		

	 #steam = {
    #  enable = true;
    #  gamescopeSession.enable = true;
    #  remotePlay.openFirewall = true;
    #  dedicatedServer.openFirewall = true;
    #};

   dconf.enable = true;
    seahorse.enable = true;
    fuse.userAllowOther = true;
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

};

services = {
 xserver = {
	enable = true;
	displayManager.sddm.enable = true; 
	windowManager = {
	bspwm.enable = true;	
    };
  };
};

 # Extra Portal Configuration
  xdg.portal = {
    enable = true;
    wlr.enable = false;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
    configPackages = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal
    ];
    };

  }


{ config, pkgs, host, username, options, lib, inputs, system, ...}: let
  
  inherit (import ./variables.nix) keyboardLayout;
    
  in {
  imports = [
    ./hardware.nix
    ./users.nix
    ./packages-fonts.nix
    ../../modules/intel-drivers.nix
    ../../modules/vm-guest-services.nix
    ../../modules/local-hardware-clock.nix
  ];

  # BOOT related stuff
  boot = {
    kernelPackages = pkgs.linuxPackages_zen; # zen Kernel
    #kernelPackages = pkgs.linuxPackages_latest; # Kernel 

    kernelParams = [
      "systemd.mask=systemd-vconsole-setup.service"
      "systemd.mask=dev-tpmrm0.device" 
      "nowatchdog" 
      "modprobe.blacklist=sp5100_tco" 
      "modprobe.blacklist=iTCO_wdt" 
 	  ];

    # This is for OBS Virtual Cam Support
    #kernelModules = [ "v4l2loopback" ];
    #  extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
    
    initrd = { 
      availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
      kernelModules = [ ];
    };

    # Needed For Some Steam Games
    #kernel.sysctl = {
    #  "vm.max_map_count" = 2147483642;
    #};

    ## BOOT LOADERS: systemd or grub  
    # Bootloader SystemD
    loader.systemd-boot.enable = true;
  
    loader.efi = {
	    #efiSysMountPoint = "/efi"; # separate /efi partitions
	    canTouchEfiVariables = true;
  	  };
  
    loader.timeout = 5;    
		
    # Bootloader GRUB
    #loader.grub = {
	    #enable = true;
	    #  devices = [ "nodev" ];
	    #  efiSupport = true;
      #  gfxmodeBios = "auto";
	    #  memtest86.enable = true;
	    #  extraGrubInstallArgs = [ "--bootloader-id=${host}" ];
	    #  configurationName = "${host}";
  	  #	 };

    # Bootloader GRUB theme, configure below

    ## -end of BOOTLOADERS----- ##

 tmp = {
 useTmpfs = false;
 tmpfsSize = "30%"; 
};

#App Image Support 
binfmt.registrations.appimage = {
  wrapInterpreterInShell = false; 
  interpreter = "${pkgs.appimage-run}/bin/appimage-run";
  recognitionType = "magic"; 
  offset = 0; 
  mask = ''\xff\xff\xff\xff\x00\x00\x00\xff\xff\xff''; 
  magicOrExtension = ''\x7ELF....AI\x02''; 
  };

 plymouth.enable = true;
};

# GRUB Bootloader theme 
  #distro-grub-theme = {
  # enabled = true; 
  # theme = "nixos"; 
#};

 # Extra Module Options

 # Extra Module Options

 # Extra Module Options
  drivers = {
    intel.enable = true;
  };

# vm.guest-services.enabled = false; 
# local.hardware-clock.enabled = false; 

 # networking 
  networking = {
  networkmanager.enable = true; 
  hostName = "${host}";
  timeServers = options.networking.timeServers.default ++ [ "pool.ntp.org"]; 
};

 #Set time zone. 
 services.automatic-timezoned.enable = true;

 #time.timeZone = "America/Hermosillo"; 

 # Select internationalisation properties. 
 i18n.defaultLocale = "en_US.UTF-8";
 i18n.extraLocaleSettings = {
  LC_ADRESS = "en_US.UTF-8";
  LC_INDENTIFICATION = "en_US.UTF-8";
  LC_MEASUREMENT = "en_US.UTF-8";
  LC_MONETARY = "en_US.UTF-8";
  LC_NAME = "en_US.UTF-8";
  LC_NUMERIC = "en_US.UTF-8";
  LC_TIME = "en_US.UTF-8"; 
}; 


# Display manager 
  services.xserver.displayManager.sddm.enable = true;

services = {
#    xserver = {
#      enable = false;
#      xkb = {
#        layout = "${keyboardLayout}";
#        variant = "";
#      };
#    };
      
    smartd = {
      enable = false;
      autodetect = true;
    };
    
	  gvfs.enable = true;
	  tumbler.enable = true;

	  pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
	    wireplumber.enable = true;
      
      #Pipewire-pulse settings
    extraConfig.pipewire."context.properties" = {
      default.clock.rate = 192000;
      default.clock.quantum = 1024;
      default.clock.min-quantum = 32;
      default.clock.max-quantum = 8192;
      };  
   };
	
    #pulseaudio.enable = false; 
	  udev.enable = true;
	  envfs.enable = true;
	  dbus.enable = true;

    mpd = {
      enable = true; 
      user = "carlos";
      group = "users";
      
    };

	  fstrim = {
      enable = true;
      interval = "weekly";
      };
  
    libinput.enable = true;

    rpcbind.enable = false;
    nfs.server.enable = false;
  
    openssh.enable = true;
    flatpak.enable = true;
	
  	blueman.enable = true;
  	
  	#hardware.openrgb.enable = true;
  	#hardware.openrgb.motherboard = "amd";

	  fwupd.enable = true;

	  upower.enable = true;
    
    gnome.gnome-keyring.enable = true;
    
    #printing = {
    #  enable = false;
    #  drivers = [
        # pkgs.hplipWithPlugin
    #  ];
    #};
    
    #avahi = {
    #  enable = true;
    #  nssmdns4 = true;
    #  openFirewall = true;
    #};
    
    #ipp-usb.enable = true;
    
    #syncthing = {
    #  enable = false;
    #  user = "${username}";
    #  dataDir = "/home/${username}";
    #  configDir = "/home/${username}/.config/syncthing";
    #};

  };
  
  systemd.services.flatpak-repo = {
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };

  # zram
  zramSwap = {
	  enable = true;
	  priority = 100;
	  memoryPercent = 30;
	  swapDevices = 1;
    algorithm = "zstd";
    };

  powerManagement = {
  	enable = true;
	  cpuFreqGovernor = "schedutil";
  };

# hardware.sane = {
#  enable = true; 
#  extraBackends = [pkgs.sane-airscan]; 
#  disable = DeafaulBackends = [ "escl"]; 			
# };
#

services.pulseaudio.enable = false;  

 #Bluetooth 
 hardware = {
  logitech.wireless.enable = false;
  bluetooth = {
	enable = true;
	powerOnBoot = true; 
	settings = {
	   General = {
		Enable = "Source, Sink, Media, Socket";
		Experimental = true;
	       };
	  };
};
   graphics.enable = true;
   # openrgb.enable = true; 
   # openrgb.motherboard = "amd";
};

  # Security / Polkit
  security = { 
    rtkit.enable = true;
    polkit.enable = true;
    polkit.extraConfig = ''
     polkit.addRule(function(action, subject) {
       if (
         subject.isInGroup("users")
           && (
             action.id == "org.freedesktop.login1.reboot" ||
             action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
             action.id == "org.freedesktop.login1.power-off" ||
             action.id == "org.freedesktop.login1.power-off-multiple-sessions"
           )
         )
       {
         return polkit.Result.YES;
       }
    })
  '';
 };
  security.pam.services.swaylock = {
    text = ''
      auth include login
    '';
  };

 #Cachix, Optimizations settings and garbage collections automation 

 nix = {
   settings = {
   auto-optimise-store = true; 
   experimental-features = [
    "nix-command"
    "flakes"
	];
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];	
	};

  gc = {
   automatic = true;
   dates = "weekly";
   options = "--delete-older-than 7d"; 
   };
};
 
 # Virtualization/ Containers
 #virtualisation.libvirt.enable = false;
 virtualisation.podman = {
	enable = false; 
	dockerCompat = false; 
	defaultNetwork.settings.dns.enable = false; 
};

 console.keyMap = "${keyboardLayout}"; 

 # Electron apps to use wayland 
  environment.sessionVariables.NIXOS_OZONE_WL = "1"; 

 # Open ports in the firewall. 
 # networking.firewall.allowedTCPPorts = [ ... ]; 
 # networking.firewall.allowedTCPPorts = [ ... ]; 
 # Or disable firewall altogether. 
  networking.firewall.enable = false; 

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; 

}

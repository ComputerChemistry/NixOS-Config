{pkgs, username, ...}:

let 
   inherit (import ./variables.nix) gitUsername; 

in 
{
    users = {
	mutableUsers = true;
	users."${username}" = {
		homeMode = "755"; 
		isNormalUser = true;
		description = "${gitUsername}"; 
		extraGroups = [
		"networkmanager"
		"wheel"
		"libvirtd"
		"scanner"
		"lp"
		"video"
		"input"
		"audio"
	];

	packages = with pkgs; [

	 ];
	};
	
	defaultUserShell = pkgs.zsh;

	};

	environment.shells = with pkgs; [ zsh ]; 
	environment.systemPackages = with pkgs; [lsd fzf];

programs = {
  # Zsh configuration
	  zsh = {
    	enable = true;
	  	enableCompletion = true;
      ohMyZsh = {
        enable = true;
        plugins = ["git"];
        theme = "agnoster"; 
      	};
      
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      
      promptInit = ''
        alias e='emacsclient -c -n'
      
        fastfetch -c $HOME/.config/fastfetch/config-compact.jsonc
        source <(fzf --zsh);
        HISTFILE=~/.zsh_history;
        HISTSIZE=10000;
        SAVEHIST=10000;
        setopt appendhistory;
        '';
      };
   };
}

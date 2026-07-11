.PHONY: switch desktop thinkpad update

switch:
		sudo nixos-rebuild switch --flake .#$(HOST)

desktop:
		$(MAKE) switch HOST=desktop

thinkpad:
		$(MAKE) switch HOST=thinkpad

update:
		nix flake update

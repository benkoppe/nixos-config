## Local Machine

deploy:
	nixos-rebuild switch --flake .#nixos-test --use-remote-sudo

debug:
	nixos-rebuild switch --flake .#nixos-test --use-remote-sudo --show-trace --verbose

up:
	nix flake update

# Update specific input
# usage: just upp i=home-manager
upp:
	nix flake update $(i)

history:
	nix profile history --profile /nix/var/profiles/system

repl:
	nix repl -f flake:nixpkgs

clean:
	# remove all generations older than 7 days
	sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 7d

gc:
	# garbage collect all unused nix store entries
	sudo nix-collect-garbage --delete-old

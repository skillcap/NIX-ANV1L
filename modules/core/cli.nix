{ config, pkgs, lib, ... }:

let
  nixos-logo-png = pkgs.runCommand "nixos-logo.png" {
    buildInputs = [ pkgs.imagemagick ];
  } ''
    magick -density 1200 -background none ${pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/master/logo/nix-snowflake-colours.svg";
      hash = "sha256-43taHBHoFJbp1GrwSQiVGtprq6pBbWcKquSTTM6RLrI=";
    }} -resize 1000x1000 $out
  '';
in
{
  home.packages = with pkgs; [
    btop
    eza
    fd
    hwloc
    jq
    yq
    neovim
    nitch
    sd
    starship
    wiki-tui
    zellij
  ];

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      fish_vi_key_bindings
    '';
    shellAbbrs = {
      nrs = "sudo nixos-rebuild switch --flake /etc/nixos#$(hostname)";
      nrt = "sudo nixos-rebuild test --flake /etc/nixos#$(hostname)";
      nv = "nvim";
      cat = "bat";
      ls = "eza";
      l = "eza -la";
      cd = "z";
      ff = "fastfetch";
    };
    plugins = [
      {
        name = "bang-bang";
        src = pkgs.fishPlugins.bang-bang.src;
      }
      {
        name = "fzf-fish";
        src = pkgs.fishPlugins.fzf-fish.src;
        # requires fzf, fd, bat
      }
      {
        name = "done";
        src = pkgs.fishPlugins.done.src;
      }
      {
        name = "autopair";
        src = pkgs.fishPlugins.autopair.src;
      }
      {
        name = "puffer";
        src = pkgs.fishPlugins.puffer.src;
      }
    ];
  };

  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        source = "${nixos-logo-png}";
        type = "kitty-direct";
        width = 50;
        height = 25;
        padding = {
          top = 1;
          right = 2;
        };
      };
      modules = [
        "break"
        {
          type = "custom";
          format = "${builtins.fromJSON "\"\\u001b\""}[90m┌──────────────────────Hardware──────────────────────┐";
        }
        {
          type = "command";
          key = " PC";
          keyColor = "green";
          text = "hostname";
        }
        {
          type = "cpu";
          key = "│ ├";
          keyColor = "green";
        }
        {
          type = "gpu";
          key = "│ ├󰍛";
          keyColor = "green";
        }
        {
          type = "memory";
          key = "│ ├󰍛";
          keyColor = "green";
        }
        {
          type = "disk";
          key = "└ └";
          keyColor = "green";
        }
        {
          type = "custom";
          format = "${builtins.fromJSON "\"\\u001b\""}[90m└────────────────────────────────────────────────────┘";
        }
        "break"
        {
          type = "custom";
          format = "${builtins.fromJSON "\"\\u001b\""}[90m┌──────────────────────Software──────────────────────┐";
        }
        {
          type = "os";
          key = " OS";
          keyColor = "yellow";
        }
        {
          type = "kernel";
          key = "│ ├";
          keyColor = "yellow";
        }
        {
          type = "bios";
          key = "│ ├";
          keyColor = "yellow";
        }
        {
          type = "packages";
          key = "│ ├󰏖";
          keyColor = "yellow";
        }
        {
          type = "shell";
          key = "└ └";
          keyColor = "yellow";
        }
        "break"
        {
          type = "de";
          key = " DE";
          keyColor = "blue";
        }
        {
          type = "lm";
          key = "│ ├";
          keyColor = "blue";
        }
        {
          type = "wm";
          key = "│ ├";
          keyColor = "blue";
        }
        {
          type = "wmtheme";
          key = "│ ├󰉼";
          keyColor = "blue";
        }
        {
          type = "terminal";
          key = "└ └";
          keyColor = "blue";
        }
        {
          type = "custom";
          format = "${builtins.fromJSON "\"\\u001b\""}[90m└────────────────────────────────────────────────────┘";
        }
        "break"
        {
          type = "custom";
          format = "${builtins.fromJSON "\"\\u001b\""}[90m┌──────────────────Uptime / Age / DT─────────────────┐";
        }
        {
          type = "command";
          key = "  OS Age ";
          keyColor = "magenta";
          text = "birth_install=$(stat -c %W /); current=$(date +%s); time_progression=$((current - birth_install)); days_difference=$((time_progression / 86400)); echo $days_difference days";
        }
        {
          type = "uptime";
          key = "  Uptime ";
          keyColor = "magenta";
        }
        {
          type = "datetime";
          key = "  DateTime ";
          keyColor = "magenta";
        }
        {
          type = "custom";
          format = "${builtins.fromJSON "\"\\u001b\""}[90m└────────────────────────────────────────────────────┘";
        }
        {
          type = "colors";
          paddingLeft = 2;
          symbol = "circle";
        }
      ];
    };
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "tokyo-night";
      theme_background = false;
      vim_keys = true;
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
    settings = {
      opener = {
        edit = [ { run = "nvim \"$@\""; block = true; } ];
      };
      preview = {
        image_delay = 0;
        image_filter = "lanczos3";
        max_width = 1500;
        max_height = 1500;
      };
    };
  };

  programs.nushell.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  xdg.configFile = {
    "starship.toml".source = lib.mkForce (config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/starship.toml");
  };
}

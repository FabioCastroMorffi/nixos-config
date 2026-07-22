{ pkgs, ... }:

{

  programs.kitty = {
    enable = true;
    enableGitIntegration = true;
    font = {
      name = "FiraCode Nerd Font Mono";
      size = 12;
    };
    extraConfig = ''
      cursor_shape block
      cursor_shape_unfocused hollow

      # Trail
      cursor_trail 1
      cursor_trail_decay 0.1 0.4
      enable_audio_bell no

      #windows
      rememeber_window_size no
      initial_window_width 80c
      initial_window_height 24c
      window_margin_width 7.5
      window_padding_width 0
      hide_window_decorations yes

      #background
      background_opacity 0.65
      background_blur 1
    '';
  };

  # programs.rmpc = {
  #   enable = true;
  #   config = {
  #
  #
  #   };
  # };

}

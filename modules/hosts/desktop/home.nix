{ config, pkgs, ... }:
{
  flake.homeModules.homeDesktop = { pkgs, ... }: {
    home.username = "fabio";
    home.homeDirectory = "/home/fabio";

    # Example Home Manager options
    # programs.zsh.enable = true;
    programs.git = {
      enable = true;
      settings = {
        user = {
          name = "fabio";
          email = "fabiocastromorffi@gmail.com";
        };
      };
    };

    programs.bash = {
      enable = true;
      enableCompletion = true;
      historyIgnore = [
        "ls*"
        "cd*"
        "exit"
        "history*"
        "man *"
      ];
      initExtra = ''
        if [[ "$KITTY_WINDOW_ID" == "1" ]]; then
          fastfetch --logo ~/.config/assets/wooper_ascii.txt --structure-disabled colors --logo-position top --logo-color-1 94 --color-keys 117 --color-title 117
        fi

        unset PROMPT_COMMAND
        set_my_prompt() {
                # Using pure ANSI escapes ensures no dependency on 'tput' timing
                local COLOR_USER="\[\e[38;5;39m\]"
                local COLOR_AT="\[\e[38;5;45m\]"
                local COLOR_HOST="\[\e[38;5;51m\]"
                local COLOR_DIR="\[\e[38;5;195m\]"
                local COLOR_RESET="\[\e[0m\]"
                
                export PS1="''${COLOR_USER}\u''${COLOR_AT}@''${COLOR_HOST}\h ''${COLOR_DIR}\w''${COLOR_RESET}\$ "
        } 

        PROMPT_COMMAND=set_my_prompt
      '';

      sessionVariables = {
        PATH = "$HOME/.cargo/bin:$PATH";
      };

      shellAliases = {
        "vim" = "nvim";
        "ls" = "ls --color=auto";
        "grep" = "grep --color=auto";
        "fgrep" = "fgrep --color=auto";
        "egrep" = "egrep --color=auto";
      };
    };

    programs.dircolors = {
      enable = true;
      enableBashIntegration = true;
    };

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

    programs.rmpc = {
      enable = true;
      config = ''
#![enable(implicit_some)]
#![enable(unwrap_newtypes)]
#![enable(unwrap_variant_newtypes)]
(
    address: "127.0.0.1:3000",
    password: None,
    theme: "fallinuser_config.ron",
    cache_dir: None,
    lyrics_dir: "~/Music",
    lyrics_offset_ms: -5,
    on_song_change: None,
    volume_step: 5,
    max_fps: 30,
    scrolloff: 0,
    wrap_navigation: false,
    enable_mouse: true,
    enable_focus_events: true,
    scroll_amount: 1,
    enable_config_hot_reload: true,
    enable_lyrics_hot_reload: false,
    status_update_interval_ms: 1000,
    rewind_to_start_sec: None,
    keep_state_on_song_change: true,
    reflect_changes_to_playlist: false,
    select_current_song_on_change: false,
    on_exit: None,
    ignore_leading_the: false,
    browser_song_sort: [Disc, Track, Artist, Title],
    directories_sort: SortFormat(group_by_type: true, reverse: false),
    auto_open_downloads: true,
    quit_closes_modal: false,
    queue_disable_current_item_style_timeout_ms: None,
    album_art: (
        method: Auto,
        max_size_px: (width: 1200, height: 1200),
        disabled_protocols: ["http://", "https://"],
        vertical_align: Center,
        horizontal_align: Center,
    ),
    keybinds: (
        global: {
            "q":          Quit,
            "?":          ShowHelp,
            ":":          CommandMode,
            "oI":         ShowCurrentSongInfo,
            "oo":         ShowOutputs,
            "op":         ShowDecoders,
            "od":         ShowDownloads,
            "oP":         Partition(),
            "z":          ToggleRepeat,
            "x":          ToggleRandom,
            "c":          ToggleConsume,
            "v":          ToggleSingle,
            "p":          TogglePause,
            "s":          Stop,
            ">":          NextTrack,
            "<":          PreviousTrack,
            "f":          SeekForward,
            "b":          SeekBack,
            ".":          VolumeUp,
            ",":          VolumeDown,
            "<Tab>":      NextTab,
            "gt":         NextTab,
            "<S-Tab>":    PreviousTab,
            "gT":         PreviousTab,
            "1":          SwitchToTab("Queue"),
            "2":          SwitchToTab("Directories"),
            "3":          SwitchToTab("Artists"),
            "4":          SwitchToTab("Album Artists"),
            "5":          SwitchToTab("Albums"),
            "6":          SwitchToTab("Playlists"),
            "7":          SwitchToTab("Search"),
            "u":          Update,
            "U":          Rescan,
            "R":          AddRandom,
        },
        navigation: {
            "<C-c>":      Close,
            "<Esc>":      Close,
            "<CR>":       Confirm,
            "k":          Up,
            "<Up>":       Up,
            "j":          Down,
            "<Down>":     Down,
            "h":          Left,
            "<Left>":     Left,
            "l":          Right,
            "<Right>":    Right,
            "<C-w>k":     PaneUp,
            "<C-Up>":     PaneUp,
            "<C-w>j":     PaneDown,
            "<C-Down>":   PaneDown,
            "<C-w>h":     PaneLeft,
            "<C-Left>":   PaneLeft,
            "<C-w>l":     PaneRight,
            "<C-Right>":  PaneRight,
            "K":          MoveUp,
            "J":          MoveDown,
            "<C-u>":      UpHalf,
            "<C-d>":      DownHalf,
            "<C-b>":      PageUp,
            "<PageUp>":   PageUp,
            "<C-f>":      PageDown,
            "<PageDown>": PageDown,
            "gg":         Top,
            "G":          Bottom,
            "<Space>":    Select,
            "<C-Space>":  InvertSelection,
            "/":          EnterSearch,
            "n":          NextResult,
            "N":          PreviousResult,
            "a":          Add,
            "A":          AddAll,
            "D":          Delete,
            "<C-r>":      Rename,
            "i":          FocusInput,
            "oi":         ShowInfo,
            "<C-x>":      ContextMenu(),
            "<C-s>s":     Save(kind: Modal(all: false, duplicates_strategy: Ask)),
            "<C-s>a":     Save(kind: Modal(all: true, duplicates_strategy: Ask)),
            "r":          Rate(),
		},
        queue: {
            "d":          Delete,
            "D":          DeleteAll,
            "<CR>":       Play,
            "C":          JumpToCurrent,
            "X":          Shuffle,
        },
    ),
    search: (
        case_sensitive: false,
        ignore_diacritics: false,
        search_button: false,
        mode: Contains,
        tags: [
            (value: "any",         label: "Any Tag"),
            (value: "artist",      label: "Artist"),
            (value: "album",       label: "Album"),
            (value: "albumartist", label: "Album Artist"),
            (value: "title",       label: "Title"),
            (value: "filename",    label: "Filename"),
            (value: "genre",       label: "Genre"),
        ],
    ),
    artists: (
        album_display_mode: SplitByDate,
        album_sort_by: Date,
        album_date_tags: [Date],
    ),
    tabs: [
        (
            name: "Queue",
            pane: Split(
                direction: Horizontal,
                panes: [
                    (
                        size: "35%",
                        pane: Split(
                            direction: Vertical,
                            panes: [
                                (
                                    size: "100%",
                                    borders: "LEFT | RIGHT | TOP",
                                    border_symbols: Rounded,
                                    pane: Pane(AlbumArt)
                                ),
                                (
                                    size: "7",
                                    borders: "ALL",
                                    border_symbols: Inherited(parent: Rounded, top_left: "├", top_right: "┤",),
                                    border_title: [(kind: Text(" Lyrics "))],
                                    border_title_alignment: Right,
                                    pane: Pane(Lyrics)
                                ),
                            ],
                        ),
                    ),
                    (
                        size: "65%",
                        pane: Split(
                            direction: Vertical,
                            panes: [
                                (
                                    size: "3",
                                    borders: "ALL",
                                    border_symbols: Inherited(parent: Rounded, bottom_left: "├", bottom_right: "┤",),
                                    pane: Split(
                                        direction: Horizontal,
                                        panes: [
                                            (
                                                size: "1",
                                                pane: Pane(Empty())
                                            ),
                                            (
                                                size: "100%",
                                                pane: Pane(QueueHeader())
                                            ),
                                        ]
                                    )
                                ),
                                (
                                    size: "100%",
                                    borders: "LEFT | RIGHT | BOTTOM",
                                    border_symbols: Rounded,
                                    pane: Split(
                                        direction: Horizontal,
                                        panes: [
                                            (
                                                size: "1",
                                                pane: Pane(Empty())
                                            ),
                                            (
                                                size: "100%",
                                                pane: Pane(Queue)
                                            ),
                                        ]
                                    )
                                ),
                            ],
                        )
                    ),
                ],
            ),
        ),
        (
            name: "Directories",
            borders: "ALL",
            border_symbols: Rounded,
            pane: Split(
                size: "100%",
                direction: Vertical,
                panes: [(pane: Pane(Directories), size: "100%", borders: "ALL", border_symbols: Rounded)],
            )
        ),
        (
            name: "Artists",
            borders: "ALL",
            border_symbols: Rounded,
            pane: Split(
                size: "100%",
                direction: Vertical,
                panes: [(pane: Pane(Artists), size: "100%", borders: "ALL", border_symbols: Rounded)],
            )
        ),
        (
            name: "Album Artists",
            borders: "ALL",
            border_symbols: Rounded,
            pane: Split(
                size: "100%",
                direction: Vertical,
                panes: [(pane: Pane(AlbumArtists), size: "100%", borders: "ALL", border_symbols: Rounded)],
            )
        ),
        (
            name: "Albums",
            borders: "ALL",
            border_symbols: Rounded,
            pane: Split(
                size: "100%",
                direction: Vertical,
                panes: [(pane: Pane(Albums), size: "100%", borders: "ALL", border_symbols: Rounded)],
            )
        ),
        (
            name: "Playlists",
            borders: "ALL",
            border_symbols: Rounded,
            pane: Split(
                size: "100%",
                direction: Vertical,
                panes: [(pane: Pane(Playlists), size: "100%", borders: "ALL", border_symbols: Rounded)],
            )
        ),
        (
            name: "Search",
            borders: "ALL",
            border_symbols: Rounded,
            pane: Split(
                size: "100%",
                direction: Vertical,
                panes: [(pane: Pane(Search), size: "100%", borders: "ALL", border_symbols: Rounded)],
            )
        ),
    ],
)
      '';
    };
    
    # Theme for rmpc
    xdg.configFile."rmpc/themes/fallinuser_config.ron".text = ''

#![enable(implicit_some)]
#![enable(unwrap_newtypes)]
#![enable(unwrap_variant_newtypes)]
(
    default_album_art_path: None,
    show_song_table_header: true,
    draw_borders: true,
    format_tag_separator: " | ",
    browser_column_widths: [20, 38, 42],
    background_color:"#181825",
    text_color: "#dfe1eb",
    header_background_color: None,
    modal_background_color: None,
    modal_backdrop: false,
    preview_label_style: (fg: "#9399b2"),
    preview_metadata_group_style: (fg: "#9399b2", modifiers: "Bold"),
    tab_bar: (
        enabled: true,
        active_style: (fg: "#181825", bg: "#adacb2", modifiers: "Bold"),
        inactive_style: (),
    ),
    highlighted_item_style: (fg: "#a6adc8", modifiers: "Bold"),
    current_item_style: (fg: "#181825", bg: "#adacb2", modifiers: "Bold"),
    borders_style: (fg: "#a6adc8"),
    highlight_border_style: (fg: "#adacb2"),
    symbols: (
        song: "S",
        dir: " ",
        playlist: "󰲸 ",
        marker: "󰘍  ",
        ellipsis: "...",
        song_style: None,
        dir_style: None,
        playlist_style: None,
    ),
    level_styles: (
        info: (fg: "#adacb2", bg: "#181825"),
        warn: (fg: "#9399b2", bg: "#181825"),
        error: (fg: "red", bg: "#181825"),
        debug: (fg: "light_green", bg: "#181825"),
        trace: (fg: "magenta", bg: "#181825"),
    ),
    progress_bar: (
        symbols: ["", "█", "◣", "█", "█" ],
        track_style: (fg: "#1e2030"),
        elapsed_style: (fg: "#a6adc8"),
        thumb_style: (fg: "#a6adc8", bg: "#1e2030"),
    ),
    cava: (
    bar_symbols: ['▁', '▂', '▃', '▄', '▅', '▆', '▇', '█'],
    bar_width: 2,
    bar_spacing: 1,
    bar_color: Gradient({

          0: "#45475a",

         50: "#6c7086",

        100: "#b4befe",

    })
    ),
    scrollbar: (
        symbols: ["│", "█", "⊤", "⊥"],
        track_style: (),
        ends_style: (),
        thumb_style: (fg: "#a6adc8"),
    ),
    song_table_format: [
        (
            prop: (kind: Property(Artist),
                default: (kind: Text("Unknown"))
            ),
            width: "33%",
        ),
        (
            prop: (kind: Property(Title),
                default: (kind: Text("Unknown"))
            ),
            width: "33%",
            alignment: Center,
        ),
        (
            prop: (kind: Property(Duration),
                default: (kind: Text("-"))
            ),
            width: "33%",
            alignment: Right,
        ),
    ],
    components: {},
layout: Split(
    direction: Vertical,
    panes: [
        (
            size: "4",
            borders: "ALL",
            pane: Pane(Header),
        ),
        (
            size: "3",
            pane: Pane(Tabs),
        ),
        (
            size: "100%",
            borders: "ALL",
            pane: Pane(TabContent),
        ),
        (
            size: "3",
            borders: "ALL",
            pane: Pane(ProgressBar),
        ),
    ],
),
    header: (
        rows: [
            (
                left: [
                    (kind: Text("|"), style: (fg: "#a6adc8", modifiers: "Bold")),
                    (kind: Property(Status(StateV2(playing_label: "Playing", paused_label: "Paused", stopped_label: "Stopped"))), style: (fg: "#a6adc8", modifiers: "Bold")),
                    (kind: Text("|"), style: (fg: "#a6adc8", modifiers: "Bold"))
                ],
                center: [
                    (kind: Property(Song(Title)), style: (modifiers: "Bold"),
                        default: (kind: Text("No Song"), style: (modifiers: "Bold"))
                    )
                ],
                right: [
                    (kind: Property(Widget(ScanStatus)), style: (fg: "#a6adc8")),
                    (kind: Property(Widget(Volume)), style: (fg: "#a6adc8"))
                ]
            ),
            (
                left: [
                    (kind: Property(Status(Elapsed))),
                    (kind: Text(" / ")),
                    (kind: Property(Status(Duration))),
                ],
                center: [
                    (kind: Property(Song(Artist)), style: (fg: "#9399b2", modifiers: "Bold"),
                        default: (kind: Text("Unknown"), style: (fg: "#9399b2", modifiers: "Bold"))
                    ),
                    (kind: Text(" - ")),
                    (kind: Property(Song(Album)),
                        default: (kind: Text("Unknown Album"))
                    )
                ],
                right: [
                    (
                        kind: Property(Widget(States(
                            active_style: (fg: "white", modifiers: "Bold"),
                            separator_style: (fg: "white")))
                        ),
                        style: (fg: "#9399b2")
                    ),
                ]
            ),
        ],
    ),
    browser_song_format: [
        (
            kind: Group([
                (kind: Property(Track)),
                (kind: Text(" ")),
            ])
        ),
        (
            kind: Group([
                (kind: Property(Artist)),
                (kind: Text(" - ")),
                (kind: Property(Title)),
            ]),
            default: (kind: Property(Filename))
        ),
    ],
    lyrics: (
        timestamp: false
    )
)
    '';

    home.packages = with pkgs; [
      slack
      yazi

      # Snip
      grim
      slurp
      wl-clipboard

      # Games
      lutris
    ];

    # programs.starship = {
    #   enable = true;
    #   enableBashIntegration = true;
    #   settings = {
    #     # single-line layout
    #     add_newline = false;
    #
    #     format = "$directory$git_branch$git_status$character";
    #     directory = {
    #       truncation_length = 3;
    #       truncate_to_repo = true;
    #       style = "bold cyan";
    #     };
    #
    #     git_branch = {
    #         format = "on [$symbol$branch]($style) ";
    #         symbol = "⌥";
    #         style = "bold purple";
    #     };
    #
    #     git_status = {
    #       format = "[\\[$all_status$num_status\\]]($style) ";
    #       style = "bold red";
    #     };
    #
    #     character = {
    #       success_symbol = "[❯](bold green)";
    #       error_symbol = "[❯](bold red)";
    #     };
    #   };
    # };

    home.file = {
      # This creates a file at ~/.config/assets/
      ".config/assets/wooper_ascii.txt".text = ''
                    ..........		
               .~!7?YPPPPPPPPPJ!77.
     :      ^7Y5JYYJ77777777JYYY55J^   ^YG. .^
  J~ :P5^ :J5J77777777777777777777J5J: ~G@P:7#....
.?@7 :P@7~GJ777777777777777777777777?#7 ^P@Y&GGG5!
:G#G55P##PJ7777777777777777777777777JYP5YGBGPG#Y^
:5#YY&#&#5!777777777777777777777777?&G##B#@? .7B!
:Y^  ~@5GP!7777777777777777777777777?5&P^&B&5  .
    !#P.?PY77777777777777777777777777JP? ^557
    :!   ~PJ777777777777777777777777J#!
          .J5J??7777777777777777??J5J:
            :?5Y55J?77777777?YYYY5?:
               .!~P#P??????7?5#J         ^^?555~.
                 ?5Y7J5PP5J777?55^     ~Y55J???55!
               .7GJ7JJ????JJ?77GYY^.77Y5?777777!BP
               ^@?!7J5YYYY5J777!B&5YY?77777777JG]
               .75J?YY????YY?777?BBJ?777777JJ5?:
               .~?BYB5YY5J7JP5YJ?JY55555YY?:
              ~PJJJYP#P55555GGPP55J
              :?555P5!      JP?JJJP
              ~JJJJJ!       ~JJJJJ!
      '';

      ".local/share/applications/pokemon_reloaded.desktop".text = ''
          [Desktop Entry]
          Type=Application
          Name=Pokemon Reloaded
          Exec=/home/fabio/.config/assets/pokemon_reloaded
          Icon=/home/fabio/Pictures/reloaded.png
          Terminal=false
      '';

      # You can also create executable scripts this way
      ".config/assets/snip".text = ''
          #!/usr/bin/env bash
          grim -g "$(slurp)" - | wl-copy
      '';
      ".config/assets/snip".executable = true;

      ".config/assets/pokemon_reloaded".text = ''
          #!/usr/bin/env bash
          cd /home/fabio/games/Proyecto\ Reloaded\ The\ Last\ Beta\ 1.9.1\ Full && wine /home/fabio/games/Proyecto\ Reloaded\ The\ Last\ Beta\ 1.9.1\ Full/Proyecto\ Reloaded\ The\ Last\ Beta\ 1.9.1\ Full.exe
      '';
      ".config/assets/pokemon_reloaded".executable = true;

    };

    home.stateVersion = "26.05";
  };
}

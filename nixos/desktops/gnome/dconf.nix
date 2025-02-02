# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.enable = true;
  dconf.settings = {
    "org/gnome/boxes" = {
      first-run = false;
      view = "list-view";
      window-maximized = false;
    };

    "org/gnome/calculator" = {
      accuracy = 9;
      angle-units = "degrees";
      base = 10;
      button-mode = "basic";
      number-format = "automatic";
      show-thousands = false;
      show-zeroes = false;
      source-currency = "";
      source-units = "degree";
      target-currency = "";
      target-units = "radian";
      window-maximized = false;
      word-size = 64;
    };

    "org/gnome/calendar" = {
      active-view = "month";
      window-maximized = false;
    };

    "org/gnome/desktop/calendar" = {
      show-weekdate = true;
    };

    "org/gnome/desktop/datetime" = {
      automatic-timezone = true;
    };

    "org/gnome/desktop/input-sources" = {
      sources = [ (mkTuple [ "xkb" "us" ]) ];
      xkb-options = [ "ctrl:swapcaps" ];
    };

    "org/gnome/desktop/interface" = {
      clock-format = "12h";
      color-scheme = "prefer-dark";
      cursor-theme = "Adwaita";
      enable-animations = true;
      font-antialiasing = "grayscale";
      font-hinting = "slight";
      font-name = "Ubuntu 11";
      gtk-theme = "Adwaita";
      icon-theme = "Adwaita";
      locate-pointer = true;
      show-battery-percentage = true;
    };

    "org/gnome/desktop/peripherals/mouse" = {
      natural-scroll = false;
      speed = 0.517786561264822;
    };

    "org/gnome/desktop/peripherals/stylus/8b808d34" = {
      eraser-pressure-curve = [ 0 0 100 100 ];
      pressure-curve = [ 25 0 100 75 ];
      secondary-button-action = "default";
    };

    "org/gnome/desktop/peripherals/tablets/056a:0357" = {
      keep-aspect = true;
      mapping = "absolute";
      output = [ "HWP" "HP 27es" "3CM6310RWK   " ];
    };

    "org/gnome/desktop/peripherals/tablets/056a:0357/buttonA" = {
      action = "keybinding";
      keybinding = "v";
    };

    "org/gnome/desktop/peripherals/tablets/056a:0357/buttonB" = {
      action = "keybinding";
      keybinding = "<Control>z";
    };

    "org/gnome/desktop/peripherals/tablets/056a:0357/buttonC" = {
      action = "keybinding";
      keybinding = "<Shift><Control>z";
    };

    "org/gnome/desktop/peripherals/tablets/056a:0357/buttonD" = {
      action = "keybinding";
      keybinding = "p";
    };

    "org/gnome/desktop/peripherals/tablets/056a:0357/buttonE" = {
      action = "keybinding";
      keybinding = "<Control>0";
    };

    "org/gnome/desktop/peripherals/tablets/056a:0357/buttonF" = {
      action = "keybinding";
      keybinding = "<Control>minus";
    };

    "org/gnome/desktop/peripherals/tablets/056a:0357/buttonG" = {
      action = "keybinding";
      keybinding = "<Control>equal";
    };

    "org/gnome/desktop/peripherals/tablets/056a:0357/buttonH" = {
      action = "keybinding";
      keybinding = "space";
    };

    "org/gnome/desktop/peripherals/tablets/056a:0357/ringA-ccw-mode-0" = {
      action = "keybinding";
      keybinding = "<Control>minus";
    };

    "org/gnome/desktop/peripherals/tablets/056a:0357/ringA-cw-mode-0" = {
      action = "keybinding";
      keybinding = "<Control>equal";
    };

    "org/gnome/desktop/peripherals/tablets/056a:0360" = {
      keep-aspect = true;
      output = [ "AUS" "ASUS MB16AMT" "K8LMTF083442" ];
    };

    "org/gnome/desktop/peripherals/tablets/056a:0360/buttonA" = {
      action = "keybinding";
      keybinding = "v";
    };

    "org/gnome/desktop/peripherals/tablets/056a:0360/buttonB" = {
      action = "keybinding";
      keybinding = "<Primary>z";
    };

    "org/gnome/desktop/peripherals/tablets/056a:0360/buttonC" = {
      action = "keybinding";
      keybinding = "<Primary>y";
    };

    "org/gnome/desktop/peripherals/tablets/056a:0360/buttonD" = {
      action = "keybinding";
      keybinding = "p";
    };

    "org/gnome/desktop/peripherals/tablets/056a:0360/buttonE" = {
      action = "keybinding";
      keybinding = "<Primary>0";
    };

    "org/gnome/desktop/peripherals/tablets/056a:0360/buttonF" = {
      action = "keybinding";
      keybinding = "<Primary>minus";
    };

    "org/gnome/desktop/peripherals/tablets/056a:0360/buttonG" = {
      action = "keybinding";
      keybinding = "<Primary>equal";
    };

    "org/gnome/desktop/peripherals/tablets/056a:0360/buttonH" = {
      action = "keybinding";
      keybinding = "space";
    };

    "org/gnome/desktop/peripherals/tablets/056a:0360/ringA-ccw-mode-0" = {
      action = "keybinding";
      keybinding = "<Primary>minus";
    };

    "org/gnome/desktop/peripherals/tablets/056a:0360/ringA-cw-mode-0" = {
      action = "keybinding";
      keybinding = "<Primary>equal";
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      speed = 0.38773946360153255;
      two-finger-scrolling-enabled = true;
    };

    "org/gnome/desktop/privacy" = {
      old-files-age = mkUint32 30;
      recent-files-max-age = -1;
      report-technical-problems = true;
    };

    "org/gnome/desktop/session" = {
      idle-delay = mkUint32 0;
    };

    "org/gnome/desktop/sound" = {
      allow-volume-above-100-percent = true;
      event-sounds = true;
    };

    "org/gnome/desktop/wm/keybindings" = {
      close = [ "<Alt>w" ];
      switch-applications = [ "<Super>Tab" ];
      switch-applications-backward = [ "<Shift><Super>Tab" ];
      move-to-workspace-1 = [ "<Shift><Alt>1" ];
      move-to-workspace-2 = [ "<Shift><Alt>2" ];
      move-to-workspace-3 = [ "<Shift><Alt>3" ];
      switch-to-workspace-1 = [ "<Alt>1" ];
      switch-to-workspace-2 = [ "<Alt>2" ];
      switch-to-workspace-3 = [ "<Alt>3" ];
      switch-to-workspace-left = [ "<Alt>bracketleft" ];
      switch-to-workspace-right = [ "<Alt>bracketright" ];
      switch-windows = [ "<Alt>Tab" ];
      switch-windows-backward = [ "<Shift><Alt>Tab" ];
      toggle-maximized = [ "<Shift><Control>equal" ];
    };

    "org/gnome/desktop/wm/preferences" = {
      num-workspaces = 3;
    };

    "org/gnome/evince/default" = {
      continuous = true;
      dual-page = false;
      dual-page-odd-left = true;
      enable-spellchecking = true;
      fullscreen = false;
      inverted-colors = false;
      show-sidebar = true;
      sidebar-page = "thumbnails";
      sidebar-size = 148;
      sizing-mode = "automatic";
      window-ratio = mkTuple [ 1.9092436974789917 0.7505938242280285 ];
    };

    "org/gnome/mutter" = {
      center-new-windows = true;
      dynamic-workspaces = false;
      experimental-features = [];
      workspaces-only-on-primary = true;
    };

    "org/gnome/mutter/keybindings" = {
      toggle-tiled-left = [ "<Shift><Control>bracketleft" ];
      toggle-tiled-right = [ "<Shift><Control>bracketright" ];
    };

    "org/gnome/nautilus/compression" = {
      default-compression-format = "zip";
    };

    "org/gnome/nautilus/list-view" = {
      default-column-order = [ "name" "size" "type" "owner" "group" "permissions" "where" "date_modified" "date_modified_with_time" "date_accessed" "date_created" "recency" "detailed_type" ];
      default-visible-columns = [ "name" "size" "date_modified" ];
    };

    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "list-view";
      migrated-gtk-settings = true;
      search-filter-time-type = "last_modified";
      search-view = "list-view";
    };

    # Etc.
    # "org/gnome/portal/filechooser/rambox" = {
    #   last-folder-path = "/home/kylecoberly/Videos";
    # };

    "org/gnome/settings-daemon/plugins/power" = {
      power-button-action = "suspend";
      sleep-inactive-ac-timeout = 3600;
      sleep-inactive-ac-type = "nothing";
    };

    "org/gnome/shell" = {
      disable-user-extensions = false;
      disabled-extensions = [ ];
      enabled-extensions = [ "just-perfection-desktop@just-perfection" "ubuntu-dock@ubuntu.com" "ubuntu-appindicators@ubuntu.com" ];
      favorite-apps = [ "org.gnome.Nautilus.desktop" "Zoom.desktop" "google-chrome.desktop" "Alacritty.desktop" ];
      had-bluetooth-devices-setup = true;
      last-selected-power-profile = "performance";
      welcome-dialog-last-shown-version = "43.0";
    };

    "org/gnome/shell/app-switcher" = {
      current-workspace-only = true;
    };

    "org/gnome/shell/extensions/dash-to-dock" = {
      background-opacity = 0.8;
      dash-max-icon-size = 48;
      dock-fixed = false;
      dock-position = "LEFT";
      height-fraction = 0.9;
      isolate-workspaces = true;
      preferred-monitor = -2;
      preferred-monitor-by-connector = "eDP-1";
    };

    "org/gnome/shell/extensions/ding" = {
      check-x11wayland = true;
      show-home = false;
    };

    "org/gnome/shell/extensions/just-perfection" = {
      accessibility-menu = false;
      dash-icon-size = 64;
      events-button = true;
      keyboard-layout = true;
      max-displayed-search-results = 0;
      panel = true;
      panel-in-overview = true;
      ripple-box = false;
      search = false;
      show-apps-button = false;
      startup-status = 0;
      theme = true;
      weather = true;
      window-demands-attention-focus = true;
      window-maximized-on-create = false;
      window-picker-icon = true;
      workspace = true;
      workspace-peek = true;
      workspace-switcher-should-show = true;
      workspace-wrap-around = true;
      workspaces-in-app-grid = false;
      world-clock = true;
    };

    "org/gnome/simple-scan" = {
      jpeg-quality = 84;
      page-side = "front";
      photo-dpi = 1200;
      save-directory = "file:///home/kylecoberly/Pictures/Scans/";
      save-format = "image/png";
      text-dpi = 600;
    };

    "org/gnome/terminal/legacy/profiles:/:30eaa304-cfa1-49a6-9596-63b5aac24099" = {
      allow-bold = true;
      background-color = "#282828282828";
      bold-color = "#ebebdbdbb2b2";
      bold-color-same-as-fg = true;
      cursor-background-color = "#ebebdbdbb2b2";
      cursor-colors-set = true;
      cursor-foreground-color = "#282828282828";
      font = "NotoMono Nerd Font Mono 16";
      foreground-color = "#ebebdbdbb2b2";
      palette = [ "#282828282828" "#cccc24241d1d" "#989897971a1a" "#d7d799992121" "#454585858888" "#b1b162628686" "#68689d9d6a6a" "#a8a899998484" "#929283837474" "#fbfb49493434" "#b8b8bbbb2626" "#fafabdbd2f2f" "#8383a5a59898" "#d3d386869b9b" "#8e8ec0c07c7c" "#ebebdbdbb2b2" ];
      use-system-font = false;
      use-theme-background = false;
      use-theme-colors = false;
      use-theme-transparency = false;
      visible-name = "Gruvbox Dark";
    };

    "org/gnome/terminal/legacy/profiles:/:8bd61f7f-3b26-4b10-9438-36b6294263d5" = {
      allow-bold = true;
      background-color = "#fbfbf1f1c7c7";
      bold-color = "#3c3c38383636";
      bold-color-same-as-fg = true;
      cursor-background-color = "#3c3c38383636";
      cursor-colors-set = true;
      cursor-foreground-color = "#fbfbf1f1c7c7";
      foreground-color = "#3c3c38383636";
      palette = [ "#fbfbf1f1c7c7" "#cccc24241d1d" "#989897971a1a" "#d7d799992121" "#454585858888" "#b1b162628686" "#68689d9d6a6a" "#7c7c6f6f6464" "#929283837474" "#9d9d00000606" "#797974740e0e" "#b5b576761414" "#070766667878" "#8f8f3f3f7171" "#42427b7b5858" "#3c3c38383636" ];
      use-theme-background = false;
      use-theme-colors = false;
      use-theme-transparency = false;
      visible-name = "Gruvbox";
    };

    "org/gnome/terminal/legacy/profiles:/:a49b6940-a9ef-4922-b874-574cad1da151" = {
      background-transparency-percent = 29;
      bold-color = "rgb(250,189,47)";
      bold-color-same-as-fg = false;
      cursor-background-color = "rgb(235,219,178)";
      cursor-foreground-color = "rgb(69,133,136)";
      font = "Source Code Pro 16";
      highlight-background-color = "rgb(131,165,152)";
      highlight-foreground-color = "rgb(251,241,199)";
      palette = [ "rgb(40,40,40)" "rgb(204,36,29)" "rgb(152,151,26)" "rgb(215,153,33)" "rgb(69,133,136)" "rgb(177,98,134)" "rgb(104,157,106)" "rgb(168,153,132)" "rgb(146,131,116)" "rgb(251,73,52)" "rgb(184,187,38)" "rgb(250,189,47)" "rgb(131,165,152)" "rgb(211,134,155)" "rgb(142,192,124)" "rgb(235,219,178)" ];
      scrollbar-policy = "never";
      use-theme-transparency = false;
      use-transparent-background = true;
      visible-name = "Gruvbox";
    };

    "org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9" = {
      audible-bell = false;
      background-color = "rgb(23,20,33)";
      font = "Fira Code 14";
      foreground-color = "rgb(208,207,204)";
      login-shell = false;
      palette = [ "rgb(7,54,66)" "rgb(220,50,47)" "rgb(133,153,0)" "rgb(181,137,0)" "rgb(38,139,210)" "rgb(211,54,130)" "rgb(42,161,152)" "rgb(238,232,213)" "rgb(0,43,54)" "rgb(203,75,22)" "rgb(88,110,117)" "rgb(101,123,131)" "rgb(131,148,150)" "rgb(108,113,196)" "rgb(147,161,161)" "rgb(253,246,227)" ];
      use-system-font = false;
      use-theme-colors = false;
    };

    "org/gtk/gtk4/settings/file-chooser" = {
      clock-format = "12h";
      date-format = "regular";
      location-mode = "path-bar";
      show-hidden = true;
      show-size-column = true;
      show-type-column = true;
      sidebar-width = 167;
      sort-column = "name";
      sort-directories-first = true;
      sort-order = "ascending";
      type-format = "category";
      view-type = "list";
      window-size = mkTuple [ 1920 1051 ];
    };

    "org/gtk/settings/color-chooser" = {
      custom-colors = [ (mkTuple [ 0.23529411764705882 0.7058823529411765 0.29411764705882354 1.0 ]) ];
      selected-color = mkTuple [ true 0.0 0.0 0.0 1.0 ];
    };

    "org/gtk/settings/file-chooser" = {
      clock-format = "12h";
      date-format = "regular";
      location-mode = "path-bar";
      show-hidden = false;
      show-size-column = true;
      show-type-column = true;
      sidebar-width = 212;
      sort-column = "name";
      sort-directories-first = true;
      sort-order = "ascending";
      type-format = "category";
      window-position = mkTuple [ 26 23 ];
      window-size = mkTuple [ 1920 1004 ];
    };
  };
}

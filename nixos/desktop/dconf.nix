# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "apps/update-manager" = {
      first-run = false;
      launch-count = 150;
      launch-time = mkInt64 1737440357;
    };

    "ca/desrt/dconf-editor" = {
      saved-pathbar-path = "/apps/";
      saved-view = "/";
      show-warning = false;
      window-height = 500;
      window-is-maximized = false;
      window-width = 540;
    };

    "com/mattjakeman/ExtensionManager" = {
      is-maximized = false;
      last-used-version = "0.5.0";
    };

    "com/ubuntu/update-notifier" = {
      release-check-time = mkUint32 1737419290;
    };

    "desktop/ibus/general" = {
      preload-engines = [ "xkb:us::eng" ];
      version = "1.5.27";
    };

    "org/blueman/general" = {
      window-properties = [ 960 482 160 269 ];
    };

    "org/blueman/plugins/powermanager" = {
      auto-power-on = true;
    };

    "org/blueman/plugins/recentconns" = {
      recent-connections = [ {
        adapter = "4C:1D:96:DA:89:81";
        address = "AC:80:0A:27:D9:EE";
        alias = "WF-1000XM5";
        icon = "audio-headset";
        name = "Audio and input profiles";
        uuid = "00000000-0000-0000-0000-000000000000";
        time = "1695440866.0259454";
      } ];
    };

    "org/gnome/Disks" = {
      image-dir-uri = "file:///home/kylecoberly/Downloads";
    };

    "org/gnome/Totem" = {
      active-plugins = [ "screenshot" "vimeo" "autoload-subtitles" "rotation" "variable-rate" "open-directory" "mpris" "movie-properties" "recent" "save-file" "screensaver" "apple-trailers" "skipto" ];
      subtitle-encoding = "UTF-8";
    };

    "org/gnome/baobab/ui" = {
      is-maximized = false;
      window-size = mkTuple [ 960 600 ];
    };

    "org/gnome/boxes" = {
      first-run = false;
      shared-folders = "[<{'uuid': <'1c3fe670-cf29-4968-8e63-a2ebad52550b'>, 'path': <'/home/kylecoberly/Public'>, 'name': <'NixOS'>}>]";
      view = "list-view";
      window-maximized = true;
      window-position = [ 26 23 ];
      window-size = [ 768 600 ];
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
      window-size = mkTuple [ 349 500 ];
      word-size = 64;
    };

    "org/gnome/calendar" = {
      active-view = "month";
      window-maximized = true;
      window-size = mkTuple [ 768 600 ];
    };

    "org/gnome/cheese" = {
      burst-delay = 1000;
      camera = "Integrated_Webcam_HD (V4L2)";
      photo-x-resolution = 1280;
      photo-y-resolution = 720;
      video-x-resolution = 1280;
      video-y-resolution = 720;
    };

    "org/gnome/control-center" = {
      last-panel = "system";
      window-state = mkTuple [ 960 508 true ];
    };

    "org/gnome/deja-dup" = {
      backend = "google";
      prompt-check = "2025-01-21T05:33:42.746517Z";
    };

    "org/gnome/desktop/app-folders" = {
      folder-children = [ "Utilities" "YaST" ];
    };

    "org/gnome/desktop/app-folders/folders/Utilities" = {
      apps = [ "gnome-abrt.desktop" "gnome-system-log.desktop" "nm-connection-editor.desktop" "org.gnome.baobab.desktop" "org.gnome.Connections.desktop" "org.gnome.DejaDup.desktop" "org.gnome.Dictionary.desktop" "org.gnome.DiskUtility.desktop" "org.gnome.eog.desktop" "org.gnome.Evince.desktop" "org.gnome.FileRoller.desktop" "org.gnome.fonts.desktop" "org.gnome.seahorse.Application.desktop" "org.gnome.tweaks.desktop" "org.gnome.Usage.desktop" "vinagre.desktop" ];
      categories = [ "X-GNOME-Utilities" ];
      name = "X-GNOME-Utilities.directory";
      translate = true;
    };

    "org/gnome/desktop/app-folders/folders/YaST" = {
      categories = [ "X-SuSE-YaST" ];
      name = "suse-yast.directory";
      translate = true;
    };

    "org/gnome/desktop/background" = {
      color-shading-type = "solid";
      picture-options = "zoom";
      picture-uri = "file:///usr/share/backgrounds/Northan_lights_by_mizuno.webp";
      picture-uri-dark = "file:///usr/share/backgrounds/Northan_lights_by_mizuno.webp";
      primary-color = "#000000";
      secondary-color = "#000000";
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

    "org/gnome/desktop/notifications" = {
      application-children = [ "firefox-firefox" "org-gnome-tweaks" "org-gnome-terminal-preferences" "org-gnome-fileroller" "discord-discord" "io-snapcraft-sessionagent" "gnome-network-panel" "slack-slack" "org-gnome-dejadup" "gnome-printers-panel" "update-manager" "zoom" "snap-store-ubuntu-software" "teams" "org-gnome-eog" "org-gnome-nautilus" "miro-miro" "org-gnome-terminal" "org-gnome-settings" "gnome-power-panel" "balena-etcher" "google-chrome" "gnome-datetime-panel" "apport-gtk" "todoist-todoist" "org-gnome-shell-portalhelper" "code-code" "fr-handbrake-ghb" "alacritty" "com-mattjakeman-extensionmanager-desktop" "virtualbox" "virt-manager" "rambox" "vlc" "gnome-system-monitor" "obs-studio-obs-studio" "org-gnome-boxes" "simple-scan" "gimp-gimp" "com-obsproject-studio" "obsidian" "rambox-rambox" "snapd-desktop-integration-snapd-desktop-integration" "com-mattjakeman-extensionmanager" "ca-desrt-dconf-editor" ];
      show-banners = false;
    };

    "org/gnome/desktop/notifications/application/alacritty" = {
      application-id = "Alacritty.desktop";
    };

    "org/gnome/desktop/notifications/application/apport-gtk" = {
      application-id = "apport-gtk.desktop";
    };

    "org/gnome/desktop/notifications/application/balena-etcher" = {
      application-id = "balena-etcher.desktop";
    };

    "org/gnome/desktop/notifications/application/ca-desrt-dconf-editor" = {
      application-id = "ca.desrt.dconf-editor.desktop";
    };

    "org/gnome/desktop/notifications/application/code-code" = {
      application-id = "code_code.desktop";
    };

    "org/gnome/desktop/notifications/application/com-mattjakeman-extensionmanager-desktop" = {
      application-id = "com.mattjakeman.ExtensionManager.desktop.desktop";
    };

    "org/gnome/desktop/notifications/application/com-mattjakeman-extensionmanager" = {
      application-id = "com.mattjakeman.ExtensionManager.desktop";
    };

    "org/gnome/desktop/notifications/application/com-obsproject-studio" = {
      application-id = "com.obsproject.Studio.desktop";
    };

    "org/gnome/desktop/notifications/application/discord-discord" = {
      application-id = "discord_discord.desktop";
    };

    "org/gnome/desktop/notifications/application/firefox-firefox" = {
      application-id = "firefox_firefox.desktop";
    };

    "org/gnome/desktop/notifications/application/fr-handbrake-ghb" = {
      application-id = "fr.handbrake.ghb.desktop";
    };

    "org/gnome/desktop/notifications/application/gimp-gimp" = {
      application-id = "gimp_gimp.desktop";
    };

    "org/gnome/desktop/notifications/application/gnome-datetime-panel" = {
      application-id = "gnome-datetime-panel.desktop";
    };

    "org/gnome/desktop/notifications/application/gnome-network-panel" = {
      application-id = "gnome-network-panel.desktop";
    };

    "org/gnome/desktop/notifications/application/gnome-power-panel" = {
      application-id = "gnome-power-panel.desktop";
    };

    "org/gnome/desktop/notifications/application/gnome-printers-panel" = {
      application-id = "gnome-printers-panel.desktop";
    };

    "org/gnome/desktop/notifications/application/gnome-system-monitor" = {
      application-id = "gnome-system-monitor.desktop";
    };

    "org/gnome/desktop/notifications/application/google-chrome" = {
      application-id = "google-chrome.desktop";
    };

    "org/gnome/desktop/notifications/application/io-snapcraft-sessionagent" = {
      application-id = "io.snapcraft.SessionAgent.desktop";
    };

    "org/gnome/desktop/notifications/application/miro-miro" = {
      application-id = "miro_miro.desktop";
    };

    "org/gnome/desktop/notifications/application/obs-studio-obs-studio" = {
      application-id = "obs-studio_obs-studio.desktop";
    };

    "org/gnome/desktop/notifications/application/obsidian" = {
      application-id = "obsidian.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-boxes" = {
      application-id = "org.gnome.Boxes.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-dejadup" = {
      application-id = "org.gnome.DejaDup.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-eog" = {
      application-id = "org.gnome.eog.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-fileroller" = {
      application-id = "org.gnome.FileRoller.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-nautilus" = {
      application-id = "org.gnome.Nautilus.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-settings" = {
      application-id = "org.gnome.Settings.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-shell-portalhelper" = {
      application-id = "org.gnome.Shell.PortalHelper.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-terminal-preferences" = {
      application-id = "org.gnome.Terminal.Preferences.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-terminal" = {
      application-id = "org.gnome.Terminal.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-tweaks" = {
      application-id = "org.gnome.tweaks.desktop";
    };

    "org/gnome/desktop/notifications/application/rambox-rambox" = {
      application-id = "rambox_rambox.desktop";
    };

    "org/gnome/desktop/notifications/application/rambox" = {
      application-id = "rambox.desktop";
    };

    "org/gnome/desktop/notifications/application/simple-scan" = {
      application-id = "simple-scan.desktop";
    };

    "org/gnome/desktop/notifications/application/slack-slack" = {
      application-id = "slack_slack.desktop";
    };

    "org/gnome/desktop/notifications/application/snap-store-ubuntu-software" = {
      application-id = "snap-store_ubuntu-software.desktop";
    };

    "org/gnome/desktop/notifications/application/snapd-desktop-integration-snapd-desktop-integration" = {
      application-id = "snapd-desktop-integration_snapd-desktop-integration.desktop";
    };

    "org/gnome/desktop/notifications/application/teams" = {
      application-id = "teams.desktop";
    };

    "org/gnome/desktop/notifications/application/todoist-todoist" = {
      application-id = "todoist_todoist.desktop";
    };

    "org/gnome/desktop/notifications/application/update-manager" = {
      application-id = "update-manager.desktop";
    };

    "org/gnome/desktop/notifications/application/virt-manager" = {
      application-id = "virt-manager.desktop";
    };

    "org/gnome/desktop/notifications/application/virtualbox" = {
      application-id = "virtualbox.desktop";
    };

    "org/gnome/desktop/notifications/application/vlc" = {
      application-id = "vlc.desktop";
    };

    "org/gnome/desktop/notifications/application/zoom" = {
      application-id = "Zoom.desktop";
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

    "org/gnome/desktop/remote-desktop/rdp" = {
      enable = true;
      tls-cert = "/home/kylecoberly/.local/share/gnome-remote-desktop/rdp-tls.crt";
      tls-key = "/home/kylecoberly/.local/share/gnome-remote-desktop/rdp-tls.key";
      view-only = false;
    };

    "org/gnome/desktop/screensaver" = {
      color-shading-type = "solid";
      picture-options = "zoom";
      picture-uri = "file:///usr/share/backgrounds/Northan_lights_by_mizuno.webp";
      primary-color = "#000000";
      secondary-color = "#000000";
    };

    "org/gnome/desktop/search-providers" = {
      disabled = [ "org.gnome.Calendar.desktop" "org.gnome.Characters.desktop" "org.gnome.seahorse.Application.desktop" ];
      sort-order = [ "org.gnome.Contacts.desktop" "org.gnome.Documents.desktop" "org.gnome.Nautilus.desktop" ];
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
      switch-to-workspace-1 = [ "<Shift><Control>1" ];
      switch-to-workspace-3 = [ "<Shift><Control>3" ];
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

    "org/gnome/evolution-data-server" = {
      migrated = true;
    };

    "org/gnome/file-roller/dialogs/extract" = {
      recreate-folders = true;
      skip-newer = false;
    };

    "org/gnome/file-roller/listing" = {
      list-mode = "as-folder";
      name-column-width = 250;
      show-path = false;
      sort-method = "name";
      sort-type = "ascending";
    };

    "org/gnome/file-roller/ui" = {
      sidebar-width = 200;
      window-height = 305;
      window-width = 444;
    };

    "org/gnome/gnome-system-monitor" = {
      current-tab = "processes";
      maximized = false;
      network-total-in-bits = false;
      show-dependencies = false;
      show-whose-processes = "user";
      window-state = mkTuple [ 700 500 26 23 ];
    };

    "org/gnome/gnome-system-monitor/disktreenew" = {
      col-6-visible = true;
      col-6-width = 0;
    };

    "org/gnome/gnome-system-monitor/proctree" = {
      columns-order = [ 0 1 2 3 4 6 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 ];
      sort-col = 8;
      sort-order = 0;
    };

    "org/gnome/mutter" = {
      center-new-windows = true;
      dynamic-workspaces = false;
      experimental-features = [];
      workspaces-only-on-primary = false;
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

    "org/gnome/nautilus/window-state" = {
      initial-size = mkTuple [ 1014 380 ];
      maximized = true;
    };

    "org/gnome/nm-applet/eap/5b7bd29c-7837-4d4d-91c2-6556824aa4ff" = {
      ignore-ca-cert = false;
      ignore-phase2-ca-cert = false;
    };

    "org/gnome/portal/filechooser/1password" = {
      last-folder-path = "/home/kylecoberly/snap/obs-studio/current";
    };

    "org/gnome/portal/filechooser/google-chrome" = {
      last-folder-path = "/home/kylecoberly/Videos";
    };

    "org/gnome/portal/filechooser/rambox" = {
      last-folder-path = "/home/kylecoberly/Videos";
    };

    "org/gnome/portal/filechooser/simple-scan" = {
      last-folder-path = "/home/kylecoberly/Pictures/Scans";
    };

    "org/gnome/portal/filechooser/snap/code" = {
      last-folder-path = "/home/kylecoberly/Projects/du/week-2";
    };

    "org/gnome/portal/filechooser/snap/firefox" = {
      last-folder-path = "/home/kylecoberly/Downloads";
    };

    "org/gnome/portal/filechooser/snap/slack" = {
      last-folder-path = "/home/kylecoberly/Documents/Resumes/Manager";
    };

    "org/gnome/rhythmbox" = {
      position = mkTuple [ 50 32 ];
    };

    "org/gnome/rhythmbox/library" = {
      layout-filename = "%tN - %tt";
      layout-path = "%aa/%at";
    };

    "org/gnome/rhythmbox/library/encoding" = {
      media-type = "audio/x-flac";
    };

    "org/gnome/rhythmbox/player" = {
      volume = 1.0;
    };

    "org/gnome/rhythmbox/plugins" = {
      seen-plugins = [ "alternative-toolbar" ];
    };

    "org/gnome/rhythmbox/podcast" = {
      download-location = "file:///home/kylecoberly/Music";
    };

    "org/gnome/rhythmbox/rhythmdb" = {
      locations = [ "cdda://sr0/" ];
      monitor-library = false;
    };

    "org/gnome/rhythmbox/sources" = {
      visible-columns = [ "post-time" "duration" "track-number" "album" "genre" "artist" ];
    };

    "org/gnome/settings-daemon/plugins/color" = {
      night-light-last-coordinates = mkTuple [ 39.77501830900187 (-104.8988106) ];
    };

    "org/gnome/settings-daemon/plugins/power" = {
      power-button-action = "suspend";
      sleep-inactive-ac-timeout = 3600;
      sleep-inactive-ac-type = "nothing";
    };

    "org/gnome/shell" = {
      disable-user-extensions = false;
      disabled-extensions = [ "ding@rastersoft.com" "tiling-assistant@ubuntu.com" "smart-auto-move@khimaros.com" "user-theme-x@tuberry.github.io" ];
      enabled-extensions = [ "just-perfection-desktop@just-perfection" "ubuntu-dock@ubuntu.com" "ubuntu-appindicators@ubuntu.com" ];
      favorite-apps = [ "org.gnome.Nautilus.desktop" "Zoom.desktop" "google-chrome.desktop" "Alacritty.desktop" ];
      had-bluetooth-devices-setup = true;
      last-selected-power-profile = "power-saver";
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

    "org/gnome/shell/extensions/smart-auto-move" = {
      activate-workspace = true;
      debug-logging = false;
      freeze-saves = false;
      ignore-position = false;
      ignore-workspace = false;
      match-threshold = 0.7;
      overrides = ''
        {}
      '';
      save-frequency = 1000;
      saved-windows = ''
        {"firefox":[{"id":2829603083,"hash":2829603083,"sequence":7,"title":"shortcut keys - How to set keyboard layout switching on Wayland (Ubuntu 22.04) with \\"Ctrl+1\\" for \\"Language1\\", \\"Ctrl+2\\" for \\"Language2\\", etc - Ask Ubuntu — Mozilla Firefox","workspace":0,"maximized":0,"fullscreen":false,"above":false,"monitor":0,"x":260,"y":213,"width":1280,"height":693,"occupied":false},{"id":3685176138,"hash":3685176138,"sequence":8,"title":"(6) Discord | @Elyse Coberly — Mozilla Firefox","workspace":1,"maximized":3,"fullscreen":false,"above":false,"monitor":0,"x":0,"y":27,"width":1280,"height":693,"occupied":false},{"id":3685176139,"hash":3685176139,"sequence":9,"title":"2023 On Cinema Summer Movie Recap (Audio Only) - HEI Network — Mozilla Firefox","workspace":2,"maximized":3,"fullscreen":false,"above":false,"monitor":0,"x":0,"y":27,"width":1280,"height":693,"occupied":false},{"id":650363041,"hash":650363041,"sequence":3,"title":"shortcut keys - How to set keyboard layout switching on Wayland (Ubuntu 22.04) with \\"Ctrl+1\\" for \\"Language1\\", \\"Ctrl+2\\" for \\"Language2\\", etc - Ask Ubuntu — Mozilla Firefox","workspace":1,"maximized":3,"fullscreen":false,"above":false,"monitor":1,"x":0,"y":27,"width":1920,"height":1053,"occupied":false},{"id":650363043,"hash":650363043,"sequence":5,"title":"2023 On Cinema Summer Movie Recap (Audio Only) - HEI Network — Mozilla Firefox","workspace":0,"maximized":3,"fullscreen":false,"above":false,"monitor":0,"x":1920,"y":0,"width":1920,"height":1080,"occupied":false},{"id":2029053799,"hash":2029053799,"sequence":3,"title":"shortcut keys - How to set keyboard layout switching on Wayland (Ubuntu 22.04) with \\"Ctrl+1\\" for \\"Language1\\", \\"Ctrl+2\\" for \\"Language2\\", etc - Ask Ubuntu — Mozilla Firefox","workspace":0,"maximized":3,"fullscreen":false,"above":false,"monitor":1,"x":0,"y":27,"width":1920,"height":1053,"occupied":false},{"id":1284708452,"hash":1284708452,"sequence":3,"title":"TurboTax® Login - Sign in to Get Started on Your Tax Return — Mozilla Firefox","workspace":0,"maximized":3,"fullscreen":false,"above":false,"monitor":1,"x":0,"y":27,"width":1920,"height":1053,"occupied":false},{"id":2498667713,"hash":2498667713,"sequence":2,"title":"Restore Session — Mozilla Firefox","workspace":0,"maximized":3,"fullscreen":false,"above":false,"monitor":0,"x":0,"y":27,"width":1280,"height":693,"occupied":false}],"com.mattjakeman.ExtensionManager":[{"id":1469151883,"hash":1469151883,"sequence":4,"title":"Extension Manager","workspace":0,"maximized":0,"fullscreen":false,"above":false,"monitor":0,"x":58,"y":98,"width":800,"height":600,"occupied":true}],"gnome-terminal-server":[{"id":2829603086,"hash":2829603086,"sequence":10,"title":"dotfiles:2:python3 - \\"xps13\\" 1#","workspace":0,"maximized":0,"fullscreen":false,"above":false,"monitor":0,"x":0,"y":27,"width":1054,"height":673,"occupied":false}],"extension-manager":[{"id":650363047,"hash":650363047,"sequence":9,"title":"Extension Manager","workspace":0,"maximized":0,"fullscreen":false,"above":false,"monitor":1,"x":74,"y":128,"width":1600,"height":1200,"occupied":false}],"org.gnome.Shell.Extensions":[{"id":650363048,"hash":650363048,"sequence":10,"title":"Smart Auto Move","workspace":0,"maximized":0,"fullscreen":false,"above":false,"monitor":1,"x":124,"y":178,"width":1280,"height":1152,"occupied":false}],"gnome-control-center":[{"id":3685176140,"hash":3685176140,"sequence":10,"title":"Settings","workspace":0,"maximized":0,"fullscreen":false,"above":false,"monitor":1,"x":626,"y":138,"width":518,"height":766,"occupied":false}],"miro":[{"id":3685176155,"hash":3685176155,"sequence":25,"title":"9/21/23, Visual Workspace for Innovation","workspace":0,"maximized":3,"fullscreen":false,"above":false,"monitor":0,"x":0,"y":27,"width":1280,"height":693,"occupied":false}],"Gnome-terminal":[{"id":3685176133,"hash":3685176133,"sequence":3,"title":"Playground:1:zsh - \\"xps13\\" 2#,3#,4#,5#,6#","workspace":0,"maximized":3,"fullscreen":false,"above":false,"monitor":0,"x":0,"y":27,"width":1280,"height":693,"occupied":false}],"Apport-gtk":[{"id":2498667714,"hash":2498667714,"sequence":3,"title":"Ubuntu","workspace":0,"maximized":0,"fullscreen":false,"above":false,"monitor":0,"x":377,"y":276,"width":525,"height":232,"occupied":false}],"rambox":[{"id":1469151882,"hash":1469151882,"sequence":3,"title":"Rambox","workspace":0,"maximized":0,"fullscreen":false,"above":false,"monitor":0,"x":640,"y":143,"width":1280,"height":1034,"occupied":true}]}
      '';
      startup-delay = 2500;
      sync-frequency = 100;
      sync-mode = "RESTORE";
    };

    "org/gnome/shell/extensions/tiling-assistant" = {
      active-window-hint-color = "rgb(119,100,216)";
      last-version-installed = 44;
      tiling-popup-all-workspace = false;
    };

    "org/gnome/shell/extensions/user-theme-x" = {
      x-autoswitch = false;
    };

    "org/gnome/shell/world-clocks" = {
      locations = [];
    };

    "org/gnome/shotwell/preferences/window" = {
      direct-height = 1011;
      direct-maximize = false;
      direct-width = 1920;
    };

    "org/gnome/simple-scan" = {
      jpeg-quality = 84;
      page-side = "front";
      photo-dpi = 1200;
      save-directory = "file:///home/kylecoberly/Pictures/Scans/";
      save-format = "image/png";
      text-dpi = 600;
    };

    "org/gnome/software" = {
      install-timestamp = mkInt64 1713289894;
      security-timestamp = mkInt64 0;
      update-notification-timestamp = mkInt64 1735262350;
    };

    "org/gnome/sound-juicer" = {
      audio-profile = "audio/x-flac";
      eject = true;
      file-pattern = "%dn - %tt";
      path-pattern = "%aa/%at";
      volume = 1.0;
    };

    "org/gnome/system/location" = {
      enabled = true;
    };

    "org/gnome/terminal/legacy/profiles:" = {
      list = [ "30eaa304-cfa1-49a6-9596-63b5aac24099" "8bd61f7f-3b26-4b10-9438-36b6294263d5" ];
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

    "org/virt-manager/virt-manager" = {
      manager-window-height = 508;
      manager-window-width = 550;
    };

    "org/virt-manager/virt-manager/confirm" = {
      delete-storage = false;
      forcepoweroff = false;
      unapplied-dev = true;
    };

    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };

    "org/virt-manager/virt-manager/conns/qemu:system" = {
      window-size = mkTuple [ 800 600 ];
    };

    "org/virt-manager/virt-manager/details" = {
      show-toolbar = true;
    };

    "org/virt-manager/virt-manager/paths" = {
      media-default = "/home/kylecoberly/Downloads";
    };

    "org/virt-manager/virt-manager/urls" = {
      isos = [ "/home/kylecoberly/Downloads/Windosw 7 Pro 64 Bit.iso" "/home/kylecoberly/Downloads/nixos-plasma6-24.05.1135.9b5328b7f761-x86_64-linux.iso" ];
    };

    "org/virt-manager/virt-manager/vmlist-fields" = {
      disk-usage = false;
      network-traffic = false;
    };

    "org/virt-manager/virt-manager/vms/10160b1e93a04091b77dae5324e92a33" = {
      autoconnect = 1;
      scaling = 1;
      vm-window-size = mkTuple [ 1024 833 ];
    };

    "org/virt-manager/virt-manager/vms/6e2e12bcdc744b2ab5b83c226e51d0b7" = {
      autoconnect = 1;
      scaling = 1;
      vm-window-size = mkTuple [ 1024 810 ];
    };

    "org/virt-manager/virt-manager/vms/7054db9599fd4062879c6510ad94bf27" = {
      autoconnect = 1;
      scaling = 1;
      vm-window-size = mkTuple [ 1024 810 ];
    };

    "org/virt-manager/virt-manager/vms/75f3778fe4a04233a2d0d76d114002e5" = {
      autoconnect = 1;
      scaling = 1;
      vm-window-size = mkTuple [ 1024 810 ];
    };

    "org/virt-manager/virt-manager/vms/7c5974a9af864e52864240759b60e95d" = {
      autoconnect = 1;
      scaling = 2;
      vm-window-size = mkTuple [ 1920 1014 ];
    };

    "org/virt-manager/virt-manager/vms/88576bcd48d049f690a186f9b42cf0f7" = {
      autoconnect = 1;
      scaling = 1;
      vm-window-size = mkTuple [ 1920 1014 ];
    };

    "org/virt-manager/virt-manager/vms/98ef1a9e44e640759992003ba1bf5ddd" = {
      autoconnect = 1;
      scaling = 1;
      vm-window-size = mkTuple [ 1024 810 ];
    };

    "org/virt-manager/virt-manager/vms/a91234549aaa4662a5b9f590721f6a16" = {
      autoconnect = 1;
      scaling = 1;
      vm-window-size = mkTuple [ 1024 810 ];
    };

    "org/virt-manager/virt-manager/vms/b3371de8773e4a90ab17bbbdb1ab2105" = {
      autoconnect = 1;
      scaling = 1;
      vm-window-size = mkTuple [ 1920 1011 ];
    };

    "org/virt-manager/virt-manager/vms/c6e735a405ff4c9aadbc5e58d3ce502e" = {
      autoconnect = 1;
      resize-guest = 1;
      scaling = 1;
      vm-window-size = mkTuple [ 1920 1011 ];
    };

    "org/virt-manager/virt-manager/vms/d910bdde28654b6581a3597b51af9082" = {
      autoconnect = 1;
      scaling = 1;
      vm-window-size = mkTuple [ 1024 835 ];
    };

    "org/virt-manager/virt-manager/vms/f8a59632f6c34f0eb963299875575f2c" = {
      autoconnect = 1;
      scaling = 1;
      vm-window-size = mkTuple [ 1024 810 ];
    };

    "system/proxy" = {
      mode = "none";
    };

  };
}

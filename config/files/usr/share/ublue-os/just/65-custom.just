# Create a Fedora (bsherman custom) container
distrobox-fedora-custom:
  distrobox create --nvidia --image ghcr.io/bsherman/fedora-toolbox-custom:FEDORA_MAJOR_VERSION -n fedora-custom -Y

# Setup flathub remote, remove fedora remote if present
setup-flatpak-repos:
  flatpak remote-add --if-not-exists --system flathub https://flathub.org/repo/flathub.flatpakrepo
  flatpak uninstall --system --noninteractive `flatpak list --all --columns origin,application|grep ^fedora|awk '{print $2}'|xargs`
  flatpak remote-delete --system fedora --force

# Install system flatpaks for rebasers - min
install-system-flatpaks:
  #!/usr/bin/bash
  IMAGE_INFO="/usr/share/ublue-os/image-info.json"
  BASE_IMAGE_NAME=$(jq -r '."base-image-name"' < $IMAGE_INFO)
  if [[ ${BASE_IMAGE_NAME} == 'silverblue' ]]; then
      FLATPAKS="bluefin_flatpaks/flatpaks"
  elif [[ ${BASE_IMAGE_NAME} == 'kinoite' ]]; then
      FLATPAKS="aurora_flatpaks/flatpaks"
  fi
  FLATPAK_LIST="$(curl https://raw.githubusercontent.com/ublue-os/bluefin/main/${FLATPAKS} | tr '\n' ' ')"
  flatpak --system -y install ${FLATPAK_LIST}

# Install typical GNOME apps
install-apps-gnome:
  flatpak install --noninteractive --system flathub \\
    org.gnome.Calculator \\
    org.gnome.Calendar \\
    org.gnome.Characters \\
    org.gnome.Connections \\
    org.gnome.Contacts \\
    org.gnome.Evince \\
    org.gnome.Logs \\
    org.gnome.Loupe \\
    org.gnome.Maps \\
    org.gnome.NautilusPreviewer \\
    org.gnome.TextEditor \\
    org.gnome.Weather \\
    org.gnome.baobab \\
    org.gnome.clocks \\
    org.gnome.font-viewer \\
    org.gnome.SimpleScan \\
    org.gnome.SoundRecorder \\
    org.fedoraproject.MediaWriter \\
    org.mozilla.firefox \\
    com.github.tchx84.Flatseal \\
    com.mattjakeman.ExtensionManager \\
    io.github.celluloid_player.Celluloid \\
    it.mijorus.gearlever \\
    io.missioncenter.MissionCenter \\
    org.gustavoperedo.FontDownloader

# Install Creative Media Apps
install-apps-creative:
  flatpak install -y --system \\
    nl.hjdskes.gcolor3 \\
    org.audacityteam.Audacity \\
    org.gimp.GIMP \\
    org.inkscape.Inkscape \\
    org.kde.kdenlive \\
    org.kde.krita

# Install standard apps
install-apps-standard:
  flatpak install -y --system \\
    com.microsoft.Edge \\
    net.mullvad.MullvadBrowser \\
    com.belmoussaoui.Obfuscate \\
    org.onlyoffice.desktopeditors \\
    one.ablaze.floorp \\
    com.github.zadam.trilium \\
    com.sindresorhus.Caprine \\
    org.signal.Signal \\
    io.github.shiftey.Desktop \\
    org.kde.okular \\
    com.discordapp.Discord \\
    com.visualstudio.code \\
    com.simplenote.Simplenote \\
    de.haeckerfelix.Fragments \\
    com.github.iwalton3.jellyfin-media-player


# Give browsers permission to create PWAs (Progressive Web Apps)
install-pwa-flatpak-overrides:
  flatpak override --system --filesystem=~/.local/share/applications --filesystem=~/.local/share/icons com.google.Chrome
  flatpak override --system --filesystem=~/.local/share/applications --filesystem=~/.local/share/icons com.brave.Browser
  flatpak override --system --filesystem=~/.local/share/applications --filesystem=~/.local/share/icons com.microsoft.Edge

# Install educational games
install-games-educational:
  flatpak install -y --system \\
    org.kde.kturtle \\
    edu.mit.Scratch \\
    com.tux4kids.tuxmath \\
    com.tux4kids.tuxtype \\
    org.tuxpaint.Tuxpaint

# Install light/casual games
install-games-light:
  flatpak install -y --system \\
    net.sourceforge.lgames.LTris \\
    org.frozen_bubble.frozen-bubble \\
    org.gnome.Aisleriot \\
    org.gnome.Mines

# Install Linux games
install-games-linux:
  flatpak install -y --system \\
    io.github.retux_game.retux \\
    net.sourceforge.ExtremeTuxRacer \\
    net.supertuxkart.SuperTuxKart \\
    org.supertuxproject.SuperTux \\
    org.armagetronad.ArmagetronAdvanced \\
    party.supertux.supertuxparty

# Install Minecraft games
install-games-minecraft:
  flatpak install -y --system \\
    com.mojang.Minecraft \\
    io.mrarm.mcpelauncher \\
    org.prismlauncher.PrismLauncher

# Install Steam with MangoHud, Gamescope and Prototricks
install-games-steam:
  flatpak install -y --system \\
    org.freedesktop.Platform.VulkanLayer.MangoHud//22.08 \\
    com.github.Matoking.protontricks \\
    com.valvesoftware.Steam \\
    com.valvesoftware.Steam.Utility.gamescope

# Install virtualization stack (libvirt/virt-manager/etc)
install-virtualization:
  rpm-ostree install libvirt-client libvirt-daemon-kvm virt-install virt-manager

# Un-install virtualization stack (libvirt/virt-manager/etc)
uninstall-virtualization:
  rpm-ostree uninstall libvirt-client libvirt-daemon-kvm virt-install virt-manager
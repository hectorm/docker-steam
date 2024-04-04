##################################################
## "main" stage
##################################################

FROM docker.io/hectorm/xubuntu:v115 AS main

# Install Steam
ARG STEAM_DEB_URL=https://steamcdn-a.akamaihd.net/client/installer/steam.deb
RUN mkdir /tmp/steam/ && cd /tmp/steam/ \
	&& dpkg --add-architecture i386 \
	&& curl -Lo ./steam.deb "${STEAM_DEB_URL:?}" \
	&& dpkg -i ./steam.deb || (apt-get update && apt-get install -fy) \
	&& tar -xf /usr/lib/steam/bootstraplinux*.tar.* steamdeps.txt \
	&& yes | steamdeps ./steamdeps.txt \
	&& sed -i 's|^\([^#].*\)|#\1|g' /etc/apt/sources.list.d/steam-*.list \
	&& sed -i 's|MODE="[0-9]*"|MODE="0666"|g' /usr/lib/udev/rules.d/*-steam-*.rules \
	&& rm -rf /tmp/steam/ /var/lib/apt/lists/*

# Copy udev config
COPY --chown=root:root ./config/udev/ /etc/udev/
RUN find /etc/udev/ -type d -not -perm 0755 -exec chmod 0755 '{}' ';'
RUN find /etc/udev/ -type f -not -perm 0644 -exec chmod 0644 '{}' ';'

# Disable X11 XRandR extension for Steam client
# See: https://discourse.libsdl.org/t/sdl-createwindow-no-available-displays/21705
RUN sed -i '/^#!.*$/{s||&\nexport SDL_VIDEO_X11_XRANDR=0\n|;:a;$!N;$!ba}' /usr/bin/steam

# Start Steam client on login
RUN install -Dm 644 /usr/share/applications/steam.desktop /etc/skel/.config/autostart/steam.desktop

# Expose Steam client ports
# See: https://support.steampowered.com/kb_article.php?ref=8571-GLVN-8711
EXPOSE 27031-27036/udp 27036/tcp 27037/tcp

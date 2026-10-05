# syntax=docker.io/docker/dockerfile:1

##################################################
## "main" stage
##################################################

FROM docker.io/hectorm/xubuntu:v134 AS main

# Install Steam
ARG STEAM_DEB_URL=https://steamcdn-a.akamaihd.net/client/installer/steam.deb
RUN <<-EOF
	mkdir /tmp/steam/
	cd /tmp/steam/
	dpkg --add-architecture i386
	curl -Lo ./steam.deb "${STEAM_DEB_URL:?}"
	dpkg -i ./steam.deb || { apt-get update; apt-get install -fy; }
	yes | steamdeps
	sed -i 's|^\([^#].*\)|#\1|g' /etc/apt/sources.list.d/steam-*.list
	sed -i 's|MODE="[0-9]*"|MODE="0666"|g' /usr/lib/udev/rules.d/*-steam-*.rules
	rm -rf /tmp/steam/ /var/lib/apt/lists/*
EOF

# Copy udev config
COPY --chown=root:root --chmod=a+rX,u+w,go-w ./config/udev/ /etc/udev/

# Disable X11 XRandR extension for Steam client
# See: https://discourse.libsdl.org/t/sdl-createwindow-no-available-displays/21705
RUN <<-EOF
	sed -i '/^#!.*$/{s||&\nexport SDL_VIDEO_X11_XRANDR=0\n|;:a;$!N;$!ba}' /usr/bin/steam
EOF

# Start Steam client on login
RUN <<-EOF
	install -Dm 644 /usr/share/applications/steam.desktop /etc/skel/.config/autostart/steam.desktop
EOF

# Expose Steam client ports
# See: https://support.steampowered.com/kb_article.php?ref=8571-GLVN-8711
EXPOSE 27031-27036/udp 27036/tcp 27037/tcp

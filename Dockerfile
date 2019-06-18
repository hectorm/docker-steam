##################################################
## "steam" stage
##################################################

FROM docker.io/hectormolinero/xubuntu:latest AS steam

# Install Steam
ARG STEAM_DEB_URL=https://steamcdn-a.akamaihd.net/client/installer/steam.deb
RUN mkdir /tmp/steam/ && cd /tmp/steam/ \
	&& curl -Lo ./steam.deb "${STEAM_DEB_URL}" \
	&& dpkg -i ./steam.deb || (apt-get update && apt-get install -fy) \
	&& rm -rf /tmp/steam/ /var/lib/apt/lists/*

# Store all user data in a volume
VOLUME /home/guest/

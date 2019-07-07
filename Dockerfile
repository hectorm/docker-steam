##################################################
## "steam" stage
##################################################

FROM docker.io/hectormolinero/xubuntu:latest AS steam

# Environment
ENV UNPRIVILEGED_USER_NAME=steam

# Install Steam
ARG STEAM_DEB_URL=https://steamcdn-a.akamaihd.net/client/installer/steam.deb
RUN mkdir /tmp/steam/ && cd /tmp/steam/ \
	&& curl -Lo ./steam.deb "${STEAM_DEB_URL}" \
	&& dpkg -i ./steam.deb || (apt-get update && apt-get install -fy) \
	&& rm -rf /tmp/steam/ /var/lib/apt/lists/*

# SSH port
EXPOSE 3322/tcp
# RDP port
EXPOSE 3389/tcp
# Steam In-Home Streaming
# See: https://support.steampowered.com/kb_article.php?ref=8571-GLVN-8711
EXPOSE 4380/udp 27036/tcp 27037/tcp 27000-27100/udp

# Store all user data in a volume
VOLUME /home/steam/

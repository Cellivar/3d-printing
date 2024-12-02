# syntax=docker/dockerfile:1
# https://github.com/accetto/ubuntu-vnc-xfce-g3/blob/master/docker/Dockerfile.xfce.24-04
ARG BASEIMAGE=ubuntu
ARG BASETAG=24.04

ARG ARG_MERGE_STAGE_VNC_BASE=stage_vnc
ARG ARG_MERGE_STAGE_BROWSER_BASE=merge_stage_vnc
ARG ARG_FINAL_STAGE_BASE=merge_stage_browser

ARG ARG_HEADLESS_USER_ID=1001
ARG ARG_HEADLESS_USER_NAME=headless
ARG ARG_HEADLESS_USER_GROUP_ID=1001
ARG ARG_HEADLESS_USER_GROUP_NAME=headless
ARG ARG_SUDO_INITIAL_PW=headless

FROM stage_tools AS stage_vnc
ARG ARG_VNC_COL_DEPTH
ARG ARG_VNC_DISPLAY
ARG ARG_VNC_PORT
ARG ARG_VNC_PW
ARG ARG_VNC_RESOLUTION
ARG ARG_VNC_VIEW_ONLY
ARG ARG_TIGERVNC_DISTRO
ARG ARG_TIGERVNC_VERSION

RUN \
    --mount=type=cache,from=stage_cache,sharing=locked,source=/var/cache/apt,target=/var/cache/apt \
    --mount=type=cache,from=stage_cache,sharing=locked,source=/var/lib/apt,target=/var/lib/apt \
    --mount=type=cache,from=stage_cache,sharing=locked,source=/tmp/g3-cache/,target=/tmp/g3-cache/ \
    TIGERVNC_VERSION="${ARG_TIGERVNC_VERSION}" \
    TIGERVNC_DISTRO="${ARG_TIGERVNC_DISTRO}" \
    &&  if [ ! -s /tmp/g3-cache/tigervnc/tigervnc-"${TIGERVNC_VERSION}"."${TIGERVNC_DISTRO}".tar.gz ] ; then  \
            wget --show-progress --progress=bar:force:noscroll \
                -q https://sourceforge.net/projects/tigervnc/files/stable/"${TIGERVNC_VERSION}"/tigervnc-"${TIGERVNC_VERSION}"."${TIGERVNC_DISTRO}".tar.gz \
                -P /tmp/g3-cache/tigervnc ; \
        fi \
    &&  tar xzf /tmp/g3-cache/tigervnc/tigervnc-"${TIGERVNC_VERSION}"."${TIGERVNC_DISTRO}".tar.gz --strip 1 -C / \
    &&  ln -s /usr/libexec/vncserver /usr/bin/vncserver \
    &&  sed -i 's/exec(@cmd);/print "@cmd";\nexec(@cmd);/g' /usr/libexec/vncserver

ENV \
    DISPLAY="${ARG_VNC_DISPLAY:-:1}" \
    FEATURES_VNC=1 \
    VNC_COL_DEPTH="${ARG_VNC_COL_DEPTH:-24}" \
    VNC_PORT="${ARG_VNC_PORT:-5901}" \
    VNC_PW="${ARG_VNC_PW:-headless}" \
    VNC_RESOLUTION="${ARG_VNC_RESOLUTION:-1360x768}" \
    VNC_VIEW_ONLY="${ARG_VNC_VIEW_ONLY:-false}"

EXPOSE "${VNC_PORT}"


###############
### stage_novnc
###############

FROM stage_vnc AS stage_novnc
ARG ARG_APT_NO_RECOMMENDS
ARG ARG_NOVNC_PORT
ARG ARG_NOVNC_VERSION
ARG ARG_WEBSOCKIFY_VERSION

ENV \
    FEATURES_BUILD_SLIM_NOVNC="${ARG_APT_NO_RECOMMENDS:+1}" \
    FEATURES_NOVNC=1 \
    NOVNC_HOME="/usr/libexec/noVNCdim" \
    NOVNC_PORT="${ARG_NOVNC_PORT:-6901}"

RUN \
    --mount=type=cache,from=stage_cache,sharing=locked,source=/var/cache/apt,target=/var/cache/apt \
    --mount=type=cache,from=stage_cache,sharing=locked,source=/var/lib/apt,target=/var/lib/apt \
    --mount=type=cache,from=stage_cache,sharing=locked,source=/tmp/g3-cache/,target=/tmp/g3-cache/ \
    DEBIAN_FRONTEND=noninteractive apt-get install -y "${ARG_APT_NO_RECOMMENDS:+--no-install-recommends}" \
        python3-numpy \
    &&  mkdir -p "${NOVNC_HOME}"/utils/websockify \
    &&  NOVNC_VERSION="${ARG_NOVNC_VERSION}" \
    &&  WEBSOCKIFY_VERSION="${ARG_WEBSOCKIFY_VERSION}" \
    &&  if [ ! -s /tmp/g3-cache/novnc/v"${NOVNC_VERSION}".tar.gz ] ; then \
            wget --show-progress --progress=bar:force:noscroll \
                -q https://github.com/novnc/noVNC/archive/v"${NOVNC_VERSION}".tar.gz \
                -P /tmp/g3-cache/novnc ; \
        fi \
    &&  if [ ! -s /tmp/g3-cache/websockify/v"${WEBSOCKIFY_VERSION}".tar.gz ] ; then \
            wget --show-progress --progress=bar:force:noscroll \
                -q https://github.com/novnc/websockify/archive/v"${WEBSOCKIFY_VERSION}".tar.gz \
                -P /tmp/g3-cache/websockify ; \
        fi \
    &&  tar xzf /tmp/g3-cache/novnc/v"${NOVNC_VERSION}".tar.gz --strip 1 -C "${NOVNC_HOME}" \
    &&  tar xzf /tmp/g3-cache/websockify/v"${WEBSOCKIFY_VERSION}".tar.gz --strip 1 -C "${NOVNC_HOME}"/utils/websockify \
    &&  chmod 755 -v "${NOVNC_HOME}"/utils/novnc_proxy

### add 'index.html' for choosing noVNC client
RUN echo \
"<!DOCTYPE html>\n\
<html>\n\
    <head>\n\
        <title>noVNC</title>\n\
        <meta charset=\"utf-8\"/>\n\
        <meta http-equiv=\"refresh\" content=\"10; url='vnc.html'\" />\n\
    </head>\n\
    <body>\n\
    <p><a href=\"vnc_lite.html\">noVNC Lite Client</a></p>\n\
    <p><a href=\"vnc.html\">noVNC Full Client</a></p>\n\
    <p>Full Client will start automatically in 10 seconds...</p>\n\
    </body>\n\
</html>" \
> "${NOVNC_HOME}"/index.html

EXPOSE "${NOVNC_PORT}"


###################
### merge_stage_vnc
###################

FROM ${ARG_MERGE_STAGE_VNC_BASE} as merge_stage_vnc
ARG ARG_HEADLESS_USER_ID
ARG ARG_HEADLESS_USER_NAME
ARG ARG_HEADLESS_USER_GROUP_ID
ARG ARG_HEADLESS_USER_GROUP_NAME

ENV \
    HEADLESS_USER_ID="${ARG_HEADLESS_USER_ID}" \
    HEADLESS_USER_NAME="${ARG_HEADLESS_USER_NAME}" \
    HEADLESS_USER_GROUP_ID="${ARG_HEADLESS_USER_GROUP_ID}" \
    HEADLESS_USER_GROUP_NAME="${ARG_HEADLESS_USER_GROUP_NAME}" \
    HOME="${ARG_HOME:-/home/${ARG_HEADLESS_USER_NAME}}"

WORKDIR "${HOME}"

### add '.bashrc' and similar resources
COPY ./src/home "${HOME}"/


# ##################
# ### stage_chromium
# ##################

# FROM merge_stage_vnc AS stage_chromium
# ARG ARG_APT_NO_RECOMMENDS
# ARG ARG_CHROMIUM_DISTRO
# ARG ARG_CHROMIUM_VERSION

# ENV \
#     FEATURES_BUILD_SLIM_CHROMIUM="${ARG_APT_NO_RECOMMENDS:+1}" \
#     FEATURES_CHROMIUM=1

# RUN \
#     --mount=type=cache,from=stage_cache,sharing=locked,source=/var/cache/apt,target=/var/cache/apt \
#     --mount=type=cache,from=stage_cache,sharing=locked,source=/var/lib/apt,target=/var/lib/apt \
#     --mount=type=cache,from=stage_cache,sharing=locked,source=/tmp/g3-cache/,target=/tmp/g3-cache/ \
#     CHROMIUM_VERSION="${ARG_CHROMIUM_VERSION}" \
#     CHROMIUM_DISTRO="${ARG_CHROMIUM_DISTRO}" \
#     &&  if [ ! -s /tmp/g3-cache/chromium/chromium-browser_"${CHROMIUM_VERSION}"_"${CHROMIUM_DISTRO}".deb ] ; then \
#             wget --show-progress --progress=bar:force:noscroll \
#                 -q http://archive.ubuntu.com/ubuntu/pool/universe/c/chromium-browser/chromium-browser_"${CHROMIUM_VERSION}"_"${CHROMIUM_DISTRO}".deb \
#                 -P /tmp/g3-cache/chromium ; \
#         fi \
#     &&  if [ ! -s /tmp/g3-cache/chromium/chromium-codecs-ffmpeg_"${CHROMIUM_VERSION}"_"${CHROMIUM_DISTRO}".deb ] ; then \
#             wget --show-progress --progress=bar:force:noscroll \
#                 -q http://archive.ubuntu.com/ubuntu/pool/universe/c/chromium-browser/chromium-codecs-ffmpeg_"${CHROMIUM_VERSION}"_"${CHROMIUM_DISTRO}".deb \
#                 -P /tmp/g3-cache/chromium ; \
#         fi \
#     &&  if [ ! -s /tmp/g3-cache/chromium/chromium-browser-l10n_"${CHROMIUM_VERSION}"_all.deb ] ; then \
#             wget --show-progress --progress=bar:force:noscroll \
#                 -q http://archive.ubuntu.com/ubuntu/pool/universe/c/chromium-browser/chromium-browser-l10n_"${CHROMIUM_VERSION}"_all.deb \
#                 -P /tmp/g3-cache/chromium ; \
#         fi \
#     &&  DEBIAN_FRONTEND=noninteractive apt-get install -y "${ARG_APT_NO_RECOMMENDS:+--no-install-recommends}" \
#         /tmp/g3-cache/chromium/chromium-codecs-ffmpeg_"${CHROMIUM_VERSION}"_"${CHROMIUM_DISTRO}".deb \
#         /tmp/g3-cache/chromium/chromium-browser_"${CHROMIUM_VERSION}"_"${CHROMIUM_DISTRO}".deb \
#         /tmp/g3-cache/chromium/chromium-browser-l10n_"${CHROMIUM_VERSION}"_all.deb \
#     &&  apt-mark hold chromium-browser

# COPY ./xfce-chromium/src/home/Desktop "${HOME}"/Desktop/
# COPY ./xfce-chromium/src/home/readme*.md "${HOME}"/

# ### Chromium browser requires some presets
# ### Note that 'no-sandbox' flag is required, but intended for development only
# RUN \
#     echo \
#     "CHROMIUM_FLAGS='--no-sandbox --disable-gpu --user-data-dir --window-size=${VNC_RESOLUTION%x*},${VNC_RESOLUTION#*x} --window-position=0,0'" \
#     > "${HOME}"/.chromium-browser.init


#################
### stage_firefox
#################

FROM merge_stage_vnc AS stage_firefox
ARG ARG_APT_NO_RECOMMENDS

ENV \
    FEATURES_BUILD_SLIM_FIREFOX="${ARG_APT_NO_RECOMMENDS:+1}" \
    FEATURES_FIREFOX=1

RUN \
    --mount=type=cache,from=stage_cache,sharing=locked,source=/var/cache/apt,target=/var/cache/apt \
    --mount=type=cache,from=stage_cache,sharing=locked,source=/var/lib/apt,target=/var/lib/apt \
    KEY_SERVER_URL="keyserver.ubuntu.com" \
    FIREFOX_PPA_FINGERPRINT="0x0AB215679C571D1C8325275B9BDB3D89CE49EC21" \
    FIREFOX_PPA_GPG_KEY="mozillateam-ubuntu-ppa.gpg" \
    && gpg --status-fd 1 --keyserver "${KEY_SERVER_URL}" --recv-keys "${FIREFOX_PPA_FINGERPRINT}" \
    && gpg --export "${FIREFOX_PPA_FINGERPRINT}" > "${FIREFOX_PPA_GPG_KEY}" \
    && sudo install -o root -g root -m 644 "${FIREFOX_PPA_GPG_KEY}" /etc/apt/trusted.gpg.d/ \
    && gpg --batch --yes --delete-keys "${FIREFOX_PPA_FINGERPRINT}" \
    && rm "${FIREFOX_PPA_GPG_KEY}" \
    && echo \
"deb https://ppa.launchpadcontent.net/mozillateam/ppa/ubuntu jammy main\
\n# deb-src https://ppa.launchpadcontent.net/mozillateam/ppa/ubuntu jammy main\n" \
    >> /etc/apt/sources.list \
    && echo \
"Package: firefox*\n\
Pin: release o=LP-PPA-mozillateam\n\
Pin-Priority: 501" \
    > /etc/apt/preferences.d/mozilla-firefox \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y "${ARG_APT_NO_RECOMMENDS:+--no-install-recommends}" \
        firefox

COPY ./xfce-firefox/src/home/Desktop "${HOME}"/Desktop/


###############
### FINAL STAGE
###############

FROM ${ARG_FINAL_STAGE_BASE} AS stage_final
ARG ARG_FEATURES_OVERRIDING_ENVV
ARG ARG_SUDO_INITIAL_PW

ENV \
    FEATURES_OVERRIDING_ENVV="${ARG_FEATURES_OVERRIDING_ENVV:+1}" \
    FEATURES_VERSION_STICKER=1 \
    STARTUPDIR="/dockerstartup"

COPY ./src/xfce-startup "${STARTUPDIR}"/
COPY ./src/tests "${HOME}"/tests/

COPY ./xfce/src/home/config "${HOME}"/.config/
COPY ./xfce/src/home/Desktop "${HOME}"/Desktop/
COPY ./xfce/src/home/readme*.md "${HOME}"/

### Note that the line 'chmod 666 /etc/passwd /etc/group' sets the "softer" permissions only temporary.
### It allows the user generator startup script to configure the user and the group correctly.
### The script will set the permissions of both files back to the default '644'.
### The script will also clear the file '.initial_sudo_password' after using it.
### However, note that the initial sudo password will still be persisted in the image history.
### You have to change it inside the container, if you want to keep it really secret.
### Note that all this will not be done, if the startup script will not be executed.
RUN \
    chmod 666 /etc/passwd /etc/group \
    &&  echo "${HEADLESS_USER_GROUP_NAME}:x:${HEADLESS_USER_GROUP_ID}:" >> /etc/group \
    &&  echo "${HEADLESS_USER_NAME}:x:${HEADLESS_USER_ID}:${HEADLESS_USER_GROUP_ID}:Default:${HOME}:/bin/bash" >> /etc/passwd \
    &&  echo "${HEADLESS_USER_NAME}  ALL=(ALL:ALL) ALL" | sudo tee /etc/sudoers.d/"${HEADLESS_USER_NAME}" \
    &&  echo "${ARG_SUDO_INITIAL_PW:-headless}" > "${STARTUPDIR}"/.initial_sudo_password \
    &&  echo "${HEADLESS_USER_NAME}:$(cat ${STARTUPDIR}/.initial_sudo_password)" | chpasswd \
    &&  ln -s "${HOME}"/readme.md "${HOME}"/Desktop/README \
    &&  envsubst <"${HOME}"/Desktop/versionsticker.desktop >/tmp/esub.tmp && mv -f /tmp/esub.tmp "${HOME}"/Desktop/versionsticker.desktop \
    && "${STARTUPDIR}"/set_user_permissions.sh "${STARTUPDIR}" "${HOME}"

USER "${HEADLESS_USER_ID}"

ENTRYPOINT [ "/usr/bin/tini", "--", "/dockerstartup/startup.sh" ]

#!/bin/bash
echo -e "\n\nChrooting. Use 'exit' to leave chroot session safely.\n\n"
LABEL_ROOT=$1
LABEL_ROOT=${LABEL_ROOT:-"stretch"}
TARGET=$2
TARGET=${TARGET:-"/chr/testing"}
HOST_RESOLVCONF=$(realpath /etc/resolv.conf)
TARGET_RESOLVCONF="$TARGET"/etc/resolv.conf
TARGET_RESOLVCONF_EXISTS="dontknow"
TARGET_RESOLVCONF_OLD="$TARGET"/etc/resolv.conf.old

mount		LABEL="$LABEL_ROOT" "$TARGET"
mount --bind	/boot               "$TARGET"/boot
mount --bind	/home               "$TARGET"/home
mount --bind	/dev                "$TARGET"/dev
mount -t devpts devpts              "$TARGET"/dev/pts
mount --bind	/run                "$TARGET"/run
mount -t sysfs	sys                 "$TARGET"/sys
mount -t proc	proc                "$TARGET"/proc

if [[ -L "$TARGET_RESOLVCONF" ]] || [[ -e "$TARGET_RESOLVCONF" ]]; then
	export TARGET_RESOLVCONF_EXISTS="true"
	mv -i "$TARGET_RESOLVCONF" "$TARGET_RESOLVCONF_OLD"
fi
cp -ai --no-dereference "$HOST_RESOLVCONF" "$TARGET_RESOLVCONF"

xhost +local:

LANG=C.UTF-8 DISPLAY=$DISPLAY chroot "$TARGET" /bin/bash <<EOF
login $(id -un 1000)
telegram-desktop
EOF
if [[ "$TARGET_RESOLVCONF_EXISTS" == "true" ]]; then
	mv "$TARGET_RESOLVCONF_OLD" "$TARGET_RESOLVCONF"
fi
umount --recursive "$TARGET"
echo -e "\n\nEnd of chroot session.\n\n"

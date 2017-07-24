#!/bin/bash
# copy this file to /usr/bin (or any other $PATH location)

VAR_FILE="/var/lib/pacicron/sha"
MAIL_TO="root"
HOST=$(uname -n)

if [[ ! -f ${VAR_FILE} ]]; then
        echo "${VAR_FILE} doesn't exits. Therefore creating."
        mkdir $(dirname ${VAR_FILE})
        touch ${VAR_FILE}
else
        echo "Using hash from ${VAR_FILE}."

fi


# syncs and downloads all packages, without asking
pacman -Swuy --noconfirm
SHA_NEW=$(pacman -Qu | sha1sum | cut -d" " -f1)
SHA_OLD=$(cat ${VAR_FILE})

if [[ ${SHA_NEW} != ${SHA_OLD} ]]; then
        MSG="Following packages would be installed:\n\r\n\r$(pacman -Qu)\r\n\r\nSincerly yours pacicron\r\n"
        echo -e ${MSG} | mail -s "New updates avaible on ${HOST}" ${MAIL_TO}
        echo ${SHA_NEW} > ${VAR_FILE}
fi

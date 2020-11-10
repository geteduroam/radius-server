#!/bin/sh
set -e

# Sanity check that key material exists
stat -l \
	raddb/certs/ca.pem \
	raddb/certs/server.key \
	raddb/certs/server.pem >/dev/null \
		|| { echo "==> Add key material to raddb/certs before running $0" >&2 ; false; }

if [ -d /usr/local/etc/raddb ]
then
	echo '==> WARNING: /usr/local/etc/raddb already exists'
	echo '==> This script will destroy the existing RADIUS setup'
	echo '==> Press CTRL+C within 10 seconds to safely abort'
	printf ..........
	seq 10 | while read i
	do
		sleep 1
		printf '\b \b'
	done
	printf '\033[2A'
	echo
	echo '==> Safe abort time exceeded. Continuing installation'
fi

pkg install -y freeradius3

rm -f \
	/usr/local/etc/raddb/sites-enabled/default \
	/usr/local/etc/raddb/sites-enabled/inner-tunnel \
	/usr/local/etc/raddb/mods-enabled/eap \
	/usr/local/etc/raddb/certs/ca.pem \
	/usr/local/etc/raddb/certs/server.key \
	/usr/local/etc/raddb/certs/server.pem \
	\
	/usr/local/etc/raddb/mods-enabled/attr_filter \
	/usr/local/etc/raddb/mods-enabled/files \
	/usr/local/etc/raddb/mods-enabled/preprocess \
	/usr/local/etc/raddb/mods-enabled/realm \
	/usr/local/etc/raddb/mods-enabled/cache_eap \
	/usr/local/etc/raddb/mods-enabled/chap \
	/usr/local/etc/raddb/mods-enabled/date \
	/usr/local/etc/raddb/mods-enabled/detail \
	/usr/local/etc/raddb/mods-enabled/digest \
	/usr/local/etc/raddb/mods-enabled/dynamic_clients \
	/usr/local/etc/raddb/mods-enabled/echo \
	/usr/local/etc/raddb/mods-enabled/exec \
	/usr/local/etc/raddb/mods-enabled/expiration \
	/usr/local/etc/raddb/mods-enabled/expr \
	/usr/local/etc/raddb/mods-enabled/linelog \
	/usr/local/etc/raddb/mods-enabled/logintime \
	/usr/local/etc/raddb/mods-enabled/mschap \
	/usr/local/etc/raddb/mods-enabled/ntlm_auth \
	/usr/local/etc/raddb/mods-enabled/pap \
	/usr/local/etc/raddb/mods-enabled/passwd \
	/usr/local/etc/raddb/mods-enabled/radutmp \
	/usr/local/etc/raddb/mods-enabled/replicate \
	/usr/local/etc/raddb/mods-enabled/soh \
	/usr/local/etc/raddb/mods-enabled/sradutmp \
	/usr/local/etc/raddb/mods-enabled/unix \
	/usr/local/etc/raddb/mods-enabled/unpack \
	/usr/local/etc/raddb/mods-enabled/utf8

cp raddb/certs/ca.pem raddb/certs/server.key raddb/certs/server.pem /usr/local/etc/raddb/certs/
cp raddb/clients.conf /usr/local/etc/raddb/clients.conf
cp raddb/mods-available/* /usr/local/etc/raddb/mods-enabled/
cp raddb/sites-available/* /usr/local/etc/raddb/sites-enabled/

# Disable proxying requests
sed -i -e '/^proxy_requests[[:space:]]\s/ s/yes/no/' /usr/local/etc/raddb/radiusd.conf

sysrc radiusd_enable=YES

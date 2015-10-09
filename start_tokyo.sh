#!/usr/bin/env bash
echo "starting tokyotyrant"
mkdir -p /var/ttserver/
/usr/local/tokyotyrant/bin/ttserver /var/ttserver/casket.tch &

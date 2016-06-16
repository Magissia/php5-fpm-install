#!/bin/sh
echo "By running this script, you have agreed and understood to anything you may have to agree to before running it, like license and stuff"
echo ""

function CheckPackageManager 	{
	CheckPacman()
	if [ $? = 0 ]; then
		PacManInstall()
								}

function CheckPacman 	{
	command -v pacman >/dev/null 2>&1 || return 1
	return 0
						}

function CheckApt 	{
	command -v apt >/dev/null 2>&1 || return 1
	return 0
					}
					
function CheckYum	{
	command -v yum >/dev/null 2>&1 || return 1
	return 0
					}

function PacManInstall 	{
	command -v makepkg >/dev/null 2>&1 || pacman -S --noconfirm makepkg
	command -v make >/dev/null 2>&1 || pacman -S --noconfirm make
	command -v curl >/dev/null 2>&1 || pacman -S --noconfirm curl
	command -v xml2-config >/dev/null 2>&1 || pacman -S --noconfirm libxml2
	command -v ziptool >/dev/null 2>&1 || pacman -S --noconfirm libzip
	command -v aspell >/dev/null 2>&1 || pacman -S --noconfirm aspell
	[ -e /usr/lib/libmcrypt.so ] || pacman -S --noconfirm libmcrypt
	[ -e /usr/lib/c-client.a ] || pacman -S --noconfirm c-client
	command -v db_verify >/dev/null 2>&1 || pacman -S --noconfirm db
	command -v enchant >/dev/null 2>&1 || pacman -S --noconfirm enchant
	command -v bsqldb >/dev/null 2>&1 || pacman -S --noconfirm freetds
	command -v webpng >/dev/null 2>&1 || pacman -S --noconfirm gd
	[ -e /usr/lib/libgmp.so ] || pacman -S --noconfirm gmp
	command -v icupkg >/dev/null 2>&1 || pacman -S --noconfirm icu
	command -v libtool >/dev/null 2>&1 || pacman -S --noconfirm libtool
	command -v xsltproc >/dev/null 2>&1 || pacman -S --noconfirm libxslt
	command -v fixproc >/dev/null 2>&1 || pacman -S --noconfirm net-snmp
	command -v postqueue >/dev/null 2>&1 || pacman -S --noconfirm postfix
	command -v createdb >/dev/null 2>&1 || pacman -S --noconfirm postgresql-libs
	command -v sqlite3 >/dev/null 2>&1 || pacman -S --noconfirm sqlite
	command -v systemctl >/dev/null 2>&1 || pacman -S --noconfirm systemd
	command -v tidy >/dev/null 2>&1 || pacman -S --noconfirm tidy
	[ -e /usr/lib/libodbc.so ] || pacman -S --noconfirm unixobdc
	[ -e /usr/lib/libprocps.so ] || pacman -S --noconfirm procps-ng
						}
						
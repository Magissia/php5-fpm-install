#!/bin/sh
echo "By running this script, you have agreed and understood to anything you may have to agree to before running it, like license and stuff"
echo "Stuff may break, that's on you"
SCRIPTPATH=$0
SCRIPTDIRECTORY="`dirname \"$SCRIPTPATH\"`"
pkgbase="php"
pkgver="5.6.22"

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
	[ -e $SCRIPTDIRECTORY/PKGBUILD ] || { exit 11; echo "PKGBUILD missing !"}
	[ -e $SCRIPTDIRECTORY/generate_patches ] || { exit 12; echo "generate_patches missing !"}
	[ -e $SCRIPTDIRECTORY/php-fpm.install ] || { exit 13; echo "php-fpm.install missing !"}
	[ -e $SCRIPTDIRECTORY/php-fpm.patch ] || { exit 13; echo "php-fpm.patch missing !"}
	[ -e $SCRIPTDIRECTORY/php-fpm.tmpfiles ] || { exit 13; echo "php-fpm.tmpfiles missing !"}
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

function AptInstall	{
	apt-get install -y build-essential \
	autoconf libtool libxml2 libxml2-dev \
	libcurl4-gnutls-dev libbz2-1.0 libbz2-dev \
	libjpeg-dev libpng12-dev libfreetype6 libfreetype6-dev \
	libldap-2.4-2 libldap2-dev libmcrypt4 libmcrypt-dev libmysqlclient-dev \
	libxslt1.1 libxslt1-dev libxt-dev libfreetype6 libicu-dev libcurl3 libonig2 \
	libqdbm14 libvpx1 libxpm4 libvpx-dev libxpm-dev checkinstall
	mkdir -p ~/src/php
	wget https://www.php.net/distributions/${pkgbase}-${pkgver}.tar.xz -O ~/src/php/${pkgbase}-${pkgver}.tar.xz
	tar zxvf ~/src/php/${pkgbase}-${pkgver}.tar.xz -C ~/src/php/
	cd ~/src/php/${pkgbase}-${pkgver}
	./configure \
		--config-cache \
		--prefix=/usr \
		--sbindir=/usr/bin \
		--sysconfdir=/etc/php5 \
		--localstatedir=/var \
		--with-layout=GNU \
		--with-config-file-path=/etc/php5 \
		--with-config-file-scan-dir=/etc/php5/conf.d \
		--disable-rpath \
		--mandir=/usr/share/man \
		--without-pear \
		--enable-zend-signals \
					}

	make && checkinstall -D -y \
			--install=no
			--pkgname=php5-fpm
			--pkgversion=$pkgver
			--pkglicence=GPL
			--maintainer=Unknown #<-- FIXME
			--nodoc
			--requires="init-system-helpers  \(\>= 1.18\~\), libbz2-1.0, libc6 \(\>= 2.15\), libcomerr2 \(>=1.01\), libdb5.3, libgssapi-krb5-2 \(\>= 1.6.dfsg.2\), libk5crypto3 \(\>= 1.6.dfsg.2\), libkrb5-3 \(\>= 1.6.dfsg.2\), libmagic1, libonig2 (>= 5.9.5), libpcre3, libqdbm14 \(\>= 1.8.74\), libssl1.0.2 \(\>= 1.0.2d\), libsystemd0, libxml2 \(\>= 2.9.0\), mime-support, tzdata, ucf, zlib1g \(\>= 1:1.1.4\)"
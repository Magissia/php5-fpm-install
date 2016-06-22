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
	gpg --keyserver pgp.mit.edu --recv-keys C2BF0BC433CFC8B3
	gpg --keyserver pgp.mit.edu --recv-keys FE857D9A90D90EC1
	[ -e $SCRIPTDIRECTORY/PKGBUILD ] || { exit 11; echo "PKGBUILD missing !"}
	cd $SCRIPTDIRECTORY
	makepkg --syncdeps --rmdeps
#Let's dream of a world where this isn't required ->	[ -e $SCRIPTDIRECTORY/generate_patches ] || { exit 12; echo "generate_patches missing !"}
#Let's dream of a world where this isn't required ->	[ -e $SCRIPTDIRECTORY/php-fpm.install ] || { exit 13; echo "php-fpm.install missing !"}
#Let's dream of a world where this isn't required ->	[ -e $SCRIPTDIRECTORY/php-fpm.patch ] || { exit 13; echo "php-fpm.patch missing !"}
#Let's dream of a world where this isn't required ->	[ -e $SCRIPTDIRECTORY/php-fpm.tmpfiles ] || { exit 13; echo "php-fpm.tmpfiles missing !"}
#Let's dream of a world where this isn't required ->	command -v makepkg >/dev/null 2>&1 || pacman -S --noconfirm makepkg
#Let's dream of a world where this isn't required ->	command -v make >/dev/null 2>&1 || pacman -S --noconfirm make
#Let's dream of a world where this isn't required ->	command -v curl >/dev/null 2>&1 || pacman -S --noconfirm curl
#Let's dream of a world where this isn't required ->	command -v xml2-config >/dev/null 2>&1 || pacman -S --noconfirm libxml2
#Let's dream of a world where this isn't required ->	command -v ziptool >/dev/null 2>&1 || pacman -S --noconfirm libzip
#Let's dream of a world where this isn't required ->	command -v aspell >/dev/null 2>&1 || pacman -S --noconfirm aspell
#Let's dream of a world where this isn't required ->	[ -e /usr/lib/libmcrypt.so ] || pacman -S --noconfirm libmcrypt
#Let's dream of a world where this isn't required ->	[ -e /usr/lib/c-client.a ] || pacman -S --noconfirm c-client
#Let's dream of a world where this isn't required ->	command -v db_verify >/dev/null 2>&1 || pacman -S --noconfirm db
#Let's dream of a world where this isn't required ->	command -v enchant >/dev/null 2>&1 || pacman -S --noconfirm enchant
#Let's dream of a world where this isn't required ->	command -v bsqldb >/dev/null 2>&1 || pacman -S --noconfirm freetds
#Let's dream of a world where this isn't required ->	command -v webpng >/dev/null 2>&1 || pacman -S --noconfirm gd
#Let's dream of a world where this isn't required ->	[ -e /usr/lib/libgmp.so ] || pacman -S --noconfirm gmp
#Let's dream of a world where this isn't required ->	command -v icupkg >/dev/null 2>&1 || pacman -S --noconfirm icu
#Let's dream of a world where this isn't required ->	command -v libtool >/dev/null 2>&1 || pacman -S --noconfirm libtool
#Let's dream of a world where this isn't required ->	command -v xsltproc >/dev/null 2>&1 || pacman -S --noconfirm libxslt
#Let's dream of a world where this isn't required ->	command -v fixproc >/dev/null 2>&1 || pacman -S --noconfirm net-snmp
#Let's dream of a world where this isn't required ->	command -v postqueue >/dev/null 2>&1 || pacman -S --noconfirm postfix
#Let's dream of a world where this isn't required ->	command -v createdb >/dev/null 2>&1 || pacman -S --noconfirm postgresql-libs
#Let's dream of a world where this isn't required ->	command -v sqlite3 >/dev/null 2>&1 || pacman -S --noconfirm sqlite
#Let's dream of a world where this isn't required ->	command -v systemctl >/dev/null 2>&1 || pacman -S --noconfirm systemd
#Let's dream of a world where this isn't required ->	command -v tidy >/dev/null 2>&1 || pacman -S --noconfirm tidy
#Let's dream of a world where this isn't required ->	[ -e /usr/lib/libodbc.so ] || pacman -S --noconfirm unixobdc
#Let's dream of a world where this isn't required ->	[ -e /usr/lib/libprocps.so ] || pacman -S --noconfirm procps-ng
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
			--install=no \
			--fstrans=no
			--pkgname=php5-fpm \
			--pkgversion=$pkgver \
			--pkglicence=GPL \
			--maintainer=Unknown \ #<-- FIXME
			--pkgarch=$(dpkg --print-architecture)
			--nodoc \
			--umask=0027 \
			--provides="php5-fpm" \
			--requires="init-system-helpers  \(\>= 1.18\~\), libbz2-1.0, libc6 \(\>= 2.15\), libcomerr2 \(>=1.01\), libdb5.3, libgssapi-krb5-2 \(\>= 1.6.dfsg.2\), libk5crypto3 \(\>= 1.6.dfsg.2\), libkrb5-3 \(\>= 1.6.dfsg.2\), libmagic1, libonig2 (>= 5.9.5), libpcre3, libqdbm14 \(\>= 1.8.74\), libssl1.0.2 \(\>= 1.0.2d\), libsystemd0, libxml2 \(\>= 2.9.0\), mime-support, tzdata, ucf, zlib1g \(\>= 1:1.1.4\)"
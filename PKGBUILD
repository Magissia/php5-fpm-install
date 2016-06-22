# $Id$
# Maintainer: Magissia <ArchPackage@magissia.com>
# Contributor: Pierre Schmitz <pierre@archlinux.de>
# Contributor: mickael9 <mickael9 at gmail.com>

pkgbase=php5
pkgname=("${pkgbase}"
         "${pkgbase}-cgi"
         "${pkgbase}-fpm"
         "${pkgbase}-embed"
         "${pkgbase}-phpdbg"
         "${pkgbase}-dblib"
         "${pkgbase}-pear"
         "${pkgbase}-enchant"
         "${pkgbase}-gd"
         "${pkgbase}-imap"
         "${pkgbase}-intl"
         "${pkgbase}-ldap"
         "${pkgbase}-mcrypt"
         "${pkgbase}-mssql"
         "${pkgbase}-odbc"
         "${pkgbase}-pgsql"
         "${pkgbase}-pspell"
         "${pkgbase}-snmp"
         "${pkgbase}-sqlite"
         "${pkgbase}-tidy"
         "${pkgbase}-xsl")
pkgver=5.6.22
pkgrel=2
pkgdesc="PHP is a server-side scripting language designed for web development but also used as a general-purpose programming language. "
arch=('i686' 'x86_64')
license=('PHP')
url='http://www.php.net'
makedepends=('c-client' 'postgresql-libs' 'libldap' 'postfix'
             'sqlite' 'unixodbc' 'net-snmp' 'libzip' 'enchant' 'file' 'freetds'
             'libmcrypt' 'tidyhtml' 'aspell' 'libltdl' 'gd' 'icu'
             'curl' 'libxslt' 'openssl' 'db' 'gmp' 'systemd' 'git')
checkdepends=('procps-ng')
source=("http://www.php.net/distributions/${pkgbase%5}-${pkgver}.tar.xz"
        "http://www.php.net/distributions/${pkgbase%5}-${pkgver}.tar.xz.asc"
        'php.ini.patch' 'php-fpm.conf.in.patch'
        'logrotate.d.php-fpm' 'php-fpm.service' 'php-fpm.tmpfiles')
md5sums=('SKIP'
         'SKIP'
         'SKIP'
         'SKIP'
         'SKIP'
         'SKIP'
         'SKIP')
validpgpkeys=('6E4F6AB321FDC07F2C332E3AC2BF0BC433CFC8B3'
              '0BD78B5F97500D450838F95DFE857D9A90D90EC1')

prepare() {
	cd "${srcdir}/${pkgbase%5}-${pkgver}"

	patch -p0 -i "${srcdir}/php.ini.patch"
	patch -p0 -i "${srcdir}/php-fpm.conf.in.patch"
	
	# Allow php-tidy to compile with tidy-html5
	sed 's/buffio\.h/tidybuffio\.h/' -i ext/tidy/tidy.c
}

build() {
	local _phpconfig="--srcdir=../${pkgbase%5}-${pkgver} \
		--config-cache \
		--prefix=/usr \
		--sysconfdir=/etc/${pkgbase} \
		--localstatedir=/var \
		--libdir=/usr/lib/${pkgbase} \
		--datarootdir=/usr/share/${pkgbase} \
		--datadir=/usr/share/${pkgbase} \
		--program-suffix=${pkgbase#php} \
		--with-layout=GNU \
		--with-config-file-path=/etc/${pkgbase} \
		--with-config-file-scan-dir=/etc/${pkgbase}/conf.d \
		--disable-rpath \
		--without-pear \
		"

	local _phpextensions="--enable-bcmath=shared \
		--enable-calendar=shared \
		--enable-dba=shared \
		--enable-exif=shared \
		--enable-ftp=shared \
		--enable-gd-native-ttf \
		--enable-intl=shared \
		--enable-mbstring \
		--enable-opcache \
		--enable-phar=shared \
		--enable-posix=shared \
		--enable-shmop=shared \
		--enable-soap=shared \
		--enable-sockets=shared \
		--enable-sysvmsg=shared \
		--enable-sysvsem=shared \
		--enable-sysvshm=shared \
		--enable-zip=shared \
		--with-bz2=shared \
		--with-curl=shared \
		--with-db4=/usr \
		--with-enchant=shared,/usr \
		--with-fpm-systemd \
		--with-freetype-dir=/usr \
		--with-xpm-dir=/usr \
		--with-gd=shared,/usr \
		--with-gdbm \
		--with-gettext=shared \
		--with-gmp=shared \
		--with-iconv=shared \
		--with-icu-dir=/usr \
		--with-imap-ssl \
		--with-imap=shared \
		--with-kerberos=/usr \
		--with-jpeg-dir=/usr \
		--with-vpx-dir=/usr \
		--with-ldap=shared \
		--with-ldap-sasl \
		--with-libzip \
		--with-mcrypt=shared \
		--with-mhash \
		--with-mssql=shared \
		--with-mysql-sock=/run/mysqld/mysqld.sock \
		--with-mysql=shared,mysqlnd \
		--with-mysqli=shared,mysqlnd \
		--with-openssl=shared \
		--with-pcre-regex=/usr \
		--with-pdo-dblib=shared,/usr \
		--with-pdo-mysql=shared,mysqlnd \
		--with-pdo-odbc=shared,unixODBC,/usr \
		--with-pdo-pgsql=shared \
		--with-pdo-sqlite=shared,/usr \
		--with-pgsql=shared \
		--with-png-dir=/usr \
		--with-pspell=shared \
		--with-snmp=shared \
		--with-sqlite3=shared,/usr \
		--with-tidy=shared \
		--with-unixODBC=shared,/usr \
		--with-xmlrpc=shared \
		--with-xsl=shared \
		--with-zlib \
		"

	export EXTENSION_DIR=/usr/lib/${pkgbase}/modules
	export PEAR_INSTALLDIR=/usr/share/${pkgbase}/pear

	cd "${srcdir}/${pkgbase%5}-${pkgver}"

	# php
	mkdir -p "${srcdir}/build-php"
	cd "${srcdir}/build-php"
	ln -s ../${pkgbase%5}-${pkgver}/configure
	./configure ${_phpconfig} \
		--disable-cgi \
		--with-readline \
		--enable-pcntl \
		${_phpextensions}
	make

	# cgi and fcgi
	# reuse the previous run; this will save us a lot of time
	cp -a "${srcdir}/build-php" "${srcdir}/build-cgi"
	cd "${srcdir}/build-cgi"
	./configure ${_phpconfig} \
		--disable-cli \
		--enable-cgi \
		${_phpextensions}
	make

	# fpm
	cp -a "${srcdir}/build-php" "${srcdir}/build-fpm"
	cd "${srcdir}/build-fpm"
	./configure ${_phpconfig} \
		--disable-cli \
		--enable-fpm \
		--with-fpm-user=http \
		--with-fpm-group=http \
		${_phpextensions}
	make

	# embed
	cp -a "${srcdir}/build-php" "${srcdir}/build-embed"
	cd "${srcdir}/build-embed"
	./configure ${_phpconfig} \
		--disable-cli \
		--enable-embed=shared \
		${_phpextensions}
	make

	# phpdbg
	cp -a "${srcdir}/build-php" "${srcdir}/build-phpdbg"
	cd "${srcdir}/build-phpdbg"
	./configure ${_phpconfig} \
		--disable-cli \
		--disable-cgi \
		--with-readline \
		--enable-phpdbg \
		${_phpextensions}
	make

	# pear
	sed -i 's#@$(top_builddir)/sapi/cli/php $(PEAR_INSTALL_FLAGS) pear/install-pear-nozlib.phar -d#@$(top_builddir)/sapi/cli/php $(PEAR_INSTALL_FLAGS) pear/install-pear-nozlib.phar -p $(bindir)/php$(program_suffix) -d#' ${srcdir}/php-${pkgver}/pear/Makefile.frag
	cp -Ta "${srcdir}/build-php" "${srcdir}/build-pear"
	cd "${srcdir}/build-pear"
	./configure ${_phpconfig} \
		--disable-cgi \
		--with-readline \
		--enable-pcntl \
		--with-pear \
		${_phpextensions}
	make
}

# check() {
# 	# tests on i686 fail
# 	[[ $CARCH == 'i686' ]] && return
# 	# a couple of tests fail in btrfs-backed chroots
# 	[[ $(stat -f -c %T .) == btrfs ]] && return

# 	cd "${srcdir}/build-php"

# 	export REPORT_EXIT_STATUS=1
# 	export NO_INTERACTION=1
# 	export SKIP_ONLINE_TESTS=1
# 	export SKIP_SLOW_TESTS=1

# 	sapi/cli/php -n \
# 		"${srcdir}/${pkgbase}-${pkgver}/run-tests.php" -n -P \
# 		"${srcdir}/${pkgbase}-${pkgver}/{Zend,ext/{date,pcre,spl,standard},sapi/cli}"

# 	echo
# }

package_php5() {
	pkgdesc='An HTML-embedded scripting language'
	depends=('pcre' 'libxml2' 'curl' 'libzip')
	backup=('etc/${pkgbase}/php.ini')
	provides=("${pkgbase%5}=$pkgver")

	cd "${srcdir}/build-php"
	make -j1 INSTALL_ROOT=${pkgdir} install

	# install php.ini
	install -D -m644 "${srcdir}/${pkgbase%5}-${pkgver}/php.ini-production" "${pkgdir}/etc/${pkgbase}/php.ini"
	install -d -m755 "${pkgdir}/etc/${pkgbase}/conf.d/"

	# remove static modules
	rm -f "${pkgdir}/usr/lib/${pkgbase}/modules/*.a"
	# remove modules provided by sub packages
	rm -f "${pkgdir}/usr/lib/${pkgbase}/modules/{enchant,gd,imap,intl,ldap,mcrypt,mssql,odbc,pdo_odbc,pgsql,pdo_pgsql,pspell,snmp,sqlite3,pdo_sqlite,tidy,xsl,pdo_dblib}.so"

	# remove empty directory
	rmdir "${pkgdir}/usr/include/php/include"

	# move include directory
	mv "${pkgdir}/usr/include/php" "${pkgdir}/usr/include/${pkgbase}"

	# fix phar symlink
	rm "${pkgdir}/usr/bin/phar"
	ln -sf "phar.${pkgbase/php/phar}" "${pkgdir}/usr/bin/${pkgbase/php/phar}"

	# rename executables
	mv ${pkgdir}/usr/bin/phar.{phar,${pkgbase/php/phar}}

	# rename man pages
	mv ${pkgdir}/usr/share/man/man1/{phar,${pkgbase/php/phar}}.1
	mv ${pkgdir}/usr/share/man/man1/phar.{phar,${pkgbase/php/phar}}.1

	# fix paths in executables
	sed -i "/^includedir=/c \includedir=/usr/include/${pkgbase}" "${pkgdir}/usr/bin/${pkgbase/php/phpize}"
	sed -i "/^include_dir=/c \include_dir=/usr/include/${pkgbase}" "${pkgdir}/usr/bin/${pkgbase/php/php-config}"

	# make phpize use php-config
	sed -i "/^\[  --with-php-config=/c \[  --with-php-config=PATH  Path to php-config ["${pkgbase/php/php-config}"]], "${pkgbase/php/php-config}", no)" "${pkgdir}/usr/lib/${pkgbase}/build/phpize.m4"
}

package_php5-cgi() {
	pkgdesc='CGI and FCGI SAPI for PHP'
	depends=('${pkgbase}')
	provides=('${pkgbase%5}-cgi=$pkgver')

	install -D -m755 "${srcdir}/build-cgi/sapi/cgi/php-cgi" "${pkgdir}/usr/bin/${pkgbase}-cgi"
}


package_php5-fpm() {
	pkgdesc='FastCGI Process Manager for PHP'
	depends=('${pkgbase}' 'systemd')
	provides=('${pkgbase%5}-fpm=$pkgver')
	backup=('etc/${pkgbase}/php-fpm.conf')
	install='php-fpm.install'

	install -D -m755 "${srcdir}/build-fpm/sapi/fpm/php-fpm" "${pkgdir}/usr/bin/${pkgbase}-fpm"
	install -D -m644 "${srcdir}/build-fpm/sapi/fpm/php-fpm.8" "${pkgdir}/usr/share/man/man8/${pkgbase}-fpm.8"
	install -D -m644 "${srcdir}/build-fpm/sapi/fpm/php-fpm.conf" "${pkgdir}/etc/${pkgbase}/php-fpm.conf"
	install -D -m644 "${srcdir}/logrotate.d.php-fpm" "${pkgdir}/etc/logrotate.d/${pkgbase}-fpm"
	install -d -m755 "${pkgdir}/etc/${pkgbase}/fpm.d"
	install -D -m644 "${srcdir}/php-fpm.tmpfiles" "${pkgdir}/usr/lib/tmpfiles.d/${pkgbase}-fpm.conf"
	install -D -m644 "${srcdir}/php-fpm.service" "${pkgdir}/usr/lib/systemd/system/${pkgbase}-fpm.service"
}

package_php5-embed() {
	pkgdesc='Embedded PHP SAPI library'
	depends=('${pkgbase}')
	provides=('${pkgbase%5}-embed=$pkgver')

	install -D -m755 "${srcdir}/build-embed/libs/libphp5.so" "${pkgdir}/usr/lib/libphp5.so"
	install -D -m644 "${srcdir}/${pkgbase%5}-${pkgver}/sapi/embed/php_embed.h" "${pkgdir}/usr/include/${pkgbase}/sapi/embed/php_embed.h"
}

package_php5-phpdbg() {
	pkgdesc='Interactive PHP debugger'
	depends=('${pkgbase}')
	provides=('${pkgbase%5}-phpbg=$pkgver')

	install -D -m755 "${srcdir}/build-phpdbg/sapi/phpdbg/phpdbg" "${pkgdir}/usr/bin/${pkgbase}dbg"
}

package_php5-pear() {
	pkgdesc='PHP Extension and Application Repository'
	depends=('${pkgbase}')
	provides=('${pkgbase%5}-pear=$pkgver')
	backup=('etc/${pkgbase}/pear.conf')

	cd ${srcdir}/build-pear
	make install-pear INSTALL_ROOT=${pkgdir}
	rm -rf "${pkgdir}/usr/share/${pkgbase}/pear/.{channels,depdb,depdblock,filemap,lock,registry}"

	mv "${pkgdir}/usr/bin/{pear,${pkgbase/php/pear}}"
	mv "${pkgdir}/usr/bin/{peardev,${pkgbase/php/peardev}}"
	mv "${pkgdir}/usr/bin/{pecl,${pkgbase/php/pecl}}"
}

package_php5-enchant() {
	pkgdesc='enchant module for PHP'
	depends=('${pkgbase}' 'enchant')
	provides=('${pkgbase%5}-enchant=$pkgver')

	install -D -m755 "${srcdir}/build-php/modules/enchant.so" "${pkgdir}/usr/lib/${pkgbase}/modules/enchant.so"
}

package_php5-gd() {
	pkgdesc='gd module for PHP'
	depends=('${pkgbase}' 'gd')
	provides=('${pkgbase%5}-gd=$pkgver')

	install -D -m755 "${srcdir}/build-php/modules/gd.so" "${pkgdir}/usr/lib/${pkgbase}/modules/gd.so"
}

package_php5-imap() {
	pkgdesc='imap module for PHP'
	depends=('${pkgbase}' 'c-client')
	provides=('${pkgbase%5}-imap=$pkgver')

	install -D -m755 "${srcdir}/build-php/modules/imap.so" "${pkgdir}/usr/lib/${pkgbase}/modules/imap.so"
}

package_php5-intl() {
	pkgdesc='intl module for PHP'
	depends=('${pkgbase}' 'icu')
	provides=('${pkgbase%5}-intl=$pkgver')

	install -D -m755 "${srcdir}/build-php/modules/intl.so" "${pkgdir}/usr/lib/${pkgbase}/modules/intl.so"
}

package_php5-ldap() {
	pkgdesc='ldap module for PHP'
	depends=('${pkgbase}' 'libldap')
	provides=('${pkgbase%5}-ldap=$pkgver')

	install -D -m755 "${srcdir}/build-php/modules/ldap.so" "${pkgdir}/usr/lib/${pkgbase}/modules/ldap.so"
}

package_php5-mcrypt() {
	pkgdesc='mcrypt module for PHP'
	depends=('${pkgbase}' 'libmcrypt' 'libltdl')
	provides=('${pkgbase%5}-mcrypt=$pkgver')

	install -D -m755 "${srcdir}/build-php/modules/mcrypt.so" "${pkgdir}/usr/lib/${pkgbase}/modules/mcrypt.so"
}

package_php5-mssql() {
	pkgdesc='mssql module for PHP'
	depends=('${pkgbase}' 'freetds')
	provides=('${pkgbase%5}-mssql=$pkgver')

	install -D -m755 "${srcdir}/build-php/modules/mssql.so" "${pkgdir}/usr/lib/${pkgbase}/modules/mssql.so"
}

package_php5-odbc() {
	pkgdesc='ODBC modules for PHP'
	depends=('${pkgbase}' 'unixodbc')
	provides=('${pkgbase%5}-odbc=$pkgver')

	install -D -m755 "${srcdir}/build-php/modules/odbc.so" "${pkgdir}/usr/lib/${pkgbase}/modules/odbc.so"
	install -D -m755 "${srcdir}/build-php/modules/pdo_odbc.so" "${pkgdir}/usr/lib/${pkgbase}/modules/pdo_odbc.so"
}

package_php5-pgsql() {
	pkgdesc='PostgreSQL modules for PHP'
	depends=('${pkgbase}' 'postgresql-libs')
	provides=('${pkgbase%5}-pgsql=$pkgver')

	install -D -m755 "${srcdir}/build-php/modules/pgsql.so" "${pkgdir}/usr/lib/${pkgbase}/modules/pgsql.so"
	install -D -m755 "${srcdir}/build-php/modules/pdo_pgsql.so" "${pkgdir}/usr/lib/${pkgbase}/modules/pdo_pgsql.so"
}

package_php5-pspell() {
	pkgdesc='pspell module for PHP'
	depends=('${pkgbase}' 'aspell')
	provides=('${pkgbase%5}-pspell=$pkgver')

	install -D -m755 "${srcdir}/build-php/modules/pspell.so" "${pkgdir}/usr/lib/${pkgbase}/modules/pspell.so"
}

package_php5-snmp() {
	pkgdesc='snmp module for PHP'
	depends=('${pkgbase}' 'net-snmp')
	provides=('${pkgbase%5}-snmp=$pkgver')

	install -D -m755 "${srcdir}/build-php/modules/snmp.so" "${pkgdir}/usr/lib/${pkgbase}/modules/snmp.so"
}

package_php5-sqlite() {
	pkgdesc='sqlite module for PHP'
	depends=('${pkgbase}' 'sqlite')
	provides=('${pkgbase%5}-sqlite=$pkgver')

	install -D -m755 "${srcdir}/build-php/modules/sqlite3.so" "${pkgdir}/usr/lib/${pkgbase}/modules/sqlite3.so"
	install -D -m755 "${srcdir}/build-php/modules/pdo_sqlite.so" "${pkgdir}/usr/lib/${pkgbase}/modules/pdo_sqlite.so"
}

package_php5-tidy() {
	pkgdesc='tidy module for PHP'
	depends=('${pkgbase}' 'tidyhtml')
	provides=('${pkgbase%5}-tidy=$pkgver')

	install -D -m755 "${srcdir}/build-php/modules/tidy.so" "${pkgdir}/usr/lib/${pkgbase}/modules/tidy.so"
}

package_php5-dblib() {
	pkgdesc='dblib module for PHP'
	depends=("${pkgbase}")
	provides=("${pkgbase%5}-dblib=$pkgver")

	install -D -m755 "${srcdir}/build-php/modules/pdo_dblib.so" "${pkgdir}/usr/lib/${pkgbase}/modules/pdo_dblib.so"
}

package_php5-xsl() {
	pkgdesc='xsl module for PHP'
	depends=('${pkgbase}' 'libxslt')
	provides=('${pkgbase%5}-xsl=$pkgver')

	install -D -m755 "${srcdir}/build-php/modules/xsl.so" "${pkgdir}/usr/lib/${pkgbase}/modules/xsl.so"
}
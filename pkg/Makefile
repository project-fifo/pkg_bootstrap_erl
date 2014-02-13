VERSION=0.1.0
PACKAGE=stuff
CATEGORIES=stuff

.PHONY: build_info package package_list

package_list:
	cat pre_pkg > packlist
	(cd ../staging/; find * -type f | sort) >> packlist
	cat post_pkg >> packlist

build_info:
	pkg_info -X pkg_install | egrep '^(MACHINE_ARCH|OPSYS|OS_VERSION|PKGTOOLS_VERSION)' >build-info
	echo "CATEGORIES=$CATEGORIES" >>build-info
	echo "HOMEPAGE=https://lucerahq.com" >>build-info

clean:
	-rm *.tgz build-info packlist

package: package_list build_info
	pkg_create -i install.sh -k deinstall.sh -D displayfile -B build-info -c comment -d description -f packlist -I /opt/local/ -p ../staging -U $(PACKAGE)-$(VERSION)$(SUFFIX).tgz

include ../../project.mk

.PHONY: build_info package_list

package: package_list build_info
	pkg_create -i install.sh -k deinstall.sh -D displayfile -B build-info -c comment -d description -f packlist -I /opt/local/ -p staging -U $(PROJECT)-$(VERSION)$(SUFFIX).tgz

stage:
	cp -r ../$(PROJECT) staging

package_list: stage
	cat pre_pkg > packlist
	(cd staging/; find * -type f | sort) >> packlist
	cat post_pkg >> packlist

build_info:
	pkg_info -X pkg_install | egrep '^(MACHINE_ARCH|OPSYS|OS_VERSION|PKGTOOLS_VERSION)' >build-info
	echo "CATEGORIES=$(CATEGORIES)" >>build-info
	echo "HOMEPAGE=$(HOMEPAGE)" >>build-info

clean:
	-rm *.tgz build-info packlist


include project.mk
include tools.mk

RELFILES = reltool.config rebar.config vars.config
STAGEDIR = rel/pkg/staging

.PHONY: deps templates

compile:
	$(REBAR) compile


deps:
	$(REBAR) get-deps

clean:
	$(REBAR) clean
	make -C rel/pkg clean

rel: compile-no-deps
	[ -d rel/$(PROJECT)/share ] && rm -r rel/$(PROJECT)/share || true
	$(REBAR) generate

package: rel
	make -C rel/pkg

init: check-appid init-app init-rel init-pkg
	echo 'PROJECT = $(appid)' >> project.mk


check-appid:
	@if [ "$(appid)x" == "x" ]; then echo "Please set appid!"; exit 1; fi

init-app:
	mkdir -p apps/$(appid)
	(cd apps/$(appid); $(REBAR) create-app appid=$(appid))

init-rel: check-appid init-rel-generate init-rel-templates
	rm rel/files/sys.config
	rm rel/files/vm.args
	rm rel/files/start_erl.cmd
	rm rel/files/$(appid).cmd
	sed 's/APPID/$(appid)/g' templates/schema > schema/$(appid).schema

init-rel-generate:
	(cd rel; $(REBAR) create-node nodeid=$(appid))

init-rel-templates:
	for file in $(RELFILES);\
	do\
		sed 's/APPID/$(appid)/g' templates/$$file > rel/$$file;\
	done
	sed 's/APPID/$(appid)/g' templates/app > rel/files/$(appid)

init-pkg: check-appid
	mkdir -p $(STAGEDIR)/sbin
	sed 's/APPID/$(appid)/g' templates/executable > $(STAGEDIR)/sbin/$(appid)
	sed 's/APPID/$(appid)/g' templates/install.sh > $(STAGEDIR)/install.sh
	mkdir share
	sed 's/APPID/$(appid)/g' templates/smf.xml > share/$(appid).xml

uninit:
	-rm -r apps
	-(cd rel; rm -rf files $(RELFILES))
	-rm -r $(STAGEDIR)
	-rm -r share
	-rm schema/$(PROJECT).schema
	-[ '$(PROJECT)x' != "x" ] && rm -r rel/$(PROJECT)

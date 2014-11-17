include project.mk
include tools.mk

RELFILES = reltool.config rebar.config vars.config
STAGEDIR = rel/pkg/staging

.PHONY: deps templates

compile:
	$(REBAR) compile


deps:
	$(REBAR) get-deps

init: check-appid init-app init-rel init-pkg
	echo 'PROJECT = "$(appid)"' >> project.mk


check-appid:
	@if [ "$(appid)x" == "x" ]; then echo "Please set appid!"; exit 1; fi

init-app:
	mkdir -p apps/$(appid)
	(cd apps/$(appid); ../../rebar create-app appid=$(appid))

init-rel: check-appid init-rel-generate init-rel-templates
	rm rel/files/sys.config
	rm rel/files/vm.args
	rm rel/files/start_erl.cmd
	rm rel/files/$(appid).cmd
	sed 's/APPID/$(appid)/g' templates/schema > schema/$(appid).schema

init-rel-generate:
	(cd rel; ../rebar create-node nodeid=$(appid))

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
	-rm -rf apps
	-(cd rel; rm -rf files $(RELFILES))
	-rm -r $(STAGEDIR)
	-rm share/$(appid).xml

#Bootstrap for Erlang applications on SmartOS

It includes:

	* cuttlefish support (for noce config files)
	* lager for logging
	* a templace for creating pkg packages
	* fqc (a QickCheck heler)

Copy the content of the repo into a new place then run:

```
make init appid=your_new_application
```

Customize the `rebar.config` to your needs (adding or removing dependencies) and the project.mk to adjust project details if wanted. 

By default the make tasks do not fetch dependencies so you need to run `make deps` for that before the first run.


* `make rel` generates a release
* `make package` generates a pkgin package (will only work on SmartOS)

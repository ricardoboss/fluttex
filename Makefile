clean: clean-fluttex clean-packages

clean-fluttex:
	@flutter clean

clean-packages: clean-bob clean-common clean-css_parser clean-flavio clean-html_parser clean-sandy clean-smith

clean-bob:
	@cd packages/bob && flutter clean

clean-common:
	@cd packages/common && flutter clean

clean-css_parser:
	@cd packages/css_parser && flutter clean

clean-flavio:
	@cd packages/flavio && flutter clean

clean-html_parser:
	@cd packages/html_parser && flutter clean

clean-sandy:
	@cd packages/sandy && flutter clean

clean-smith:
	@cd packages/smith && flutter clean

pub-get: pub-get-fluttex pub-get-packages

pub-get-fluttex:
	@flutter pub get

pub-get-packages: pub-get-bob pub-get-common pub-get-css_parser pub-get-flavio pub-get-html_parser pub-get-sandy pub-get-smith

pub-get-bob:
	@cd packages/bob && flutter pub get

pub-get-common:
	@cd packages/common && flutter pub get

pub-get-css_parser:
	@cd packages/css_parser && flutter pub get

pub-get-flavio:
	@cd packages/flavio && flutter pub get

pub-get-html_parser:
	@cd packages/html_parser && flutter pub get

pub-get-sandy:
	@cd packages/sandy && flutter pub get

pub-get-smith:
	@cd packages/smith && flutter pub get

pub-upgrade: pub-upgrade-fluttex pub-upgrade-packages

pub-upgrade-fluttex:
	@flutter pub upgrade --major-versions

pub-upgrade-packages: pub-upgrade-bob pub-upgrade-common pub-upgrade-css_parser pub-upgrade-flavio pub-upgrade-html_parser pub-upgrade-sandy pub-upgrade-smith

pub-upgrade-bob:
	@cd packages/bob && flutter pub upgrade --major-versions

pub-upgrade-common:
	@cd packages/common && flutter pub upgrade --major-versions

pub-upgrade-css_parser:
	@cd packages/css_parser && flutter pub upgrade --major-versions

pub-upgrade-flavio:
	@cd packages/flavio && flutter pub upgrade --major-versions

pub-upgrade-html_parser:
	@cd packages/html_parser && flutter pub upgrade --major-versions

pub-upgrade-sandy:
	@cd packages/sandy && flutter pub upgrade --major-versions

pub-upgrade-smith:
	@cd packages/smith && flutter pub upgrade --major-versions

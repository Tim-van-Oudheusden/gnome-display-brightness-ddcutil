UUID := display-brightness-ddcutil@tim-van-oudheusden.github.io
DOMAIN := display-brightness-ddcutil
ZIP := dist/$(UUID).shell-extension.zip

.PHONY: all build install pot update-po lint check clean

all: build

# Everything in src/ ships; gnome-extensions pack compiles the schema and the
# translations in po/ into the bundle.
build:
	mkdir -p dist
	gnome-extensions pack \
		--force \
		--extra-source=lib \
		--extra-source=preferences \
		--extra-source=ui \
		--podir=../po \
		--out-dir=dist \
		src

install: build
	gnome-extensions install --force "$(ZIP)"

pot:
	xgettext \
		--from-code=UTF-8 \
		--package-name="$(DOMAIN)" \
		--files-from=po/POTFILES \
		--output="po/$(DOMAIN).pot"

update-po: pot
	for po_file in po/*.po; do \
		msgmerge --update --backup=none "$$po_file" "po/$(DOMAIN).pot"; \
	done

lint:
	npx eslint .

check:
	glib-compile-schemas --strict --dry-run src/schemas
	for po_file in po/*.po; do \
		msgfmt --check --output-file=/dev/null "$$po_file" || exit 1; \
	done

clean:
	rm -rf dist
	rm -f src/schemas/gschemas.compiled

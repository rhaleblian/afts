# The index updating workflow is
# make sync
# make upload
# make index

REMOTE=haleblia@haleblian.com
BASEHREF=www/ray/taxreview
TEMPLATES=opt/var/lib/omega/templates
DB=opt/var/lib/omega/data/default

default:
	echo Available rules: sync upload index install
	echo See Makefile.

sync:
	./doc-sync.py

upload:
	rsync -rv www/html/ haleblia@haleblian.com:www/ray/taxreview/html/

index:
	ssh haleblia@haleblian.com omindex --db $(DB) www/ray taxreview/html

install:
	rsync -dv --delete www/* $(REMOTE):$(BASEHREF)/
	scp omega/templates/afts $(REMOTE):$(TEMPLATES)/


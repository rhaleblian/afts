# The index updating workflow is
# make sync
# make upload
# make index

# begin site-specific parameters
REMOTE=haleblia@haleblian.com
BASEHREF=www/ray/taxreview
OMEGALIB=opt/var/lib/omega
DB=$(OMEGALIB)/data/default
# end site-specific parameters

default: install convert upload index

convert:
	./convert.py

upload-cdb:
	rsync -r omega/cdb/ $(REMOTE):$(OMEGALIB)/cdb/

upload: upload-cdb
	rsync -r www/html/ $(REMOTE):$(BASEHREF)/html/

update: convert upload

index:
	ssh $(REMOTE) omindex --db $(DB) www/ray taxreview/html

install:
	rsync -dv --delete www/* $(REMOTE):$(BASEHREF)/
	rsync -r omega/ $(REMOTE):$(OMEGALIB)/

all: convert upload index install


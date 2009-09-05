# The index updating workflow is
# make sync
# make upload
# make index

SSHREMOTE=haleblia@haleblian.com

default:
	echo Available rules: sync upload index
	echo See Makefile.

sync:
	doc-sync

upload:
	doc-upload

index:
	ssh haleblia@haleblian.com omindex

install:
	rsync -v www/ $(SSHREMOTE):www/ray/taxreview/



default:
	echo Available rules: sync upload index
	echo See Makefile.

sync:
	doc-sync

upload:
	doc-index

index:
	ssh haleblia@haleblian.com omindex


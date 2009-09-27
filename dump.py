#!/usr/bin/env python
# check the contents of the PDF url mapping table.
import cdb
db = cdb.init('omega/cdb/pdfurl')
for key in db.keys():
    print key,' ',db.get(key)

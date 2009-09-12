#!/usr/bin/env python

import re
import time
import os
import urllib2
import StringIO
from mechanize import Browser

def pdf_to_csv(filename):
    from pdfminer.converter import LTTextItem, TextConverter
    from pdfminer.pdfparser import PDFDocument, PDFParser
    from pdfminer.pdfinterp import PDFResourceManager, PDFPageInterpreter

    class CsvConverter(TextConverter):
        def __init__(self, *args, **kwargs):
            TextConverter.__init__(self, *args, **kwargs)

        def end_page(self, i):
            from collections import defaultdict
            lines = defaultdict(lambda : {})
            for child in self.cur_item.objs:
                if isinstance(child, LTTextItem):
                    (_,_,x,y) = map(float, child.get_bbox().split(','))
                    line = lines[int(-y)]
                    line[x] = child.text

            for y in sorted(lines.keys()):
                line = lines[y]
                self.outfp.write(";".join(line[x] for x in sorted(line.keys())))
                self.outfp.write("\n")

    # ... the following part of the code is a remix of the 
    # convert() function in the pdfminer/tools/pdf2text module
    rsrc = PDFResourceManager()
    outfp = StringIO.StringIO()
    device = CsvConverter(rsrc, outfp, "ascii")

    doc = PDFDocument()
    fp = open(filename, 'rb')
    parser = PDFParser(doc, fp)
    doc.initialize('')

    interpreter = PDFPageInterpreter(rsrc, device)

    for i, page in enumerate(doc.get_pages()):
        outfp.write("START PAGE %d\n" % i)
        interpreter.process_page(page)
        outfp.write("END PAGE %d\n" % i)

    device.close()
    fp.close()

    return outfp.getvalue()

b = Browser()
for round in range(1,4):
    url = 'http://taxreview.treasury.gov.au/content/submission.aspx?round=' + str(round)
    b.open(url)
    for link in b.links(url_regex='pdf$'):

        u = b.click_link(link).get_full_url()
#        print "link: ", u
        try:
            f = urllib2.urlopen(u)
        except:
            continue

        remotefile = re.search('[^/]+$',u).group(0)
        remotetime = time.mktime(f.info().getdate('Last-Modified'))

        base = re.search('[^\.]+',remotefile).group(0)
        localhtml = 'www/html/' + str(round) + '/' + base + '.html'
        localpdf = 'pdf/' + str(round) + '/' + base + '.pdf'
        localtime = 0

        have = 1
        try:
            localtime = os.stat(localhtml).st_mtime
        except OSError:
            try:
                localtime = os.stat(localpdf).st_mtime
            except OSError:
                have = 0

        if have == 0:
            fp = open('pdf/' + str(round) + '/' + remotefile,'w')
            fp.write(f.read())
            fp.close()
            #print pdf_to_csv('www/pdf/' + str(round) + '/' + remotefile)
            os.system('pdftohtml -noframes ' + localpdf + ' ' + localhtml)
            print 'Fetched and converted ' + remotefile + '.'


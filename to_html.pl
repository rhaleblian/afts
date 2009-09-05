#!/usr/bin/env perl

for(<taxreview.treasury.gov.au/content/submissions/*.pdf>) { &convert($_); }
for(<taxreview.treasury.gov.au/content/submissions/retirement/*.pdf>) { &convert($_); }

sub convert($file)
{
	$pdf = $_;
	$pdf =~ s/.+\///;
	$html = $pdf;
	$html =~ s/\.pdf$/\.html/;
	$cmd = "pdftohtml -noframes -enc UTF-8 $_ html/$html";
	print $cmd; print "\n";
	system($cmd);
}


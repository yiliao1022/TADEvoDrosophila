perl chip_overlap40kb.pl Dpse_hicexplorer.boundaries.bed CTCF.peaks.list > Observed.CTCF.txt
for i in {-40..40}; do echo "$i" >> Coord.txt; done
perl tmp.pl Observed.CTCF.txt > CTCF.40k.list
paste Coord.txt CTCF.40k.list > CTCF.40k.final.list
perl chip_overlap40kb.pl Dpse_hicexplorer.boundaries.bed BEAF.peak.list > Observed.BEAF.txt
perl tmp.pl Observed.BEAF.txt > BEAF.40k.list
paste Coord.txt BEAF.40k.list > BEAF.40k.final.list

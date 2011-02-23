TARGET := doc
TRASH  := $(TARGET).pdf \
          $(TARGET).dvi \
          $(TARGET).aux \
          $(TARGET).log \
	  $(TARGET).bbl \
          $(TARGET).blg \
	  $(TARGET).out \
	  transmiter.dot.eps

.PHONY: all clean
.SUFFIXES:
.SECONDARY:

all : $(TARGET).pdf

clean :
	rm -f $(TRASH)

%.pdf : %.dvi
	dvipdf $< $@

%.dvi : %.tex %.bib
	latex -interaction=nonstopmode $*
	bibtex $*
	latex -interaction=nonstopmode $*
	latex -interaction=nonstopmode $*


dot : transmiter.dot.eps

%.dot.eps : %.dot
	dot -Teps $< > $@


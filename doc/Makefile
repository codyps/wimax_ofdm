TARGET := doc
TRASH  := $(TARGET).pdf \
          $(TARGET).dvi \
          $(TARGET).aux \
          $(TARGET).log \
	  $(TARGET).bbl \
          $(TARGET).blg \
	  $(TARGET).out \
	  transmiter.dot.eps

LATEX    = pdflatex
G_EXT    = pdf
BIBTEX   = bibtex
GRAPHICS = t_block rand

G_OUT = $(GRAPHICS:=.$(G_EXT))

.PHONY: all clean
.SUFFIXES:
.SECONDARY:

all : $(TARGET).pdf

clean :
	rm -f $(TRASH)

%.pdf : %.eps
	ps2pdf $< $@

%.eps : %.dia
	dia -e $@ $<

%.pdf : %.ps
	ps2pdf $<

%.ps : %.dvi
	dvips -Ppdf $< -o $@

#%.pdf : %.dvi
#	dvipdf $< $@

%.dvi : %.tex %.bib $(G_OUT)
	$(LATEX) -interaction=nonstopmode $*
	$(BIBTEX) $*
	$(LATEX) -interaction=nonstopmode $*
	$(LATEX) -interaction=nonstopmode $*

dot : transmiter.dot.eps

%.dot.eps : %.dot
	dot -Teps $< > $@


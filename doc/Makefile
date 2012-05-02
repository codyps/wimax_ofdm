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

%.eps : %.dia
	dia -e $@ $<

%.pdf : %.ps
	ps2pdf $<

%.ps : %.dvi
	dvips -Ppdf $< -o $@


#%.pdf : %.dvi
#	dvipdf $< $@

%.dvi : %.tex %.bib t_block.eps rand.eps
	latex -interaction=nonstopmode $*
	bibtex $*
	latex -interaction=nonstopmode $*
	latex -interaction=nonstopmode $*

#%.pdf : %.tex %.bib t_block.eps rand.eps
#	pdflatex -interaction=nonstopmode $*
#	bibtex $*
#	pdflatex -interaction=nonstopmode $*
#	pdflatex -interaction=nonstopmode $*

dot : transmiter.dot.eps

%.dot.eps : %.dot
	dot -Teps $< > $@


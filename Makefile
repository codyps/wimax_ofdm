TARGET := doc
TRASH  := $(TARGET).pdf \
          $(TARGET).dvi \
          $(TARGET).aux \
          $(TARGET).log \
	  transmiter.dot.eps

.PHONY: all clean
.SUFFIXES:
.SECONDARY:

all : $(TARGET).pdf

clean :
	rm -f $(TRASH)

%.pdf : %.dvi
	dvipdf $< $@

%.dvi : %.tex
	latex -interaction=nonstopmode $<
	latex -interaction=nonstopmode $<


dot : transmiter.dot.eps

%.dot.eps : %.dot
	dot -Teps $< > $@


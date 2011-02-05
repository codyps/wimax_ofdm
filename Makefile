TARGET := doc
TRASH  := $(TARGET).pdf \
          $(TARGET).dvi \
          $(TARGET).aux \
          $(TARGET).log \

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


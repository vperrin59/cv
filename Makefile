.PHONY: examples font_setup bib test

CC = xelatex
CC_OPTS = -interaction=nonstopmode -file-line-error
# HTML
# CC = htlatex
EXAMPLES_DIR = examples
MY_CV_DIR = my_cv
MY_CV_OBJ_DIR = my_cv/obj
RESUME_DIR = examples/resume
CV_DIR = my_cv/cv
RESUME_SRCS = $(shell find $(RESUME_DIR) -name '*.tex')
CV_SRCS = $(shell find $(CV_DIR) -name '*.tex')

examples: $(foreach x, coverletter cv resume, $x.pdf)

# Fonts need to be installed before generating the CV
font_setup:
	apt-get update && apt-get install -y wget
	wget http://ftp.de.debian.org/debian/pool/contrib/m/msttcorefonts/ttf-mscorefonts-installer_3.8_all.deb
	apt-get install -y ./ttf-mscorefonts-installer_3.8_all.deb
	fc-match Verdana
	cp fonts.conf /etc/fonts/conf.d/10-substitute-roboto-to-verdana.conf
	fc-match Roboto

resume.pdf: $(EXAMPLES_DIR)/resume.tex $(RESUME_SRCS)
	$(CC) -output-directory=$(EXAMPLES_DIR) $<

$(MY_CV_OBJ_DIR)/cv.pdf: $(MY_CV_DIR)/cv.tex $(CV_SRCS)
	mkdir -p $(MY_CV_OBJ_DIR)
	export TEXINPUTS=$(MY_CV_DIR)//:;$(CC) $(CC_OPTS) -output-directory=$(MY_CV_OBJ_DIR) $<

# Changing the output directory is affecting LaTeX path resolution
cv.pdf: $(MY_CV_DIR)/cv.tex $(CV_SRCS)
	make $(MY_CV_OBJ_DIR)/cv.pdf
	make bib
	make -B $(MY_CV_OBJ_DIR)/cv.pdf
	make -B $(MY_CV_OBJ_DIR)/cv.pdf

$(MY_CV_OBJ_DIR)/cv.txt: $(MY_CV_OBJ_DIR)/cv.pdf
	pdftotext $< $*

coverletter.pdf: $(MY_CV_DIR)/coverletter.tex
	mkdir -p $(MY_CV_OBJ_DIR)
	export TEXINPUTS=$(MY_CV_DIR)//:;$(CC) -output-directory=$(MY_CV_OBJ_DIR) $<

clean:
	rm -rf $(MY_CV_OBJ_DIR)

dbg:
	fc-match Roboto
	echo $(CV_SRCS)

$(MY_CV_OBJ_DIR)/cv.bbl: $(MY_CV_DIR)/cv.tex $(MY_CV_DIR)/references.bib $(MY_CV_OBJ_DIR)/cv.bcf
	biber $(MY_CV_OBJ_DIR)/cv --input-directory=$(MY_CV_DIR)

bib: $(MY_CV_OBJ_DIR)/cv.bbl

test: $(MY_CV_DIR)/cv.tex
	export TEXINPUTS=$(MY_CV_DIR)//:;export BIBINPUTS=$(MY_CV_DIR)//:;latexmk -pdf -xelatex -output-directory=$(MY_CV_OBJ_DIR) $<

all: cv.pdf bib cv.pdf coverletter.pdf
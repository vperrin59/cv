.PHONY: examples font_setup bib

CC = xelatex
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
	mkdir ~/.fonts -p
	cp fonts/*.ttf ~/.fonts

resume.pdf: $(EXAMPLES_DIR)/resume.tex $(RESUME_SRCS)
	$(CC) -output-directory=$(EXAMPLES_DIR) $<

# Changing the output directory is affecting LaTeX path resolution
cv.pdf: $(MY_CV_DIR)/cv.tex $(CV_SRCS)
	mkdir -p $(MY_CV_OBJ_DIR)
	export TEXINPUTS=$(MY_CV_DIR)//:;$(CC) -output-directory=$(MY_CV_OBJ_DIR) $<

coverletter.pdf: $(EXAMPLES_DIR)/coverletter.tex
	$(CC) -output-directory=$(EXAMPLES_DIR) $<

clean:
	rm -rf $(MY_CV_OBJ_DIR)

dbg:
	fc-match Roboto
	echo $(CV_SRCS)

bib:$(MY_CV_DIR)/cv.tex $(MY_CV_DIR)/references.bib
	biber $(MY_CV_OBJ_DIR)/cv --input-directory=$(MY_CV_DIR)

all: cv.pdf bib cv.pdf
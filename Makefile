.PHONY: examples font_setup

# CC = xelatex
CC = htlatex
EXAMPLES_DIR = examples
MY_CV_DIR = my_cv
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

cv.pdf: $(MY_CV_DIR)/cv.tex $(CV_SRCS)
	$(CC) -output-directory=$(MY_CV_DIR) $<

coverletter.pdf: $(EXAMPLES_DIR)/coverletter.tex
	$(CC) -output-directory=$(EXAMPLES_DIR) $<

clean:
	rm -rf $(EXAMPLES_DIR)/*.pdf

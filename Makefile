# Gaurav Dhingra — Resume
# Usage:
#   make          Build resume.pdf
#   make clean    Remove build artifacts
#   make watch    Rebuild on changes (requires inotifywait / fswatch)

TEX    = resume.tex
PDF    = resume.pdf
ENGINE = pdflatex
FLAGS  = -interaction=nonstopmode -halt-on-error

.PHONY: all clean watch

all: $(PDF)

$(PDF): $(TEX)
	$(ENGINE) $(FLAGS) $(TEX)
	@# Run twice for any cross-references / TOC
	$(ENGINE) $(FLAGS) $(TEX)
	@echo "✓ Built $(PDF)"

clean:
	rm -f *.aux *.log *.out *.fls *.fdb_latexmk *.synctex.gz $(PDF)

# Auto-rebuild on save (macOS: brew install fswatch)
watch:
	@echo "Watching $(TEX) for changes..."
	@which fswatch >/dev/null 2>&1 && \
		fswatch -o $(TEX) | while read; do $(MAKE) all; done || \
	(which inotifywait >/dev/null 2>&1 && \
		while inotifywait -e modify $(TEX); do $(MAKE) all; done || \
		echo "Install fswatch (macOS) or inotifywait (Linux) for watch mode")

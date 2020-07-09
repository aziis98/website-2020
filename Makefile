
POSTS = $(wildcard src/post/*)


out/post/%.html: src/post/%.md
	pandoc --katex $< -o $@


.PHONY: fn/extract_frontmatter/%
fn/extract_frontmatter/%: src/post/%.md
	csplit -f .cache/post/$*- -b %01d.part $< '%---%+1' '/---/'
	mv .cache/post/$*-0.part .cache/post/$*.yaml
	mv .cache/post/$*-1.part .cache/post/$*.pretail.md
	tail -n+2 .cache/post/$*.pretail.md > .cache/post/$*.md
	rm .cache/post/$*.pretail.md

.cache/post/%.yaml: fn/extract_frontmatter/%
	
.cache/post/%.md: fn/extract_frontmatter/%
	


.PHONY: clean
clean:
	mkdir -p out
	mkdir -p out/post
	mkdir -p out/tags
	mkdir -p .cache


.PHONY: posts
posts: 
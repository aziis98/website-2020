
POSTS = $(wildcard src/post/*)


out/post/%.html: src/post/%.md
	pandoc --katex $< -o $@


.PHONY: fn/extract_frontmatter/%
fn/extract_frontmatter/%: src/post/%.md
	csplit -f .build/post/$*- -b %01d.part $< '%---%+1' '/---/'
	mv .build/post/$*-0.part .build/post/$*.yaml
	mv .build/post/$*-1.part .build/post/$*.pretail.md
	tail -n+2 .build/post/$*.pretail.md > .build/post/$*.md
	rm .build/post/$*.pretail.md

.build/post/%.yaml: fn/extract_frontmatter/%
	
.build/post/%.md: fn/extract_frontmatter/%
	


.PHONY: clean
clean:
	mkdir -p out
	mkdir -p out/post
	mkdir -p out/tags
	mkdir -p .build


.PHONY: posts
posts: 
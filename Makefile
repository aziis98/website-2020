
POSTS 	  = $(wildcard src/post/*)
POSTS_OUT = $(patsubst src/post/%.md, out/post/%.html, $(POSTS))
POSTS_BUILD_MARKDOWN = $(patsubst src/post/%.md, .build/post/%.md, $(POSTS))
POSTS_BUILD_YAML 	 = $(patsubst src/post/%.md, .build/post/%.yaml, $(POSTS))
POSTS_BUILD_HTML 	 = $(patsubst src/post/%.md, .build/post/%.html, $(POSTS))

POSTS_BUILD_TAGS = $(patsubst src/post/%.md, .build/tags/%.tag, $(POSTS))
TAGS_PATH = .build/tags/*.tag

.PRECIOUS: $(POSTS_BUILD_YAML) 

.build/post/%.md: src/post/%.md
	sed -n -e '1d;/---/,$$p' $< | sed '1d' > $@

.build/post/%.yaml: src/post/%.md
	sed -n -e '/---/,/---/p' $< | sed '1d;$$d' > $@

.build/post/%.html: .build/post/%.md
	pandoc --quiet $< -o $@

out/post/%.html: .build/post/%.html
	gotemplater -o $@ -f yaml -d .build/post/$*.yaml -c $< layouts/post.html

.build/tags/%.tag: .build/post/%.yaml
	yq -r '.tags[]' $< 2> /dev/null | \
	    while read line; do \
	        echo $* >> .build/tags/$$line.tag; \
	    done


.PHONY: clean_tags
clean_tags:
	rm -f .build/tags/*

.PHONY: posts
posts: $(POSTS_OUT)

.PHONY: tags
tags: clean_tags $(POSTS_BUILD_TAGS)
	find $(TAGS_PATH) | \
	    sed 's/\.tag$$//' | \
	    while read line; do	\
	        jq -nR '[inputs | select(length>0)]' $$line.tag > $$line.json; \
	    done


.PHONY: clean
clean:
	mkdir -p out
	mkdir -p out/post
	mkdir -p out/tags
	mkdir -p .build
	mkdir -p .build/post
	mkdir -p .build/tags
	rm -f .build/post/*
	rm -f .build/tags/*
	rm -f out/post/*
	rm -f out/tags/*
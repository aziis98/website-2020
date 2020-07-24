
POSTS 	  = $(wildcard src/post/*)
POSTS_OUT = $(patsubst src/post/%.md, out/post/%.html, $(POSTS))
POSTS_BUILD_MARKDOWN = $(patsubst src/post/%.md, .build/post/%.md, $(POSTS))
POSTS_BUILD_YAML 	 = $(patsubst src/post/%.md, .build/post/%.yaml, $(POSTS))
POSTS_BUILD_HTML 	 = $(patsubst src/post/%.md, .build/post/%.html, $(POSTS))

POSTS_BUILD_TAGS = $(patsubst src/post/%.md, .build/tags/%.tag, $(POSTS))
TAGS_PATH = .build/tags/*.tag

ifeq ($(MODE), dev)
.PRECIOUS: $(POSTS_BUILD_MARKDOWN) $(POSTS_BUILD_YAML) $(POSTS_BUILD_HTML)
endif

# Build Targets

.build/post/%.md: src/post/%.md
	sed -n -e '1d;/---/,$$p' $< | sed '1d' > $@

.build/post/%.yaml: src/post/%.md
	sed -n -e '/---/,/---/p' $< | sed '1d;$$d' > $@
	yq -c '. | .ref = "$*"' $@ >> .build/post/posts

.build/post/%.html: .build/post/%.md
	pandoc --quiet $< -o $@

.build/tags/%.tag: .build/post/%.yaml
	yq -r '.tags[]' $< 2> /dev/null | \
	    while read line; do \
	        echo $* >> .build/tags/$$line.tag; \
	    done

.build/post/posts.json: clean_posts $(POSTS_BUILD_YAML)
	jq -R '{ posts: [ inputs | fromjson ] }' .build/post/posts > $@

# Output Targets

out/post/%.html: .build/post/%.html .build/post/%.yaml
	gotemplater -f yaml -d .build/post/$*.yaml -c .build/post/$*.html layouts/post.html | \
	    gotemplater -f yaml -d .build/post/$*.yaml -c - layouts/_base.html > $@ 

out/index.html: layouts/index.html .build/post/posts.json
	gotemplater -d .build/post/posts.json layouts/index.html | \
	    gotemplater -c - layouts/_base.html > $@

.PHONY: posts
posts: $(POSTS_OUT) 

.PHONY: tags
tags: clean_tags $(POSTS_BUILD_TAGS)
	find $(TAGS_PATH) | \
	    xargs basename -s .tag | \
	    while read tagname; do	\
		    echo "Processing tag: $$tagname"; \
	        jq -nR "{ name: \"$$tagname\", refs: [inputs | select(length>0)]}" .build/tags/$$tagname.tag > .build/tags/$$tagname.json; \
	        gotemplater -d .build/tags/$$tagname.json layouts/tag.html | \
			    gotemplater -c - layouts/_base.html > out/tags/$$tagname.html; \
	    done

.PHONY: assets
assets:
	cp -r src/static out/

# Main Targets

.PHONY: clean_tags
clean_tags:
	rm -f .build/tags/*

.PHONY: clean_posts
clean_posts: 
	rm -f .build/post/posts


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

.PHONY: all
all: posts assets tags out/index.html
	echo MODE=$(MODE)

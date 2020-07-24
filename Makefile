
PAGES 	  = $(wildcard src/page/*)
PAGES_OUT = $(patsubst src/page/%.md, .out/page/%.html, $(PAGES))

POSTS 	   = $(wildcard src/post/*)
POSTS_REFS = $(patsubst src/post/%.md, %, $(POSTS))

POSTS_OUT = $(patsubst src/post/%.md, .out/post/%.html, $(POSTS))
POSTS_BUILD_MARKDOWN = $(patsubst src/post/%.md, .build/post/%.md, $(POSTS))
POSTS_BUILD_YAML 	 = $(patsubst src/post/%.md, .build/post/%.yaml, $(POSTS))
POSTS_BUILD_HTML 	 = $(patsubst src/post/%.md, .build/post/%.html, $(POSTS))

POSTS_BUILD_TAGS = $(patsubst src/post/%.md, .build/tags/%.tag, $(POSTS))
TAGS_PATH = .build/tags/*.tag

ifeq ($(MODE), dev)
.PRECIOUS: $(POSTS_BUILD_MARKDOWN) $(POSTS_BUILD_YAML) $(POSTS_BUILD_HTML)
endif

###
### Main
###

## Targets

.PHONY: all
all: pages posts assets tags .out/index.html

.PHONY: notags
notags: pages posts assets .out/index.html

## Main target groups

.PHONY: pages
pages: $(PAGES_OUT) 

.PHONY: posts
posts: $(POSTS_OUT) 

.PHONY: assets
assets:
	cp -r src/static .out/

## Output Targets

# Generate pages
.out/page/%.html: src/page/%.html
	gotemplater -c $< layouts/_base.html > $@

# Generate posts
.out/post/%.html: .build/post/%.html .build/post/%.yaml
	gotemplater -f yaml -d .build/post/$*.yaml -c .build/post/$*.html layouts/post.html | \
	    gotemplater -f yaml -d .build/post/$*.yaml -c - layouts/_base.html > $@ 

# Generate homepage
.out/index.html: layouts/index.html .build/posts.json
	gotemplater -d .build/posts.json layouts/index.html | \
	    gotemplater -c - layouts/_base.html > $@

###
### Intermediate targets
###

## Generate Post Archive JSON

.build/posts.json: .build/post/posts
	jq -R '{ posts: [ inputs | fromjson ] }' $< > $@

.build/post/posts: clean_posts $(POSTS_BUILD_YAML)
	for post_ref in $(POSTS_REFS); do	\
	    yq -c ". | .ref = \"$$post_ref\"" .build/post/$$post_ref.yaml >> .build/post/posts; \
	done

.PHONY: clean_posts
clean_posts: 
	rm -f .build/post/posts
	printf "\n" > .build/post/posts

## Extracting data & content from posts and rendering to HTML

# Extract markdown from posts

.build/post/%.md: src/post/%.md
	sed -n -e '1d;/---/,$$p' $< | sed '1d' > $@

# Extract yaml frontmatter from posts

.build/post/%.yaml: src/post/%.md
	sed -n -e '/---/,/---/p' $< | sed '1d;$$d' > $@

# Render the markdown to HTML with pandoc

.build/post/%.html: .build/post/%.md
	pandoc --quiet $< -o $@

###
### Tags
###

# Build tag files from the frontmatter of each post
# TODO: al momento questo non è troppo bll per un makefile, sarebbe meglio trasformarla in una regola PHONY
.build/tags/%.tag: .build/post/%.yaml
	yq -r '.tags[]' $< 2> /dev/null | \
	    while read line; do \
	        echo $* >> .build/tags/$$line.tag; \
	    done

# Generate tag pages

.PHONY: tags
tags: clean_tags $(POSTS_BUILD_TAGS)
	find $(TAGS_PATH) | \
	    xargs basename -s .tag | \
	    while read tagname; do	\
	        jq -nR "{ name: \"$$tagname\", refs: [inputs | select(length>0)]}" .build/tags/$$tagname.tag > .build/tags/$$tagname.json; \
	        gotemplater -d .build/tags/$$tagname.json layouts/tag.html | \
			    gotemplater -c - layouts/_base.html > .out/tags/$$tagname.html; \
	    done

.PHONY: clean_tags
clean_tags:
	rm -f .build/tags/*

###
### Initial Setup / Cleaning
###

.PHONY: clean
clean:
	rm -rf .out/
	rm -rf .build/
	mkdir -p .out
	mkdir -p .out/post
	mkdir -p .out/page
	mkdir -p .out/tags
	mkdir -p .build
	mkdir -p .build/post
	mkdir -p .build/tags

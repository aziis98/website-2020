
OUT = dist
CACHE = .cache

PAGES 	  = $(wildcard src/page/*)
PAGES_OUT = $(patsubst src/page/%.html, $(OUT)/page/%.html, $(PAGES))

POSTS 	   = $(wildcard src/post/*)
POSTS_REFS = $(patsubst src/post/%.md, %, $(POSTS))

POSTS_OUT = $(patsubst src/post/%.md, $(OUT)/post/%.html, $(POSTS))
POSTS_BUILD_MARKDOWN = $(patsubst src/post/%.md, $(CACHE)/post/%.md, $(POSTS))
POSTS_BUILD_YAML 	 = $(patsubst src/post/%.md, $(CACHE)/post/%.yaml, $(POSTS))
POSTS_BUILD_HTML 	 = $(patsubst src/post/%.md, $(CACHE)/post/%.html, $(POSTS))

POSTS_BUILD_TAGS = $(patsubst src/post/%.md, $(CACHE)/tags/%.tag, $(POSTS))
TAGS_PATH = $(CACHE)/tags/*.tag

cc_off=\033[0m
cc_yellow=\033[0;33m

ifeq ($(MODE), dev)
.PRECIOUS: $(POSTS_BUILD_MARKDOWN) $(POSTS_BUILD_YAML) $(POSTS_BUILD_HTML) $(CACHE)/post/posts
endif

###
### Main
###

## Targets

.PHONY: all
all: clean pages posts assets tags $(OUT)/index.html

.PHONY: content
content: pages posts assets $(OUT)/index.html

## Main target groups

.PHONY: pages
pages: $(PAGES_OUT) 

.PHONY: posts
posts: $(POSTS_OUT) 

.PHONY: assets
assets:
	@echo -e "$@:$(cc_yellow) Copying assets$(cc_off)"
	@cp -r src/static $(OUT)/

## Output Targets

# Generate Pages
$(OUT)/page/%.html: src/page/%.html
	@echo -e "$@:$(cc_yellow) Rendering HTML Pages$(cc_off)"
	@gotemplater -c $< layouts/_base.html > $@

# Generate Posts
$(OUT)/post/%.html: $(CACHE)/post/%.html $(CACHE)/post/%.yaml
	@echo -e "$@:$(cc_yellow) Rendering Markdown Posts$(cc_off)"
	@gotemplater -f yaml -d $(CACHE)/post/$*.yaml -c $(CACHE)/post/$*.html layouts/post.html | \
	    gotemplater -f yaml -d $(CACHE)/post/$*.yaml -c - layouts/_base.html > $@

# Generate Homepage
$(OUT)/index.html: layouts/index.html $(CACHE)/posts.json
	@echo -e "$@:$(cc_yellow) Rendering Homepage$(cc_off)"
	@gotemplater -d $(CACHE)/posts.json layouts/index.html | \
	    gotemplater -c - layouts/_base.html > $@

###
### Intermediate targets
###

## Generate Post Archive JSON

$(CACHE)/posts.json: $(CACHE)/post/posts
	@echo -e "$@:$(cc_yellow) Building post json data$(cc_off)"
	@jq -R '{ posts: [ inputs | fromjson ] | map(select(.draft != true)) | sort_by(.date) | reverse }' $< > $@

$(CACHE)/post/posts: clean_posts $(POSTS_BUILD_YAML)
	@echo -e "$@:$(cc_yellow) Building post data$(cc_off)"
	@for post_ref in $(POSTS_REFS); do	\
	    yq -c ". | .ref = \"$$post_ref\"" $(CACHE)/post/$$post_ref.yaml >> $(CACHE)/post/posts; \
	done

.PHONY: clean_posts
clean_posts: 
	rm -f $(CACHE)/post/posts
	printf "\n" > $(CACHE)/post/posts

## Extracting data & content from posts and rendering to HTML

# Extract markdown from posts
$(CACHE)/post/%.md: src/post/%.md
	@echo -e "$@:$(cc_yellow) Extracting markdown content$(cc_off)"
	@awk '/---/ { p++; } p > 3 { print; } /---/ { p++; }' $< > $@

# Extract yaml frontmatter from posts
$(CACHE)/post/%.yaml: src/post/%.md
	@echo -e "$@:$(cc_yellow) Extracting yaml frontmatter$(cc_off)"
	@awk '/---/ { p++; } p == 2 { print; } /---/ { p++; } p>2 { exit; }' $< > $@

# Render the markdown to HTML with pandoc
$(CACHE)/post/%.html: $(CACHE)/post/%.md
	@echo -e "$@:$(cc_yellow) Generating HMTL from post markdown$(cc_off)"
	@pandoc --katex --quiet $< -o $@

###
### Tags
###

# Build tag files from the frontmatter of each post
# TODO: al momento questo non è troppo bll per un makefile, sarebbe meglio trasformarla in una regola PHONY
$(CACHE)/tags/%.tag: $(CACHE)/post/%.yaml
	@echo -e "$@:$(cc_yellow) Retriving tag data from posts$(cc_off)"
	@yq -r '.tags[]' $< 2> /dev/null | \
	    while read line; do \
	        echo $* >> $(CACHE)/tags/$$line.tag; \
	    done

# Generate tag pages

.PHONY: tags
tags: clean_tags $(POSTS_BUILD_TAGS)
	@echo -e "$@:$(cc_yellow) Generating tag pages$(cc_off)"
	@find $(TAGS_PATH) | \
	    xargs basename -s .tag | \
	    while read tagname; do	\
	        jq -nR "{ name: \"$$tagname\", refs: [inputs | select(length>0)]}" $(CACHE)/tags/$$tagname.tag > $(CACHE)/tags/$$tagname.json; \
	        gotemplater -d $(CACHE)/tags/$$tagname.json layouts/tag.html | \
			    gotemplater -c - layouts/_base.html > $(OUT)/tags/$$tagname.html; \
	    done

.PHONY: clean_tags
clean_tags:
	rm -f $(CACHE)/tags/*

###
### Initial Setup / Cleaning
###

.PHONY: clean
clean:
	rm -rf $(OUT)/
	rm -rf $(CACHE)/
	mkdir -p $(OUT)
	mkdir -p $(OUT)/post
	mkdir -p $(OUT)/page
	mkdir -p $(OUT)/tags
	mkdir -p $(CACHE)
	mkdir -p $(CACHE)/post
	mkdir -p $(CACHE)/tags

---
title: New Website
description: New website generated with a Makefile
date: 29 August 2020
tags: 
    - makefile
    - markdown
    - katex
---

This is my new website, the source code is hosted on Github at <https://github.com/aziis98/website-2020>. It is build all using a single (not too long) Makefile by processing all the markdown file using [gotemplater](https://github.com/aziis98/gotemplater) (a cli utility I made, more of this later) and [pandoc](https://pandoc.org/MANUAL.html).

### gotemplater

I made just for this project but I'm probably goint to use it very for this kind of things. 

I use it by piping content in standard input and providing a file to a Go template file and this produces a rendered Go template on standard output (there are also various options for telling were to get input from and where to output to). Still this is just one pretty short Go file.

## Makefile

The complete Makefile can be found [here](https://github.com/aziis98/website-2020/blob/master/Makefile). Now I will try to explain more or less how the generation works.

### Variables

```makefile
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

ifeq ($(MODE), dev)
.PRECIOUS: $(POSTS_BUILD_MARKDOWN) $(POSTS_BUILD_YAML) $(POSTS_BUILD_HTML)
endif
```

### Main Targets

```makefile
.PHONY: all
all: clean pages posts assets tags $(OUT)/index.html

.PHONY: content
content: pages posts assets $(OUT)/index.html

.PHONY: pages
pages: $(PAGES_OUT) 

.PHONY: posts
posts: $(POSTS_OUT) 

.PHONY: assets
assets:
	cp -r src/static $(OUT)/
```

### Output Targets

```makefile
# Generate Pages
$(OUT)/page/%.html: src/page/%.html
	gotemplater -c $< layouts/_base.html > $@

# Generate Posts
$(OUT)/post/%.html: $(CACHE)/post/%.html $(CACHE)/post/%.yaml
	gotemplater -f yaml -d $(CACHE)/post/$*.yaml -c $(CACHE)/post/$*.html layouts/post.html | \
	    gotemplater -f yaml -d $(CACHE)/post/$*.yaml -c - layouts/_base.html > $@

# Generate Homepage
$(OUT)/index.html: layouts/index.html $(CACHE)/posts.json
	gotemplater -d $(CACHE)/posts.json layouts/index.html | \
	    gotemplater -c - layouts/_base.html > $@
```

### Intermediate Targets

```makefile
$(CACHE)/posts.json: $(CACHE)/post/posts
	@jq -R '{ posts: [ inputs | fromjson ] }' $< > $@

$(CACHE)/post/posts: clean_posts $(POSTS_BUILD_YAML)
	@for post_ref in $(POSTS_REFS); do	\
	    yq -c ". | .ref = \"$$post_ref\"" $(CACHE)/post/$$post_ref.yaml >> $(CACHE)/post/posts; \
	done

$(CACHE)/post/%.md: src/post/%.md
	@sed -n -e '1d;/---/,$$p' $< | sed '1d' > $@

# Extract yaml frontmatter from posts
$(CACHE)/post/%.yaml: src/post/%.md
	@sed -n -e '/---/,/---/p' $< | sed '1d;$$d' > $@

# Render the markdown to HTML with pandoc
$(CACHE)/post/%.html: $(CACHE)/post/%.md
	pandoc --katex --quiet $< -o $@
```

### Tag Generation

```makefile
# Build tag files from the frontmatter of each post
# TODO: al momento questo non è troppo bll per un makefile, sarebbe meglio trasformarla in una regola PHONY
$(CACHE)/tags/%.tag: $(CACHE)/post/%.yaml
	@yq -r '.tags[]' $< 2> /dev/null | \
	    while read line; do \
	        echo $* >> $(CACHE)/tags/$$line.tag; \
	    done

# Generate tag pages
.PHONY: tags
tags: clean_tags $(POSTS_BUILD_TAGS)
	@find $(TAGS_PATH) | \
	    xargs basename -s .tag | \
	    while read tagname; do	\
	        jq -nR "{ name: \"$$tagname\", refs: [inputs | select(length>0)]}" $(CACHE)/tags/$$tagname.tag > $(CACHE)/tags/$$tagname.json; \
	        gotemplater -d $(CACHE)/tags/$$tagname.json layouts/tag.html | \
			    gotemplater -c - layouts/_base.html > $(OUT)/tags/$$tagname.html; \
	    done
```

### Cleaning

```makefile
.PHONY: clean_posts
clean_posts: 
	rm -f $(CACHE)/post/posts
	printf "\n" > $(CACHE)/post/posts

.PHONY: clean_tags
clean_tags:
	rm -f $(CACHE)/tags/*

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
```

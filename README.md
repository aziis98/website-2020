# Prototype Blog 3

This time using a good old [Makefile](./Makefile).

## Architecture

### Source files

- [./layouts](./layouts)

    Holds all layouts and templating files.

- [./src](./src)

    All content (posts, pages) and dynamic pages (homepage) are here 

- [./src/post](./src/post)

    Contains all markdown posts, each post is passed thorugh

    ```
    POST |> pandoc |> ./layouts/post.html |>  ./layouts/_base.html
    ```

- [./src/page](./src/page)

    Contains all HTML pages, the base layout is [./layouts/_base.html](./layouts/_base.html).

- [./src/static](./src/static)

    Contains all static files mainly js, css and images.

### Output files

- [.out/](.out/)

    This is the main output directory and holds the complete website.

- `.build/`

    Holds temporary/cached files for incremental builds. 

## Usage

**Dependencies:** `make`, `inotifywait`, `yq`, `jq`, `pandoc`, https://github.com/aziis98/gotemplater, `live-server`, ... (but also: `sed`, ...)

**Commands:**

- `make all`

    Initializes all build directories and build the complete website (with tag pages)

- `make content`

    Just builds posts, pages and assets files for the project

- `devloop <rule>`

    Starts a webserver and passes the args to make each time a file in `src/` or `layouts/` is changed.

## TODO

- Refactor the tag generation rule in the Makefile.
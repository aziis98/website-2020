# My Website (2020)

This time using a good old [Makefile](./Makefile), see the post on <aziis98.com/post/new-website>.

## Architecture

### Source files

- [layouts](./layouts)

    Holds all layouts and templating files (so all dynamic pages).

- [src](./src)

    All content (posts, pages)

- [src/post](./src/post)

    Contains all markdown posts, each post is passed thorugh

    ```
    POST |> pandoc |> ./layouts/post.html |>  ./layouts/_base.html
    ```

- [src/page](./src/page)

    Contains all HTML pages, the base layout is [layouts/_base.html](./layouts/_base.html).

- [src/static](./src/static)

    Contains all static files mainly js, css and images.

### Output files

- [dist/](dist/)

    This is the main output directory and holds the complete website. (This was `.out` before but `live-server` doesn't like folder starting with a "." for live reload)

- `.cache/`

    Holds temporary/cached files for incremental builds. 

## Usage

**Dependencies:** <https://github.com/aziis98/gotemplater>, `make`, `inotifywait`, `awk`, `yq`, `jq`, `pandoc`, `live-server`, ...

**Commands:**

- `make all`

    Initializes all build directories and build the complete website (with tag pages)

- `make content`

    Just builds posts, pages and assets files for the project

- `devloop <rule>`

    Starts a webserver and passes the args to make each time a file in `src/` or `layouts/` is changed.

### Deploys

- <https://poisson.phc.dm.unipi.it/~delucreziis/>: sito personale del dipartimento hostato dal PHC e per ora unico luogo su cui è disponibile il sito. Il deploy è fatto eseguendo sulla macchina in question lo script presente in questo gist <https://gist.github.com/aziis98/6401f86a89275c83e37f6c8388fde5b8>.

## TODO

- Refactor the tag generation rule in the Makefile.
[![Build Status](https://travis-ci.org/lindig/bisect-summary.svg?branch=master)](https://travis-ci.org/lindig/bisect-summary)

# Bisect Summary

This tool reads files produced by OCaml coverage analysis tool
[bisect_ppx] and reports coverage data:

    $ bisect-summary bisect000*
     81.4% [ 131/161 ] # Overall Coverage
    --------------------------------------
     66.7% [  40/60  ] src/coverage.ml
     95.7% [  45/47  ] src/main.ml
     85.2% [  46/54  ] src/scan.ml

It serves a similar purpose than _bisect-ppx-report_ that is part of
[bisect_ppx] but unlike it, it doesn't require access to the source code
and the point files produced by [bisect_ppx] for its analysis. Hence, it
is simpler but also more limited.

# Installation

Bisect Summary is eay to install via Opam:

    $ opam install bisect-summary

If you prefer the latest version, you can pin this repository:

    $ opam pin add bisect-summary https://github.com/lindig/bisect-summary.git

# Building

If you like to work on the code directly without installing it via Opam:

    $ opam install dune
    $ opam install bisect_ppx
    $ dune build @install

# Usage

Call _bisect-summary_ simply with the files produced by [bisect_ppx]:

    $ bisect-summary bisect*.out

# Known Bugs

* There is no manual page.

# License

MIT

[bisect_ppx]:   https://github.com/aantron/bisect_ppx


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

I am planning a release as Opam package. Once this is done, it can be
installed via Opam:

    $ opam install bisect-summary

# Building

    $ opam install oasis
    $ opam install bisect_ppx
    $ make

# Usage

Call _bisect-summary_ simply with the files produced by [bisect_ppx]:

    $ bisect-summary bisect*.out

# Known Bugs

* There is no manual page.

# License

MIT

[bisect_ppx]:   https://github.com/aantron/bisect_ppx


# biblio 0.0.10

### New Freatures

- A new function `doi2bib()` is retrieving references in BibTeX format for
  DOIs.

### Bug Fixes

- Error importing BibTeX files by `read_bib()`.

# biblio 0.0.9

### New Features

- New function `bib2bibentry()` for converting `lib_df` objects into
  `bibentry` objects.
- Coerce methods implemented for `lib_df` objects.

### Improvements

- Improved function `read_bib()` using regular expressions and bibtex lines.

### Bug Fixes

- Function `read_bib()` was not able to read libraries with a single reference.
- Issue regarding some fields without braces (see
  [#34](https://github.com/kamapu/biblio/issues/34)).


# biblio 0.0.7

### New Features

* Function `update()` replaced by `update_data()` in this version.

### Improvements

* Function `compare_df()` is also reporting added and deleted columns.

### Bug Fixes

* Function `detect_keys()` was not detecting bibtexkeys inserted at the
beginning of a text line in the Rmd file. This issue was solved here.

biblio 0.0.4
============

### Bug Fixes

* Use of `tempfile()` to test `write_bib()` and solve issues regarding
  violation of CRAN policies.

biblio 0.0.3
============

### New Features

* Internal data in the object `biblio:::data_bib`.

### Bug Fixes

* Function `read_bib()` was not working properly if the last tag in an entry
  did not ended with a comma. Now it is solved

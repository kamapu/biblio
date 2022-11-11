biblio 0.0.7
============

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

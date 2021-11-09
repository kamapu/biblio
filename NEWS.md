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

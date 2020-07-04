Why `sleep` is used in tests?
=============================

Under normal circumstance a proper ending of the underlying `tee` process
is guaranteed by handling the process closure in `at_exit` block. But
in tests, during the execution there is just no way to synchronise with the
moment when all current input is flushed to the file, therefore the
use of `sleep` is justified in this case.

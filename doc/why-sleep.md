Why `sleep` is used in the code and in tests?
=============================================

`tee` is expected to complete processing of all available (buffered)
data upon SIGTERM signal, but it doesn't do that, there is just no way
to synchronise with the moment when all given input is processed,
therefore the use of `sleep` is justified. It is the weakest spot of
this gem, suggestions are obviously welcome.

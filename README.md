IO::Tee
=======

Copies stdout (or any other IO stream) contents to a file or another stream. Works with subprocesses too.

### Example 1

```ruby
# io-tee-demo.rb
require 'io/tee'

$stdout.tee('output.log')

puts "Hello, world!"
```

`$stdout` is effectively copied into file `output.log` **while still being streamed as a standard output**.

```
$ ruby io-tee-demo.rb
Hello, world!

$ cat output.log
Hello, world!
```


### Example 2

Obviously it works with more than one stream copied into the same file

```ruby
# io-tee-demo.rb
require 'io/tee'

$stdout.tee('full-output.log')
$stderr.tee('full-output.log')

puts 'Hello, world'
$stderr.puts '[DEBUG] Debug info'
```

One can suppress stderr during execution but still get it logged into a file alongside stdout

```
$ ruby io-tee-demo.rb 2> /dev/null
Hello, world

$ cat full-output.log
Hello, world
[DEBUG] Debug info
```

Append or overwrite
-------------------

A keyword argument of `append: false` can be passed to the `IO#tee`
method in order to overwrite the given file upon start of writing.


Sponsored by [Veeqo](https://veeqo.com)

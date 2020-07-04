require 'io/tee/version'

module IO::Tee
  def tee(filename, append: true)
    append_argument = append ? '--append' : ''
    tee_cmd = "tee #{append_argument} #{filename}"

    tee_output, tee_input = IO.pipe
    tee_pid = Process.spawn tee_cmd, in: tee_output, out: self

    reopen(tee_input)

    at_exit do
      sleep 0.05 # see doc/why-sleep.md
      Process.kill('TERM', tee_pid)
      Process.waitpid(tee_pid)
    end
  end
end

IO.class_eval { include IO::Tee }

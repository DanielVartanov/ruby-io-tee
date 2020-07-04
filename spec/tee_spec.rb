require 'tmpdir'
require 'io/wait'

RSpec.describe IO, '#tee' do
  let(:tmpdir) { Dir.mktmpdir }

  let(:filename) { File.join tmpdir, 'output.log' }
  let(:file_contents) { File.read(filename) }

  after { FileUtils.remove_entry tmpdir }

  it 'writes stream contents to the stream itself and to the given file' do
    reader, writer = IO.pipe

    writer.tee(filename)
    writer.puts 'Hello!'

    sleep 0.05 # see doc/why-sleep.md

    expect(reader.read(reader.nread)).to eq "Hello!\n"
    expect(file_contents).to eq "Hello!\n"
  end

  context 'when two streams tee into one file' do
    it 'merges two streams into one file' do
      _, stdout = IO.pipe
      _, stderr = IO.pipe

      stdout.tee(filename)
      stderr.tee(filename)

      stdout.puts 'stdout'
      stderr.puts 'stderr'

      sleep 0.05 # see doc/why-sleep.md

      expect(file_contents).to eq "stdout\nstderr\n"
    end
  end

  context 'when one stream tees into two files' do
    let(:second_filename) { File.join tmpdir, 'second_output.log' }
    let(:second_file_contents) { File.read(second_filename) }

    it 'copies stream to the both files' do
      _, stream = IO.pipe

      stream.tee(filename)
      stream.tee(second_filename)

      stream.puts 'Hello!'

      sleep 0.05 # see doc/why-sleep.md

      expect(file_contents).to eq "Hello!\n"
      expect(second_file_contents).to eq "Hello!\n"
    end
  end

  context 'when a subprocess is writing to the stream' do
    it 'works just as if the main process writes to the stream (a proof that the job is not done by monkeypatching)' do
      reader, writer = IO.pipe

      writer.tee(filename)

      pid = Process.spawn('echo Hello!', out: writer)
      Process.wait pid

      sleep 0.05 # see doc/why-sleep.md

      expect(reader.read(reader.nread)).to eq "Hello!\n"
      expect(file_contents).to eq "Hello!\n"
    end
  end

  context 'when `append: false` is passed' do
    it 'rewrites the given file' do
      File.write(filename, 'Multiple hello\'s from previous streams')

      _, stream = IO.pipe
      stream.tee(filename, append: false)
      stream.puts 'Hello from the last stream only!'
      sleep 0.05 # see doc/why-sleep.md

      expect(file_contents).to eq "Hello from the last stream only!\n"
    end
  end
end

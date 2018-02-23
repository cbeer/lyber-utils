require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'lyber-utils'

describe LyberUtils::FileUtilities do

  describe "pair_tree_from_barcode" do
    it "should return a directory path derived from a barcode" do
      expect(LyberUtils::FileUtilities.pair_tree_from_barcode('361051234567890')).to eq('36105/12/34/56/')
      expect(LyberUtils::FileUtilities.pair_tree_from_barcode('9991234567890')).to eq('999/12/34/56/')
    end
  end

  describe "execute" do
    it "should successfully execute a command" do
      command = "my command"
      status = double('status', exitstatus: 0)
      expect(LyberUtils::FileUtilities).to receive(:systemu).with(command).and_return([status,"some stdout",""])
      expect(LyberUtils::FileUtilities.execute(command)).to eq("some stdout")
    end

    it "should raise error if status non-zero" do
      command = "my command"
      status = double('status', exitstatus: -1)
      expect(LyberUtils::FileUtilities).to receive(:systemu).with(command).and_return([status,"",""])
      expect { LyberUtils::FileUtilities.execute(command) }.to raise_error(/Command failed to execute/)
    end

    it "should return an error message that includes info from stderr and stdout" do
      command = "ls /foobar"
      status = double('status', exitstatus: -1)
      expect(LyberUtils::FileUtilities).to receive(:systemu).with(command).and_return([status,"","ls: /foobar: No such file or directory"])
      expect { LyberUtils::FileUtilities.execute(command) }.to raise_error(RuntimeError, 'Command failed to execute: [ls /foobar] caused by <STDERR = ls: /foobar: No such file or directory>')
    end

  end

  describe "transfer_object" do
    it "should successfully rsync transfer a file" do
      filename = 'myfile'
      source_dir = "sdir"
      dest_dir = "ddir"
      expect(LyberUtils::FileUtilities).to receive(:execute).with("rsync -a -e ssh 'sdir/myfile' ddir").and_return("")
      expect(File).to receive(:exists?).with(File.join(dest_dir, filename)).and_return(true)
      expect(LyberUtils::FileUtilities.transfer_object(filename, source_dir, dest_dir)).to eq(true)
    end
  end

  describe "gpgdecrypt" do
    it "should successfully decrypt a file" do
      workspace_dir = "mydir"
      targzgpg = "gpgfile"
      targz = "targzfile"
      passphrase = "pp"
      gpg_cmd = "/usr/bin/gpg --passphrase 'pp'  --batch --no-mdc-warning --no-secmem-warning  --output mydir/targzfile --decrypt mydir/gpgfile"
      expect(LyberUtils::FileUtilities).to receive(:execute).with(gpg_cmd).and_return("")
      expect(File).to receive(:exists?).with(File.join(workspace_dir, targz)).and_return(true)
      expect(LyberUtils::FileUtilities.gpgdecrypt(workspace_dir, targzgpg, targz, passphrase)).to eq(true)
    end
  end

  describe "unpack" do
    it "should successfully unpack a file" do
      original_dir = "mydir"
      targz = "targzfile"
      destination_dir = "destdir"
      unpack_cmd = "tar -xzf mydir/targzfile"
      mock_array = double("array")
      dir_save = Dir.pwd
      expect(FileUtils).to receive(:mkdir_p).with(destination_dir)
      expect(Dir).to receive(:chdir).with(destination_dir)
      expect(LyberUtils::FileUtilities).to receive(:execute).with(unpack_cmd).and_return("")
      expect(Dir).to receive(:entries).with(destination_dir).and_return(mock_array)
      expect(mock_array).to receive(:length).and_return(10)
      expect(Dir).to receive(:chdir).with(dir_save)
      expect(LyberUtils::FileUtilities.unpack(original_dir, targz, destination_dir)).to eq(true)
    end
  end
end

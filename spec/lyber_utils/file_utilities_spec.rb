require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'lyber-utils'

describe LyberUtils::FileUtilities do

  describe "pair_tree_from_barcode" do
    it "should return a directory path derived from a barcode" do
      LyberUtils::FileUtilities.pair_tree_from_barcode('361051234567890').should == '36105/12/34/56/'
      LyberUtils::FileUtilities.pair_tree_from_barcode('9991234567890').should == '999/12/34/56/'
    end
  end

  describe "execute" do
    it "should successfully execute a command" do
      command = "my command"
      status = $?
      LyberUtils::FileUtilities.should_receive(:systemu).with(command).and_return([status,"some stdout",""])
      LyberUtils::FileUtilities.execute(command).should == "some stdout"
    end
    
    it "should raise error if status non-zero" do
      command = "my command"
      status = $?
      LyberUtils::FileUtilities.should_receive(:systemu).with(command).and_return([status,"",""])
      status.should_receive(:exitstatus).and_return(-1)
      lambda {LyberUtils::FileUtilities.execute(command)}.should raise_error
    end
    
    it "should return an error message that includes info from stderr and stdout" do
      command = "ls /foobar"
      lambda {LyberUtils::FileUtilities.execute(command)}.should
        raise_error(RuntimeError, 'Command failed to execute: [ls /foobar] caused by <STDERR = ls: /foobar: No such file or directory>')
    end
    
  end

  describe "transfer_object" do
    it "should successfully rsync transfer a file" do
      filename = 'myfile'
      source_dir = "sdir"
      dest_dir = "ddir"
      LyberUtils::FileUtilities.should_receive(:execute).with("rsync -a -e ssh 'sdir/myfile' ddir").and_return("")
      File.should_receive(:exists?).with(File.join(dest_dir, filename)).and_return(true)
      LyberUtils::FileUtilities.transfer_object(filename, source_dir, dest_dir).should == true
    end
  end

  describe "gpgdecrypt" do
    it "should successfully decrypt a file" do
      workspace_dir = "mydir"
      targzgpg = "gpgfile"
      targz = "targzfile"
      passphrase = "pp"
      gpg_cmd = "/usr/bin/gpg --passphrase 'pp'  --batch --no-mdc-warning --no-secmem-warning  --output mydir/targzfile --decrypt mydir/gpgfile"
      LyberUtils::FileUtilities.should_receive(:execute).with(gpg_cmd).and_return("")
      File.should_receive(:exists?).with(File.join(workspace_dir, targz)).and_return(true)
      LyberUtils::FileUtilities.gpgdecrypt(workspace_dir, targzgpg, targz, passphrase).should == true
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
      FileUtils.should_receive(:mkdir_p).with(destination_dir)
      Dir.should_receive(:chdir).with(destination_dir)
      LyberUtils::FileUtilities.should_receive(:execute).with(unpack_cmd).and_return("")
      Dir.should_receive(:entries).with(destination_dir).and_return(mock_array)
      mock_array.should_receive(:length).and_return(10)
      Dir.should_receive(:chdir).with(dir_save)
      LyberUtils::FileUtilities.unpack(original_dir, targz, destination_dir).should == true
    end
  end


end

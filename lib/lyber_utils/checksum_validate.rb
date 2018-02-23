require 'nokogiri'

module LyberUtils
  class ChecksumValidate

    # Test the equality of two hashes
    # @return [Boolean]
    def self.compare_hashes(hash1, hash2)
      hash1 == hash2
    end

    # create a new hash containing:
    # entries from hash1 where:
    # * key is in hash1 but missing from hash2
    # * value is different in the two hashes
    # entries from hash2 where:
    # * key is in hash2 but missing from hash1
    # @return [Hash]
    def self.get_hash_differences(hash1, hash2)
      hash1.reject { |k, v| hash2[k] == v }.merge!(hash2.reject { |k, _v| hash1.has_key?(k) })
    end

    # Generate a filename => checksum hash
    # from an output of the md5sum (or compatible) program
    # @return [Hash]
    def self.md5_hash_from_md5sum(md5sum)
      checksum_hash = {}
      md5sum.each_line do |line|
        line.chomp!
        digest, filename = line.split(/[ *]{2}/)
        checksum_hash[filename] = digest.downcase
      end
      checksum_hash
    end

    # Generate a filename => checksum hash
    # from the contents of a METS file
    # @return [Hash]
    def self.md5_hash_from_mets(mets)
      mets_checksum_hash = {}
      doc = Nokogiri::XML(mets)
      doc.xpath('/mets:mets/mets:fileSec//mets:file', {'mets' => 'http://www.loc.gov/METS/'}).each do |filenode|
        digest = filenode.attribute('CHECKSUM')
        if digest
          flocat = filenode.xpath('mets:FLocat', {'mets' => 'http://www.loc.gov/METS/'}).first
          if flocat
            filename = flocat.attribute_with_ns('href', 'http://www.w3.org/1999/xlink')
            if filename
              mets_checksum_hash[filename.text] = digest.text.downcase
            end
          end
        end
      end
      mets_checksum_hash
    end

    # Generate a filename => checksum hash
    # from contentMetadata XML
    # @return [Hash]
    def self.md5_hash_from_content_metadata(content_md)
      content_md_checksum_hash = {}
      doc = Nokogiri::XML(content_md)
      doc.xpath('/contentMetadata/resource[@type="page"]/file').each do |filenode|
        filename = filenode.attribute('id')
        if filename
          md5_element = filenode.xpath('checksum[@type="MD5"]').first
          if md5_element
            digest = md5_element.text
            if digest
              content_md_checksum_hash[filename.text] = digest.downcase
            end
          end
        end
      end
      content_md_checksum_hash
    end

    # Verifies MD5 checksums for the files in a directory
    # against the checksum values in the supplied file
    # (Uses md5sum command)
    #
    # = Inputs:
    # * directory = dirname containing the file to be checked
    # * checksum_file = the name of the file containing the expected checksums
    #
    # = Return value:
    # * The method will return true if the verification is successful.
    # * The method will raise an exception if either the md5sum command fails,
    # or a test of the md5sum output indicates a checksum mismatch.
    # The exception's message will contain the explaination of the failure.
    def self.verify_md5sum_checksums(directory, checksum_file)
      # LyberCore::Log.debug("verifying checksums in #{directory}")
      orig_dir = Dir.pwd
      Dir.chdir(directory)
      checksum_cmd = "md5sum -c #{checksum_file} | grep -v OK | wc -l"
      errcount = FileUtilities.execute(checksum_cmd).to_i
      raise "#{badcount} files had bad checksums" unless errcount == 0
      true
    ensure
      Dir.chdir(orig_dir)
    end
  end
end

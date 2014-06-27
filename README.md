# lyber_utils

Require the following:
  ```ruby
  require 'lyber_utils'
  ```

This will give you:
  LyberUtils::BagitBag
  LyberUtils::ChecksumValidate
  LyberUtils::FileUtilities

If you do not want all 3, you can require the individual classes.  I.E. if you only want the bagit utils, then require:
  ```ruby
  require 'lyber_utils/bagit_bag'
  ```

The BagitBag class requires the [bagit gem](http://github.com/flazz/bagit)

## Releases
- <b>0.1.3</b> Started to use Dor::Config for workspace configuration
- <b>0.1.1</b> Update dependent version of nokogiri for more flexibility
- <b>0.1.2</b> Ensure bag begins with an empty directory.  Disallow nil values in bag-info.txt properties

## Copyright

Copyright (c) 2011 Stanford University Library. See LICENSE for details.

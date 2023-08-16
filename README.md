
# OpenTimelineIO Swift Bindings

This project provides idiomatic Swift bindings for the open source OpenTimelineIO
library.

## Prerequisites

Xcode 12.3 is the minimum Xcode requirement in order to get a version of the
Swift Package Manager that supports hybrid C++/Swift builds.

## CLI Swift Package Manager Example
====================================

If you copy/download `examples/swift-package-manager` (`examples` is a top-level folder of this repository)
you can play around with some simple CLI samples that show off building with SPM.

For example, put a copy of `examples/swift-package-manager` in /home/some-user, and then:

Then:
```
    $ cd /home/some-user/swift-package-manager
    $ swift build
    (output)

    $ .build/debug/cxx_opentime_example
    (output)

    $ .build/debug/cxx_example
    (output)

    $ .build/debug/swift_example
    (output)
```
    
## OpenTimelineIO Swift Test Suite
==================================

You can also build and test the Swift OpenTimelineIO module
(which requires building the C++ core library, but does not involve Python or any other language)
from the command line easily as well:
```
    $ git clone --recurse-submodules https://github.com/OpenTimelineIO/OpenTimelineIO-Swift-Bindings.git
    ...

    $ cd OpenTimelineIO-Swift-Bindings
    $ swift build
    ...

    $ swift test
    ...
    Test Suite 'testTransform' passed at 2020-12-13 09:54:49.488.
	    Executed 5 tests, with 0 failures (0 unexpected) in 0.001 (0.001) seconds
    Test Suite 'OpenTimelineIOPackageTests.xctest' passed at 2020-12-13 09:54:49.488.
            Executed 57 tests, with 0 failures (0 unexpected) in 1.690 (1.692) seconds
    Test Suite 'All tests' passed at 2020-12-13 09:54:49.488.
            Executed 57 tests, with 0 failures (0 unexpected) in 1.690 (1.693) seconds
```	     
	 
## Use within Xcode
====================

Use the Package Manager in Xcode and bring in
  `https://github.com/OpenTimelineIO/OpenTimelineIO-Swift-Bindings.git`

You should see a choice of two C++ products that can be added to your workspace;
for Swift development, choose the third product named `OpenTimelineIO`.

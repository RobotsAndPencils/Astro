# Astro
===========

Astro is a library, built in swift, used to hold common utility methods. It was built as an eventual replacement for RoboKit.

## Requirements

- iOS 8.0+
- Xcode 7

## Installation

####CocoaPods (iOS 8+)
To integrate `Astro` into your Xcode project using [Cocoapods](http://cocoapods.org/), specify it in your `Podfile`:

```ruby
source 'git@github.com:RobotsAndPencils/RNPPrivateSpecs.git'
platform :ios, '8.0'
use_frameworks!

pod 'Astro'
```

Or if you don't want the whole enchilada then grab one of the subspecs:

```
pod 'Astro/UI'
pod 'Astro/Networking'
```

## Subspec Management
As the library matures, more classes will be introduced to the project and it would be nice to keep it from
becoming a mish-mash of things. One of the ways we intend to do this is to cluster the code in directories 
by functionality using pod subspecs. That way if a project just needs one or two things they can grab that 
subset easily.

So if you want to add some classes in, think about the existing subspecs and decide if it belongs with one
or if it should have a new home. If you don't know then please ask.

For now the library has the following subspecs:

- UI : Common UIKit extensions
- Networking : HTTPStatusCodes and hopefully more
- Logging (coming soon) : A super-licious logging framework by MB

## Contact

[![Robots & Pencils Logo](http://f.cl.ly/items/2W3n1r2R0j2p2b3n3j3c/rnplogo.png)](http://www.robotsandpencils.com)

Follow Robots & Pencils on Twitter ([@robotsNpencils](https://twitter.com/robotsNpencils))

### Maintainers

- [Chad Sykes](http://github.com/csykes)
- [Dominic Pepin](http://github.com/dompepin) 

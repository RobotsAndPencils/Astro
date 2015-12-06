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
pod 'Astro/Logging'
pod 'Astro/Networking'
pod 'Astro/Security'
pod 'Astro/UI'
```

## Modules

### Logging

`Log` is a structure that streamlines the printing of log messages.

Out of the box, you will be able to log error messages.
```swift
Log.error("I want to log an error message with \(something)")
```

However, if you want to see more information you can override the logging level as you wish. For example:
```swift
#if DEBUG
  Log.level = .Debug
#else
  Log.level = .Silent
#endif

Log.info("I want to log an info message with \(something)")
Log.debug("I want to log a debug message with \(somethingElse)")
Log.warning("I want to log a warning message with \(somethingOtherThanElse)")
```

You can also write a custom logger as long as it conforms to the `Logger` protocol.
```
Log.logger = MyCustomLogger()
```

### Networking

`HTTPStatusCode` is an enum that allows you to clarify status codes returned by your server.

### Security

`KeychainAccess` provides secure access to the Keychain. It is based on previously security audited code at Robots & Pencils and is preferred over 3rd party libraries.

Usage is fairly straightforward, as part of an account, you can place strings (or data) for a key into the Keychain and then recover those values later. This makes it a good way to securely store a specific user's password or tokens for reuse in the app. For more details on what else you can store, check out the KeychainAccessSpec.swift file.

```
// Instantiate the keychain access using a unique account identifier to house your key/values
let keychain = KeychainAccess(account: "FredDarling@RobotsAndPencils.com")  

// Store a login token
var loginTokenID = "LoginToken"
let loginTokenValue = "SomeSuperSecretValueAboutACat"
keychain.putString(testKey, value: loginTokenID)

// And pull it back for later use
let loginToken = keychain.getString(loginTokenID)

```

### UI

Contains a few UI extensions to help you write cleaner code.

## Module Management

As the library matures, more classes will be introduced to the project and it would be nice to keep it from
becoming a mish-mash of things. One of the ways we intend to do this is to cluster the code in directories
by functionality using pod subspecs for these modules. That way if a project just needs one or two things they can grab that
subset easily.

So if you want to add some classes in, think about the existing modules and decide if it belongs with one
or if it should have a new home. If you don't know then please ask.

## Deploy new release to our private CocoaPods repository

Here is the cookbook to generate a new version of the pod and get it published into our [private CocoaPods repository](https://github.com/RobotsAndPencils/RNPPrivateSpecs)

- update version # in Astro.podspec
- update version # in Astro/Info.plist (or via xcode project view)
- run `pod install` (to ensure all the local podfiles get update)
- run `pod lib lint Astro.podspec` (to make sure there aren't any errors)
- push that code back up to your release branch in github
- after reviewing/merging back into master then you’ll need to create/tag the release
- run `pod repo push RNPPrivateSpecs Astro.podspec` (finally pushes the updated pod to our private repository)

## Contact

[![Robots & Pencils Logo](http://f.cl.ly/items/2W3n1r2R0j2p2b3n3j3c/rnplogo.png)](http://www.robotsandpencils.com)

Follow Robots & Pencils on Twitter ([@robotsNpencils](https://twitter.com/robotsNpencils))

### Maintainers

- [Chad Sykes](http://github.com/csykes)
- [Dominic Pepin](http://github.com/dompepin) 
- [Michael Beauregard](http://github.com/mjbeauregard) 

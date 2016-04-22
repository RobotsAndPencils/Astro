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

```ruby
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
```swift
Log.logger = MyCustomLogger()
```

### Networking

#### HTTPStatusCode
`HTTPStatusCode` is an enum that allows you to clarify status codes returned by your server.
`HTTPStatusCode+FriendlyMessaging` adds some more user friendly failureReason and recoverSuggestions options to `HTTPStatusCode`

#### Route
`Route` provides a simple abstraction for working with `NSURLRequests`. Recommended approach is to add extensions to `Route` to add a default `baseURL` value and static functions for your specific API.

```swift
extension Route {
    public init(path: String, method: Alamofire.Method = .GET, JSON: Freddy.JSON, additionalHeaders: [String: String] = [:]) {
        self.init(baseURL: NSURL(string: "https://myapp.com/api/v1/")!, path: path, method: method, parameters: RequestParameters.JSON(parameters: JSON), additionalHeaders: additionalHeaders)
    }
    
    static func login(username username: String, password: String) -> Route {
        return Route(path: "token", method: .POST, JSON: ["username": username, "password": password].toJSON())
    }
}
```

#### NetworkService
`NetworkService` brings in AlamoFire, Freddy, and SwiftTask in order to provide a simple networking layer that creates `Task`'s capable of performing network requests, decoding JSON, and mapping the JSON into model objects. Here is an example of a login call where `AuthToken` is a swift struct conforming to `JSONDecodable` (from Freddy):

```swift
self.networkService.request(Route.login(username: username, password: password)).success { (loginResponse: ResponseValue<AuthToken>) in
	let networkResponse = loginResponse.response
    let authToken = loginResponse.value // on success we directly get our model object(s)
    // Do something with autoToken and/or networkResponse...
}.failure { errorInfo in
    let networkResponse = errorInfo.error?.response
    let error = errorInfo.error?.error
    // Again, you have access to the error and the network response.     
}
```

When testing the rest of your app you will want to stub the network layer. The recommended approach is to use the `Nocilla` library and add the follwing convienences (I tried to put these into a subspec [but failed](https://github.com/CocoaPods/CocoaPods/issues/5191)):

```swift
// Improved DSL for Nocilla

func stubRoute(route: Route) -> LSStubRequestDSL {
    return stubRequest(route.method.rawValue, route.URL.absoluteString).withHeaders(route.URLRequest.allHTTPHeaderFields).withBody(route.URLRequest.HTTPBody)
}

extension LSStubRequestDSL {
    func andReturn(status: HTTPStatusCode) -> LSStubResponseDSL {
        return andReturn(status.rawValue)
    }
}

extension LSStubResponseDSL {
    func withJSON(json: JSON) -> LSStubResponseDSL {
        let body = try? json.serialize() ?? NSData()
        return withHeader("Content-Type", "application/json").withBody(body)
    }
}

func stubAnyRequest() -> LSStubRequestDSL {
    return stubRequest(nil, ".*".regex())
}
```

Now you can easily stub your login `Route` like this:

```swift
stubRoute(Route.login(username: "user", password: "pass")).andReturn(.Code200OK).withJSON(["token": "[TOKEN]"])
```

### Security

`KeychainAccess` provides the app access to a device's Keychain store. Usage is fairly straightforward, as part of an account, you can place strings (or data) for a key into the Keychain and then recover those values later. This makes it a good way to securely store a specific user's password or tokens for reuse in the app. For more details on what else you can store, check out the KeychainAccessSpec.swift file.

```swift
// Instantiate the keychain access using a unique account identifier to house your key/values
let keychain = KeychainAccess(account: "FredDarling@RobotsAndPencils.com")  

// Store a login token
var loginTokenID = "LoginToken"
let loginTokenValue = "SomeSuperSecretValueAboutACat"
keychain.putString(testKey, value: loginTokenID)

// And pull it back for later use
let loginToken = keychain.getString(loginTokenID)

```

NOTES: 
- KeychainAccess is based on previously security audited code at Robots & Pencils and is preferred over 3rd party libraries that we don't control the source code to
- It is a simple keychain store library and doesn't include any fancy integration with iCloud or TouchID

### UI

Includes a UIColor extension for hex code (e.g. `#FF0000`) support. You can now create your project's color palette in another class extension that brings all those pesky colors into one place and with names that are easy to understand:

```swift
private static let _FF9000 = UIColor(hexString: "#FF9000")
public static func MyApp_BrightOrangeColor() -> UIColor {
    return _FF9000
}
```

In your app's implementation you you can then quickly make use of those colors:

```swift
let color = UIColor.MyApp_BrightOrangeColor()
```
### Utils
#### EnumCountable
`EnumCountable` provides an easy way to add a static `count` constant to Swift enums of type Int.  

It requires that the first case start at 0 and all cases must be continuous.

Example:

```swift
class SettingsViewController : UICollectionViewController {
enum Section: Int, EnumCountable {
    case Customizations = 0
    case Faqs
    case Support
    case Logout
 
    static let count = Settings.countCases()  
}
...
override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return Section.count
    }
}
```

#### Queue
`Queue` provides a prettier interface for dispatching onto different GCD Queues.

```swift
Queue.Background.execute {
    // Do some work...
    Queue.Main.executeAfter(delay: 1) {
        // Back on main thread
    }
}
```
    
    
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

# Astro

Astro is a library, built in swift, used to hold common utility methods.

[![CircleCI](https://circleci.com/gh/RobotsAndPencils/Astro.svg?style=svg)](https://circleci.com/gh/RobotsAndPencils/Astro)

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Requirements](#requirements)
- [Installation](#installation)
    - [CocoaPods (iOS 8+)](#cocoapods-ios-8)
- [Modules](#modules)
  - [Logging](#logging)
  - [Security](#security)
  - [UI](#ui)
    - [UIColor Extension](#uicolor-extension)
    - [IdentifiableType Protocols](#identifiabletype-protocols)
      - [IdentifiableType](#identifiabletype)
      - [ReusableView](#reusableview)
      - [ReusableCell](#reusablecell)
      - [NibLoadableView](#nibloadableview)
      - [ReusableCell + NibLoadableView in Tandem](#reusablecell--nibloadableview-in-tandem)
  - [Utils](#utils)
    - [EnumCountable](#enumcountable)
    - [Queue](#queue)
    - [Change](#change)
- [Module Management](#module-management)
- [Contact](#contact)
  - [Maintainers](#maintainers)
- [License](#license)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Requirements

- iOS 8.0+
- Xcode 7

## Installation

#### CocoaPods (iOS 8+)
To integrate `Astro` into your Xcode project using [Cocoapods](http://cocoapods.org/), specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'Astro'
```

Or if you don't want the whole enchilada then grab one of the subspecs:

```ruby
pod 'Astro/Logging'
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

### Security

`KeychainAccess` provides the app access to a device's Keychain store. Usage is fairly straightforward, as part of an account, you can place strings (or data) for a key into the Keychain and then recover those values later. This makes it a good way to securely store a specific user's password or tokens for reuse in the app. For more details on what else you can store, check out the KeychainAccessSpec.swift file.

```swift
// Instantiate the keychain access using a unique account identifier to house your key/values
let keychain = KeychainAccess(account: "user@example.com")  

// Store a login token
var loginTokenID = "LoginToken"
let loginTokenValue = "SomeSuperSecretValueAboutACat"
keychain.putString(testKey, value: loginTokenID)

// And pull it back for later use
let loginToken = keychain.getString(loginTokenID)

```

NOTES:
- It is a simple keychain store library and doesn't include any fancy integration with iCloud or TouchID

### UI
#### UIColor Extension
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

#### IdentifiableType Protocols

In many iOS apps, it is common to need a type identifier to instantiate views, register instances for reuse or dequeue cells. To assist with this and avoid having to define identifiers manually, a number of protocols are included in Astro/UI.

##### IdentifiableType

Provides a static `identifier` value that defaults to the type name. UIViewController conforms to this automatically, and this can be used when instantiating from a storyboard.

```swift
class AstroViewController: UIViewController {}

let vc = Storyboard.main.instantiateView(ofType: AstroViewController.self)
```

##### ReusableView

[`ReusableView`](Astro/UI/ReusableView.swift) has a `reuseIdentifier`, which defaults to the type's identifier, or type name. This can be overridden if needed by having conforming types provide their own implementation. MKAnnotationView conforms to this automatically, and this can be used when instantiating with a MKMapView.

```swift
class AstroAnnotationView: MKAnnotationView {
  // ...
}

mapView.registerView(ofType: AstroAnnotationView.self)
mapView.dequeueReusableAnnotationView(ofType: AstroAnnotationView.self, for: annotation)
```

##### ReusableCell

Like ReusableView but for cell types :smile:. There are currently no further requirements of types that conform to this protocol, but extensions on UITableView and UICollectionView require ReusableCells.

```swift
class AstroTableViewCell: UITableViewCell, ReusableView {
  // ...
}

class AstroTableViewController: UITableViewController {
  // ...
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    return tableView.dequeueReusableCell(ofType: AstroTableViewCell.self, for: indexPath)
  }
  // ...
}
```

##### NibLoadableView

[`NibLoadableView`](Astro/UI/NibLoadableView.swift) has a `nibName`, which should be the NIB filename and defaults to the type's name.

```swift
class AstroView: NibLoadableView {
  // ...
}

class AstroViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    let astroNibName = AstroView.nibName // "AstroView"
  }
}
```

Why bother with this `NibLoadableView` though, you ask? Watch how it combines with `ReusableView`, and some nifty extensions to reduce more boilerplate...

##### ReusableCell + NibLoadableView in Tandem

As alluded to, there are `UITableView` and `UICollectionView` extensions that make use of `ReusableCell` and `NibLoadableView` for really easy cell registration and dequeueing.

The register method can take in a cell subclass that adheres to only `ReusableCell`, or both `ReusableCell` and `NibLoadableView`. After the cell is registered, the provided dequeue method can be used in the necessary delegate method which allows you to stick with just using types to reference our views, and get back the specific view type we just dequeued:

```swift
class BookCell: UICollectionViewCell, ReusableView, NibLoadableView {
  // ...
}

class BookListViewController: UIViewController, UICollectionViewDataSource {
    @IBOutlet private weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(BookCell.self)
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: BookCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        return cell
    }
}
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
 
    static let count = Section.countCases()  
}
...
override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return Section.count
    }
}
```

#### Queue
`Queue` provides a prettier interface for the most common needs of dispatching onto different GCD Queues. If you require something more powerful consider [Async](https://github.com/duemunk/Async).

```swift
Queue.Background.execute {
    // Do some work...
    Queue.Main.executeAfter(delay: 1) {
        // Back on main thread
    }
}
```

#### Change

`Change<Value>` encapsulates a change between two values of the same type

Sometimes you need the old and new values of a property in order to perform efficient or pleasing changes elsewhere, like in your UI. This type makes that simpler by allowing you to pass a single value around. It's then possible to get sub-changes with the `change[at: \.value]` subscript.

```
var model: ViewModel {
    didSet {
        let change = Change(old: oldValue, new: model)
        updateUI(with: change)
    }
}

func updateUI(with change: Change<Model>) {
    title = change.new.title
    updateSomeSubview(with: change[at: \.subviewState])
    // ...
}

func updateSomeSubview(with change: Change<SubviewState>) {
    guard change.isDifferent else { return }
    // ...
}
```
    
## Module Management

As the library matures, more classes will be introduced to the project and it would be nice to keep it from
becoming a mish-mash of things. One of the ways we intend to do this is to cluster the code in directories
by functionality using pod subspecs for these modules. That way if a project just needs one or two things they can grab that
subset easily.

So if you want to add some classes in, think about the existing modules and decide if it belongs with one
or if it should have a new home. If you don't know then please ask.

Finally, if you have been tasked with helping maintain this library you can check out the [CocoaPods Admin page](Documentation/CocoaPodsAdmin.md) for more details 

## Contact

[![Robots & Pencils Logo](http://f.cl.ly/items/2W3n1r2R0j2p2b3n3j3c/rnplogo.png)](http://www.robotsandpencils.com)

Made with ❤  by Robots & Pencils ([@robotsNpencils](https://twitter.com/robotsNpencils))

### Maintainers

- [Chad Sykes](http://github.com/csykes)
- [Dominic Pepin](http://github.com/dompepin) 
- [Michael Beauregard](http://github.com/mjbeauregard) 

## License

Astro is available under the MIT license. See the LICENSE file for more info.

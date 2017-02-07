# Astro

Astro is a library, built in swift, used to hold common utility methods.

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
    - [Reusable Cell Protocols](#reusable-cell-protocols)
      - [ReusableView](#reusableview)
      - [NibLoadableView](#nibloadableview)
      - [ReusableView + NibLoadableView in Tandem](#reusableview--nibloadableview-in-tandem)
  - [Utils](#utils)
    - [EnumCountable](#enumcountable)
    - [Queue](#queue)
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
#### Reusable Cell Protocols
In many iOS apps, it is common to dequeue table or collection view cells. To assist with this and avoid having to define identifiers for each type of cell, a number of protocols are included in Astro/UI.

##### ReusableView
The [`ReusableView`](Astro/UI/ReusableView.swift) protocol requires that a `defaultReuseIdentifier` string be defined for any objects that wish to adhere to it. To make adoption of this protocol easier, a default implementation is provided for any `UIView` subclasses (namely, `UITableViewCell` and `UICollectionViewCell`). The default implementation will provide the name of the class as the reuse identifier, so as long as you define the reuse identifier for your prototype cells in IB the same as the name of the class, you should be good to go:

```swift
class AstroTableViewCell: UITableViewCell, ReusableView {
  // ...
}

class AstroTableViewController: UITableViewController {
  // ...
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let astroCellIdentifier = AstroTableViewCell.defaultReuseIdentifier // "AstroTableViewCell"
    let cell = tableView.dequeueReusableCellWithIdentifier(astroCellIdentifier, forIndexPath: indexPath)
    return cell
  }
  // ...
}
```

One other trick you can do to make it so that all your cell subclasses are a `ReusableView` and have a `defaultReuseIdentifier`, you can apply an extension like below for your project:

```swift
extension UICollectionViewCell: ReusableView {}
```

It should also be noted that if you wish to customize the identifier, you can always override the implementation of `defaultReuseIdentifier` in your view subclass.

##### NibLoadableView
The [`NibLoadableView`](Astro/UI/NibLoadableView.swift) protocol, like `ReusableView`, requires that a string, `nibName`, be defined for objects that wish to adhere to it. Since the use of nibs is similar to how cells are referenced and dequeued for table/collection views, a default implementation is provided for this protocol too, which returns the class' name for the name of the nib (meaning that you should name your nib files the same as the view subclasses you implement them in). 

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

##### ReusableView + NibLoadableView in Tandem
As alluded to, there are `UITableView` and `UICollectionView` extensions that make use of `ReusableView` and `NibLoadableView` for really easy cell registration and dequeueing. Below is the extension for `UICollectionView`:

```swift
public extension UICollectionView {
    public func register<T: UICollectionViewCell where T: ReusableView>(cellType: T.Type) {
        registerClass(cellType.self, forCellWithReuseIdentifier: cellType.defaultReuseIdentifier)
    }
    
    public func register<T: UICollectionViewCell where T: ReusableView, T: NibLoadableView>(cellType: T.Type) {
        let bundle = NSBundle(forClass: cellType.self)
        let nib = UINib(nibName: cellType.nibName, bundle: bundle)
        registerNib(nib, forCellWithReuseIdentifier: cellType.defaultReuseIdentifier)
    }
    
    public func dequeueReusableCell<T: UICollectionViewCell where T: ReusableView>(forIndexPath indexPath: NSIndexPath) -> T {
        guard let cell = dequeueReusableCellWithReuseIdentifier(T.defaultReuseIdentifier, forIndexPath: indexPath) as? T else {
            fatalError("Could not dequeue collection view cell with identifier: \(T.defaultReuseIdentifier)")
        }
        return cell
    }
}
```

The register method can take in a cell subclass that adheres to only `ReusableView`, or both `ReusableView` and `NibLoadableView`. After the cell is registered, the provided dequeue method can be used in the necessary delegate method which allows you to stick with just using types to reference our views, and get back the specific view type we just dequeued:

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

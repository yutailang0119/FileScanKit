# FileScanKit

<p align="left">
<a href="https://developer.apple.com/swift"><img alt="Swift 5.3" src="https://img.shields.io/badge/Swift-5.3-orange.svg?style=flat"/></a>
<a href="https://swift.org/package-manager/"><img alt="Swift Package Manager" src="https://img.shields.io/badge/Swift_Package_Manager-compatible-green.svg?style=flat"/></a>
<a href="https://github.com/yutailang0119/ProgressSpinnerKit/blob/master/LICENSE"><img alt="Lincense" src="https://img.shields.io/badge/license-MIT-black.svg?style=flat"/></a>
</p>

## Overview

Scanning file path library for Swift.  

Main use case is to be used with [SwiftSyntax](https://github.com/apple/swift-syntax).  

### Support  

* Recursion
    * all
    * depth limit
* FIle extension
* Ignore paths

> Note: FileScanKit is still in development, and the API is not guaranteed to be stable. It's subject to change without warning.

## Requirements

* Swift 5.3+
* Xcode 12.4+

## Installation

### [Swift Package Manager](https://swift.org/package-manager/)

```swift
// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "test",
    dependencies: [
        .package(url: "https://github.com/yutailang0119/FileScanKit.git", from: Version(0, 1, 0)),
    ],
    targets: [
        .target(name: "targetName", dependencies: ["FileScanKit"]),
    ]
)

```

https://github.com/apple/swift-package-manager  

## Usege

```swift
import Foundation
import FileScanKit

let path: String = "target/path"
guard let fileScanner = FileScanner(path: path)!

let recursion: Recursion = .all
let fileExtension: FileExtension = .swift
let ignorePaths: [String] = ["ignore/path"]
let option = Option(
    recursion: recursion,
    fileExtension: fileExtension,
    ignorePaths: ignorePaths
)

let result: Result<[URL], Error> = fileScanner.scan(with: option)

switch result {
case .success(let urls):
    // Do something
case .failure(let error):
    // Handle error
}
```

## Author

[Yutaro Muta](https://github.com/yutailang0119)
* muta.yutaro@gmail.com
* [@yutailang0119](https://twitter.com/yutailang0119)

## License

FileScanKit is available under the MIT license. See [the LICENSE file](./LICENSE) for more info.  
This software includes the work that is distributed in the BSD License.

// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

/*
 This source file is part of the Swift.org open source project

 Copyright 2015 Apple Inc. and the Swift project authors
 Licensed under Apache License v2.0 with Runtime Library Exception

 See http://swift.org/LICENSE.txt for license information
 See http://swift.org/CONTRIBUTORS.txt for Swift project authors
*/

import PackageDescription

let package = Package(
    name: "magic-kit",
    products: [
        .library(name: "Magic", targets: ["Magic"]),
    ],
    
    targets: [
        .target(name: "Magic", dependencies: []),
        
        .testTarget(
            name: "MagicTests",
            dependencies: ["Magic"]),//, "ReferenceKit", "RegexKit", "ExpressibleEnum"])
        
            
    ]
)

// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TDFoundation",
    products: [
        Product.library(
            name: "TDFoundation",
            targets: ["TDFoundation"]
        )
    ],
    targets: [
      Target.target(
        name: "TDFoundation"
      )
    ]
)

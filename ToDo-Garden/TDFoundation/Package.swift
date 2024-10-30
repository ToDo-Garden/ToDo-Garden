// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "TDFoundation",
  platforms: [SupportedPlatform.iOS(SupportedPlatform.IOSVersion.v15)],
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

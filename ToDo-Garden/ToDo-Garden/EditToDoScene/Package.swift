// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "EditToDoScene",
  platforms: [.iOS(.v15)],
  products: [
    .library(
      name: "EditToDoScene",
      targets: ["EditToDoScene"]
    )
  ],
  targets: [
    .target(
      name: "EditToDoScene"
    )
  ]
)

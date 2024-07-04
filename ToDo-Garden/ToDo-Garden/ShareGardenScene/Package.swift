// swift-tools-version: 5.10

import PackageDescription

let package = Package(
  name: "ShareGardenScene",
  platforms: [
    SupportedPlatform.iOS(SupportedPlatform.IOSVersion.v15)
  ],
  products: [
    .library(
      name: "ShareGardenScene",
      targets: ["ShareGardenScene"]
    )
  ],
  targets: [
    .target(
      name: "ShareGardenScene"
    )
  ]
)

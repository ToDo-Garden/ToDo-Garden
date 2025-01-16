// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "HomeScene",
  platforms: [
    SupportedPlatform.iOS(SupportedPlatform.IOSVersion.v15)
  ],
  products: [
    Product.library(
      name: "HomeScene",
      targets: ["HomeScene"]
    ),
    Product.library(
      name: "HomeSceneAPI",
      targets: ["HomeSceneAPI"]
    )
  ],
  dependencies: [
    Package.Dependency.package(path: "../ToDoGardenUI")
  ],
  targets: [
    Target.target(
      name: "HomeSceneEntity"
    ),
    Target.target(
      name: "HomeSceneAPI",
      dependencies: [
        Target.Dependency.product(
          name: "ToDoGardenUIAPI",
          package: "ToDoGardenUI"
        )
      ]
    ),
    Target.target(
      name: "HomeScene",
      dependencies: [
        "HomeSceneEntity",
        "HomeSceneAPI",
        Target.Dependency.product(
          name: "ToDoGardenUIAPI",
          package: "ToDoGardenUI"
        )
      ]
    )
  ]
)

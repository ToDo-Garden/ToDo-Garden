// swift-tools-version: 5.10

import PackageDescription

let swiftSettings: [SwiftSetting] = [
  SwiftSetting.enableExperimentalFeature("StrictConcurrency")
]

let package = Package(
  name: "ShareGardenScene",
  platforms: [
    SupportedPlatform.iOS(SupportedPlatform.IOSVersion.v15)
  ],
  products: [
    .library(
      name: "ShareGardenSceneEntity",
      targets: ["ShareGardenSceneEntity"]
    ),
    .library(
      name: "ShareGardenSceneAPI",
      targets: ["ShareGardenSceneAPI"]
    ),
    .library(
      name: "ShareGardenScene",
      targets: ["ShareGardenScene"]
    )
  ],
  dependencies: [
    Package.Dependency.package(path: "../ToDoGardenUI"),
    Package.Dependency.package(path: "../TDUtility")
  ],
  targets: [
    .target(
      name: "ShareGardenSceneEntity",
      dependencies: [
        Target.Dependency.product(
          name: "ToDoGardenUIComponent",
          package: "ToDoGardenUI"
        )
      ]
    ),
    .target(
      name: "ShareGardenSceneAPI",
      dependencies: [
        "ShareGardenSceneEntity",
        Target.Dependency.product(
          name: "ToDoGardenUIAPI",
          package: "ToDoGardenUI"
        )
      ]
    ),
    .target(
      name: "ShareGardenScene",
      dependencies: [
        "ShareGardenSceneEntity",
        "ShareGardenSceneAPI",
        Target.Dependency.product(
          name: "ToDoGardenUIComponent",
          package: "ToDoGardenUI"
        ),
        Target.Dependency.product(
          name: "ToDoGardenUIResource",
          package: "ToDoGardenUI"
        ),
        Target.Dependency.product(
          name: "TDUtility",
          package: "TDUtility"
        )
      ]
    ),
    .testTarget(
      name: "ShareGardenSceneTests",
      dependencies: [
        "ShareGardenScene",
        "ShareGardenSceneAPI",
        "ShareGardenSceneEntity",
        Target.Dependency.product(
          name: "ToDoGardenUIComponent",
          package: "ToDoGardenUI"
        )
      ]
    )
  ]
)

for target in package.targets {
  var swiftSettings = target.swiftSettings ?? []
  swiftSettings.append(
    SwiftSetting.enableExperimentalFeature("StrictConcurrency")
  )
  target.swiftSettings = swiftSettings
}

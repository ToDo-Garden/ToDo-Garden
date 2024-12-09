// swift-tools-version: 6.0
import PackageDescription

let package = Package(
  name: "AppCore",
  platforms: [.iOS(.v15)],
  products: [
    .library(
      name: "AppCore",
      targets: ["AppCore"]
    )
  ],
  dependencies: [
    Package.Dependency.package(
      name: "TDFoundation",
      path: "../TDFoundation"
    ),
    Package.Dependency.package(
      name: "OnBoardingScene",
      path: "../OnBoardingScene"
    )
  ],
  targets: [
    .target(
      name: "AppCore",
      dependencies: [
        Target.Dependency.product(
          name: "TDFoundation",
          package: "TDFoundation"
        ),
        Target.Dependency.product(
          name: "OnBoardingScene",
          package: "OnBoardingScene"
        )
      ]
    ),
    .testTarget(
      name: "AppCoreTests",
      dependencies: ["AppCore"]
    )
  ]
)

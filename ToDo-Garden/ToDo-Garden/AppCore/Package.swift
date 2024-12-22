// swift-tools-version: 5.10
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
    ),
    Package.Dependency.package(
      name: "SignUpScene",
      path: "../SignUpScene"
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
        ),
        Target.Dependency.product(
          name: "HTTPClient",
          package: "TDFoundation"
        ),
        Target.Dependency.product(
          name: "SignUpScene",
          package: "SignUpScene"
        )
      ]
    ),
    .testTarget(
      name: "AppCoreTests",
      dependencies: ["AppCore"]
    )
  ]
)

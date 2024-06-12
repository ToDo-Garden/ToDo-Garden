//
//  AppDelegate.swift
//  ToDo-Garden
//
//  Created by Noah on 1/10/24.
//

import UIKit

import ToDoGardenUIResource

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
	func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
	) -> Bool {
		self.registerCustomFonts()
    self.updateNavigationBarApperance()
		return true
	}
}

extension AppDelegate {
	private func registerCustomFonts() {
		PretendardFont.register()
	}
}

extension AppDelegate {
  private func updateNavigationBarApperance() {
    self.updateNavigationBarTitle()
    self.updateNavigationBackButtonItem()
  }

  private func updateNavigationBarTitle() {
    UINavigationBar.appearance().titleTextAttributes = [
      NSAttributedString.Key.foregroundColor: UIColor.toDoGardenGreenDark,
      NSAttributedString.Key.font: UIFont.pretendardHeadBold
    ]
  }

  private func updateNavigationBackButtonItem() {
    UIBarButtonItem.appearance().setBackButtonBackgroundImage(
      UIImage.backwardButtonImage,
      for: UIControl.State.normal,
      barMetrics: UIBarMetrics.default
    )

    UINavigationBar.appearance().backIndicatorImage = UIImage()
    UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage()
  }
}

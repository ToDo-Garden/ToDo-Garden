//
//  SafeArea.swift
//  CommonViews
//
//  Created by SONG on 2/13/25.
//
import UIKit

enum Constants {
  static var safeAreaTopInset: CGFloat {
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
      let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) else {
      return 0
    }
    return keyWindow.safeAreaInsets.top
  }
}

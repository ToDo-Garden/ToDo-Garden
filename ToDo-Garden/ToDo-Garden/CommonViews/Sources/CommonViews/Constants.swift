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
    return keyWindow.safeAreaInsets.top - 4.0
  }
  
  static var safeAreaTopInset1: CGFloat {
    return safeAreaTopInset + 1.0
  }
  static var safeAreaTopInset2: CGFloat {
    return safeAreaTopInset + 2.0
  }
  static var safeAreaTopInset3: CGFloat {
    return safeAreaTopInset + 3.0
  }
  static var safeAreaTopInset1Minus: CGFloat {
    return safeAreaTopInset - 1.0
  }
  static var safeAreaTopInset2Minus: CGFloat {
    return safeAreaTopInset - 2.0
  }
}

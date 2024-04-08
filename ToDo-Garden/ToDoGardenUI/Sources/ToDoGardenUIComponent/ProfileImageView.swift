//
//  ProfileImageView.swift
//
//
//  Created by Wood on 4/7/24.
//

import UIKit.UIImageView

public final class ProfileImageView: UIImageView {
  private var size: CGSize

  public init(size: CGSize) {
    self.size = size
    super.init(frame: CGRect.zero)
  }

  required init?(coder: NSCoder) {
    self.size = CGSize()
    super.init(coder: coder)
  }
}

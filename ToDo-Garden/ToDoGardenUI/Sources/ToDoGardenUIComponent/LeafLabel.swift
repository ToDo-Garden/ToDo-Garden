//
//  LeafLabel.swift
//  
//
//  Created by SONG on 11/8/24.
//

import UIKit

public final class LeafLabel: UIView {
  private let leafImageView: UIImageView
  private let titleLabel: UILabel
  private let descriptionLabel: UILabel
  
  public init(
    titleText: String,
    descriptionText: String
  ) {
    self.leafImageView = UIImageView(image: UIImage.leafImage)
    self.titleLabel = UILabel()
    self.descriptionLabel = UILabel()
    super.init(frame: CGRect.zero)
    self.backgroundColor = UIColor.clear
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override var intrinsicContentSize: CGSize {
    return CGSize(
      width: UIView.noIntrinsicMetric,
      height: Constant.LeafLabel.height
    )
  }
}

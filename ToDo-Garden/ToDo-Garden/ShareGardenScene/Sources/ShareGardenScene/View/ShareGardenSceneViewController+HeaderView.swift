//
//  ShareGardenSceneViewController+HeaderView.swift
//
//
//  Created by Noah on 7/5/24.
//

import UIKit

import ToDoGardenUIComponent
import ToDoGardenUIResource

extension ShareGardenSceneViewController {
  final class HeaderView: UIStackView {
    
    // MARK: - UI Properties
    
    private let titleLabel: UILabel = {
      let titleLabel = UILabel()
      titleLabel.text = "나의 가든"
      titleLabel.numberOfLines = 1
      titleLabel.font = UIFont.pretendardHeadBold
      titleLabel.textColor = UIColor.toDoGardenGreenDark
      
      return titleLabel
    }()
    
    private let shareButton: UIButton = {
      let shareButton = UIButton()
      shareButton.setImage(
        UIImage.shareIconImage,
        for: UIControl.State.normal
      )
      
      return shareButton
    }()
    // MARK: - Object life cycle
    
    init() {
      super.init(frame: CGRect.zero)
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
  }
}

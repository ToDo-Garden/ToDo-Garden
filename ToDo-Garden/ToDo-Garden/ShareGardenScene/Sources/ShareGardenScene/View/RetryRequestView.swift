//
//  RetryRequestView.swift
//  ShareGardenScene
//
//  Created by Noah on 10/15/24.
//

import UIKit

import ToDoGardenUIComponent

@MainActor
final class RetryRequestView {
  private let logoImageView: UIImageView = {
    let logoImageView = UIImageView(image: UIImage.leafSymbolImage)
    logoImageView.contentMode = UIView.ContentMode.scaleAspectFit
    logoImageView.usingAutolayout()
    logoImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
    logoImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
    
    return logoImageView
  }()
  
  private let titleLabel: UILabel = {
    let titleLabel = UILabel()
    titleLabel.numberOfLines = 2
    titleLabel.textAlignment = NSTextAlignment.center
    titleLabel.text = "앗 로딩을 하지 못했어요.\n 다시 시도해주세요."
    titleLabel.font = UIFont.pretendardHeadBold
    titleLabel.textColor = UIColor.toDoGardenGreenDark
    
    return titleLabel
  }()
  
  private let retryButton = RetryButton()
  
  var retryAction: UIAction? {
    didSet {
      guard let retryAction
      else { return }
      
      self.retryButton.addAction(retryAction, for: UIControl.Event.touchUpInside)
    }
  }
  
  lazy var view: UIView = {
    return UIVStackView(
      alignment: UIStackView.Alignment.center,
      spacing: 14,
      arrangedSubviews: [self.logoImageView, self.titleLabel, self.retryButton]
    )
  }()
}

extension RetryRequestView {
  private final class RetryButton: UIButton {
    override init(frame: CGRect) {
      super.init(frame: frame)
      self.configureAppearance()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    private func configureAppearance() {
      let title = "다시 시도하기"
      let configuration = UIButton.Configuration.plain()
      self.configuration = configuration
      
      self.configurationUpdateHandler = { button in
        guard var updatedConfiguration = button.configuration
        else { return }
        let isHighlighted = button.isHighlighted
        let highlightedColor = UIColor.toDoGardenGreenDark.withAlphaComponent(0.5)
        let normalColor = UIColor.toDoGardenGreenDark
        let titleColor: UIColor = isHighlighted ? highlightedColor : normalColor
        if let attributedTitle = self.createAttributedButtonTitle(title: title, with: titleColor) {
          updatedConfiguration.attributedTitle = AttributedString(attributedTitle)
        }
        
        self.setConfiguration(updatedConfiguration)
      }
    }
    
    private func createAttributedButtonTitle(title: String, with color: UIColor) -> NSAttributedString? {
      let attributedTitle = title.applyTextAttributes(
        attributes: [
          NSAttributedString.Key.font: UIFont.pretendardBodyBold,
          NSAttributedString.Key.foregroundColor: color
        ]
      )
      return NSMutableAttributedString(attributedString: attributedTitle)
        .addUnderline(with: UIColor.toDoGardenGreenDark, from: 0, to: title.count)
    }
    
    private func setConfiguration(_ configuration: UIButton.Configuration, duration: Double = 0.3) {
      UIView.transition(
        with: self,
        duration: duration,
        options: .transitionCrossDissolve
      ) {
        self.configuration? = configuration
      }
    }
  }
}

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

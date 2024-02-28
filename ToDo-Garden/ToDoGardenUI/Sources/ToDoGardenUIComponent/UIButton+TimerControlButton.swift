//
//  UIButton+TimerControlButton.swift
//
//
//  Created by Noah on 2/28/24.
//

import UIKit

import ToDoGardenUIResource

extension UIButton {
	public func timerControlButtonDestructiveStyle(with title: String) {
		self.setupDestructiveStyleBackgroundImage()
		self.setupTitleForTimerControlButton(with: title)
	}
	
	public func timerControlButtonDefaultStyle(with title: String) {
		self.setupDefaultStyleBackgroundImage()
		self.setupTitleForTimerControlButton(with: title)
	}
}

// MARK: - private functions

extension UIButton {
	private func setupDestructiveStyleBackgroundImage() {
		self.setBackgroundImage(
			UIImage.timerControlButtonDestructiveBackground,
			for: .normal
		)
	}
	
	private func setupDefaultStyleBackgroundImage() {
		self.setBackgroundImage(
			UIImage.timerControlButtonDefaultBackground,
			for: .normal
		)
	}
	
	private func setupTitleForTimerControlButton(with title: String) {
		let attributedTitle = NSAttributedString(
			string: title,
			attributes: [
				NSAttributedString.Key.font: UIFont.pretendardBodySemiBold15,
				NSAttributedString.Key.foregroundColor: UIColor.white
			]
		)
		
		self.setAttributedTitle(attributedTitle, for: .normal)
	}
}

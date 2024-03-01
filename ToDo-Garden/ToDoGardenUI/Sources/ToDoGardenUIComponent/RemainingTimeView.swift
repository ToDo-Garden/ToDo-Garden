//
//  RemainingTimeView.swift
//
//
//  Created by Noah on 3/1/24.
//

import UIKit

public final class RemainingTimeView: UIView {
	private let remainingTimeLabel: UILabel
	
	public init() {
		self.remainingTimeLabel = UILabel()
		super.init(frame: CGRect.zero)
		self.setupUIAppearance()
	}
	
	public required init?(coder: NSCoder) {
		self.remainingTimeLabel = UILabel()
		super.init(coder: coder)
		self.setupUIAppearance()
	}
extension RemainingTimeView {
	private func setupUIAppearance() {
		RemainingTimeViewStyle.apply(for: self, with: self.remainingTimeLabel)
	}
}

/// RemainingTimeView의 UI Style을 설정해주는 타입입니다.
fileprivate enum RemainingTimeViewStyle {
	fileprivate static func apply(for remainingTimeView: UIView, with remainingTimeLabel: UILabel) {
		RemainingTimeViewStyle.roundedCorner(remainingTimeView)
		RemainingTimeViewStyle.setupRemainingTimeLabelLayout(for: remainingTimeView, with: remainingTimeLabel)
		RemainingTimeViewStyle.setupFontForRemainingTimeLabel(remainingTimeLabel)
	}
}

extension RemainingTimeViewStyle {
	fileprivate static func roundedCorner(_ view: UIView) {
		view.clipsToBounds = true
		view.layer.cornerRadius = 6
	}
	
	fileprivate static func setupRemainingTimeLabelLayout(for remainingTimeView: UIView, with remainingTimeLabel: UILabel) {
		remainingTimeView.addSubview(remainingTimeLabel)
		remainingTimeLabel.usingAutolayout()
		
		NSLayoutConstraint.activate([
			remainingTimeLabel.centerXAnchor.constraint(equalTo: remainingTimeView.centerXAnchor),
			remainingTimeLabel.centerYAnchor.constraint(equalTo: remainingTimeView.centerYAnchor)
		])
	}
	
	fileprivate static func setupFontForRemainingTimeLabel(_ remainingTimeLabel: UILabel) {
		remainingTimeLabel.font = UIFont.pretendardBodyBold
	}
}

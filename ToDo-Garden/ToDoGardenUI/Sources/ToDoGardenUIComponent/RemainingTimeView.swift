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
	
	public func updateRemainingTime(with time: String) {
		self.remainingTimeLabel.text = time
	}
	
	public func updateBackgroundColorForBreakTime() {
		self.backgroundColor = UIColor.toDoGardenLeaf
	}
	
	public func updateBackgroundColorForFoucsTime() {
		self.backgroundColor = UIColor.toDoGardenLightRed
	}
}

extension RemainingTimeView {
	private func setupUIAppearance() {
		RemainingTimeViewStyle.apply(for: self, with: self.remainingTimeLabel)
	}
}

/// RemainingTimeView의 UI Style을 설정해주는 타입입니다.
private enum RemainingTimeViewStyle {
	fileprivate static func apply(for remainingTimeView: RemainingTimeView, with remainingTimeLabel: UILabel) {
		RemainingTimeViewStyle.roundedCorner(remainingTimeView)
		RemainingTimeViewStyle.setupRemainingTimeLabelLayout(for: remainingTimeView, with: remainingTimeLabel)
		RemainingTimeViewStyle.setupFontForRemainingTimeLabel(remainingTimeLabel)
	}
}

extension RemainingTimeViewStyle {
	private static func roundedCorner(_ view: RemainingTimeView) {
		view.clipsToBounds = true
		view.layer.cornerRadius = 6
	}
	
	private static func setupRemainingTimeLabelLayout(
		for remainingTimeView: RemainingTimeView,
		with remainingTimeLabel: UILabel
	) {
		remainingTimeView.addSubview(remainingTimeLabel)
		remainingTimeLabel.usingAutolayout()
		
		NSLayoutConstraint.activate([
			remainingTimeLabel.centerXAnchor.constraint(equalTo: remainingTimeView.centerXAnchor),
			remainingTimeLabel.centerYAnchor.constraint(equalTo: remainingTimeView.centerYAnchor)
		])
	}
	
	private static func setupFontForRemainingTimeLabel(_ remainingTimeLabel: UILabel) {
		remainingTimeLabel.font = UIFont.pretendardBodyBold
	}
}

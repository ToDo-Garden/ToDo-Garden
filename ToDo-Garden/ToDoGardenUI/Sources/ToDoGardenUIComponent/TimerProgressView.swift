//
//  TimerProgressView.swift
//
//
//  Created by Noah on 5/23/24.
//

import UIKit

import ToDoGardenUIConstant

public final class TimerProgressView: UIView {
  private let circularProgressView: CircularProgressView
  private let dot: UIView
  private var toValue: Double?
  
  public init(
    circularProgressView: CircularProgressView,
    dotColor: UIColor
  ) {
    self.circularProgressView = circularProgressView
    let dotWidth = Constant.TimerProgressView.Layout.Dot.width
    let dotHeight = Constant.TimerProgressView.Layout.Dot.height
    self.dot = UIView(
      frame: CGRect(x: 0, y: 0, width: dotWidth, height: dotHeight)
    )
    super.init(frame: CGRect.zero)
    self.setupViews(with: dotColor)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Setup views

extension TimerProgressView {
  private func setupViews(with dotColor: UIColor) {
  }
}

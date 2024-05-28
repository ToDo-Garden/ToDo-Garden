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
    self.setupDot(with: dotColor)
    self.addSubviews()
    self.setupLayoutConstraints()
  }
}

// MARK: - Setup dot

extension TimerProgressView {
  private func setupDot(with dotColor: UIColor) {
    self.dot.layer.cornerRadius = self.dot.frame.width / 2
    self.dot.backgroundColor = dotColor
  }
}

// MARK: - Add subviews

extension TimerProgressView {
  private func addSubviews() {
    self.addSubview(self.circularProgressView)
    self.addSubview(self.dot)
  }
}

// MARK: - Setup layout constraints

extension TimerProgressView {
  private func setupLayoutConstraints() {
    self.setupCircularProgressViewLayoutConstraints()
  }
  
  private func setupCircularProgressViewLayoutConstraints() {
    self.circularProgressView.usingAutolayout()
    
    NSLayoutConstraint.activate([
      self.circularProgressView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      self.circularProgressView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      self.circularProgressView.heightAnchor.constraint(equalTo: self.heightAnchor),
      self.circularProgressView.widthAnchor.constraint(equalTo: self.widthAnchor)
    ])
  }
}

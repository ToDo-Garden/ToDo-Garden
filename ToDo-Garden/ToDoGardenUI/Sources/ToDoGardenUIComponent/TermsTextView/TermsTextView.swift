//
//  TermsTextView.swift
//  ToDoGardenUI
//
//  Created by SONG on 12/27/24.
//

import UIKit

import ToDoGardenUIResource

final class TermsTextView: UIView {
  
  private let textView = UITextView()
  
  init(text: String) {
    super.init(frame: .zero)
    self.setupUI()
    self.configure(with: text)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    self.textView.usingAutolayout()
    self.textView.isEditable = false
    self.textView.isScrollEnabled = true
    self.textView.showsVerticalScrollIndicator = false
    self.textView.font = UIFont.pretendardBodySemiBold15
    self.textView.textColor = UIColor.toDoGardenGreenDark
    self.textView.backgroundColor = UIColor.white
    self.addSubview(self.textView)
    
    NSLayoutConstraint.activate([
      self.textView.topAnchor.constraint(equalTo: topAnchor, constant: 36),
      self.textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 36),
      self.textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36),
      self.textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -36)
    ])
  }
  
  private func configure(with text: String) {
    self.textView.text = text
  }
}

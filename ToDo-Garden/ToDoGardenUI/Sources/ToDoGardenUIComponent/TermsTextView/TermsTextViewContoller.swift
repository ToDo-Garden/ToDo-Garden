//
//  TetmsTextViewContoller.swift
//  ToDoGardenUI
//
//  Created by SONG on 12/27/24.
//

import UIKit

import ToDoGardenUIConstant
import ToDoGardenUIResource

public final class TermsTextViewController: UIViewController {
  private let textView: UITextView
  
  public init(title: String, text: String) {
    self.textView = UITextView()
    super.init(nibName: nil, bundle: nil)
    self.updateTitle(title)
    self.updateText(text)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.white
    self.setupTextView()
    self.setupConstraints()
  }
  
  public override func viewIsAppearing(_ animated: Bool) {
    super.viewIsAppearing(animated)
    self.navigationController?.navigationBar.isHidden = false
    self.textView.setContentOffset(CGPoint.zero, animated: false)
  }
  
  private func setupTextView() {
    self.textView.usingAutolayout()
    self.textView.isEditable = false
    self.textView.isScrollEnabled = true
    self.textView.showsVerticalScrollIndicator = false
    self.textView.font = UIFont.pretendardBodySemiBold15
    self.textView.textColor = UIColor.toDoGardenGreenDark
    self.textView.backgroundColor = UIColor.white
    self.view.addSubview(self.textView)
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      self.textView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 36),
      self.textView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 36),
      self.textView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -36),
      self.textView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -36)
    ])
  }
  
  // MARK: - Public Methods
  
  public func update(title: String?, text: String?) {
    if let title = title {
      self.updateTitle(title)
    }
    
    if let text = text {
      self.updateText(text)
    }
  }
  
  private func updateText(_ text: String) {
    self.textView.text = text
  }
  
  private func updateTitle(_ title: String) {
    self.title = title
  }
}

// swiftlint:disable all
#if DEBUG
@available(iOS 17.0, *)
#Preview {
  let viewController = TermsTextViewController(
    title: Constant.TermsTextView.termsOfServiceTitle,
    text: Constant.TermsTextView.termsOfServiceContent
  )
  
  let navi = UINavigationController(rootViewController: viewController)
  
  return navi
}
#endif
// swiftlint:enable all

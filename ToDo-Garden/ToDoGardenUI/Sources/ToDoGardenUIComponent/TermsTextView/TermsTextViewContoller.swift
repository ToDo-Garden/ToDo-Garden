//
//  TetmsTextViewContoller.swift
//  ToDoGardenUI
//
//  Created by SONG on 12/27/24.
//

import UIKit

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
    title: "약관제목",
    text:
            """
           Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Nisl tincidunt eget nullam non. Quis hendrerit dolor magna eget est lorem ipsum dolor sit. Volutpat odio facilisis mauris sit amet massa. Commodo odio aenean sed adipiscing diam donec adipiscing tristique. Mi eget mauris pharetra et. Non tellus orci ac auctor augue. Elit at imperdiet dui accumsan sit. Ornare arcu dui vivamus arcu felis. Egestas integer eget aliquet nibh praesent. In hac habitasse platea dictumst quisque sagittis purus. Pulvinar elementum integer enim neque volutpat ac.
          
          Senectus et netus et malesuada. Nunc pulvinar sapien et ligula ullamcorper malesuada proin. Neque convallis a cras semper auctor. Libero id faucibus nisl tincidunt eget. Leo a diam sollicitudin tempor id. A lacus vestibulum sed arcu non odio euismod lacinia. In tellus integer feugiat scelerisque. Feugiat in fermentum posuere urna nec tincidunt praesent. Porttitor rhoncus dolor purus non enim praesent elementum facilisis. Nisi scelerisque eu ultrices vitae auctor eu augue ut lectus. Ipsum faucibus vitae aliquet nec ullamcorper sit amet risus. Et malesuada fames ac turpis egestas sed. Sit amet nisl suscipit adipiscing bibendum est ultricies. Arcu ac tortor dignissim convallis aenean et tortor at. Pretium viverra suspendisse potenti nullam ac tortor vitae purus. Eros donec ac odio tempor orci dapibus ultrices. Elementum nibh tellus molestie nunc. Et magnis dis parturient montes nascetur. Est placerat in egestas erat imperdiet. Consequat interdum varius sit amet mattis vulputate enim.
      
          Sit amet nulla facilisi morbi tempus. Nulla facilisi cras fermentum odio eu. Etiam erat velit scelerisque in dictum non consectetur a erat. Enim nulla aliquet porttitor lacus luctus accumsan tortor posuere. Ut sem nulla pharetra diam. Fames ac turpis egestas maecenas. Bibendum neque egestas congue quisque egestas diam. Laoreet id donec ultrices tincidunt arcu non sodales neque. Eget felis eget nunc lobortis mattis aliquam faucibus purus. Faucibus interdum posuere lorem ipsum dolor sit.
      """
  )
  
  let navi = UINavigationController(rootViewController: viewController)
  
  return navi
}
#endif
// swiftlint:enable all

//
//  Sheet.swift
//  ToDoGardenUI
//
//  Created by Noah on 2/3/25.
//

import UIKit

public final class BottomSheet: UIView {
  private let grabber = Grabber()
  private var heightConstraint: NSLayoutConstraint?
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    self.setup()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    self.setupLayoutDependOnSuperView()
  }
}

// MARK: - Setup

extension BottomSheet {
  private func setup() {
    self.backgroundColor = .systemPink
    self.addSubview(self.grabber)
    self.grabber.usingAutolayout()
    NSLayoutConstraint.activate([
      self.grabber.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      self.grabber.topAnchor.constraint(equalTo: self.topAnchor, constant: 10)
    ])
    
  }
}

// MARK: - Setup layout

extension BottomSheet {
  private func setupLayoutDependOnSuperView() {
    guard let superview else { return }
    self.usingAutolayout()
    NSLayoutConstraint.activate([
      self.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
      self.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
      self.bottomAnchor.constraint(equalTo: superview.bottomAnchor)
    ])
    
    if self.heightConstraint == nil {
      self.heightConstraint = self.heightAnchor.constraint(equalToConstant: 0)
      self.heightConstraint?.isActive = true
    }
    
    superview.layoutIfNeeded()
  }
}


extension BottomSheet {
  final class Grabber: UIView {
    override init(frame: CGRect) {
      super.init(frame: frame)
      self.setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
      self.backgroundColor = UIColor.lightGray
      self.layer.cornerRadius = 3
      self.layer.masksToBounds = true
      NSLayoutConstraint.activate([
        self.widthAnchor.constraint(equalToConstant: 36),
        self.heightAnchor.constraint(equalToConstant: 5)
      ])
    }
  }
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  let someViewController = SomeViewController()
  
  return someViewController
}

final class SomeViewController: UIViewController {
  override func viewIsAppearing(_ animated: Bool) {
    super.viewIsAppearing(animated)
    let bottomSheet = BottomSheet()
    self.view.backgroundColor = .gray
    self.view.addSubview(bottomSheet)
  }
}
#endif

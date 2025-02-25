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
  private let size: Size
  
  public init(size: Size) {
    self.size = size
    super.init(frame: CGRect.zero)
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
      self.heightConstraint = self.heightAnchor.constraint(equalToConstant: self.size.minHeight)
      self.heightConstraint?.isActive = true
    }
    superview.layoutIfNeeded()
  }
}

extension BottomSheet {
  public struct Size {
    public let minHeight: CGFloat
    public let maxHeight: CGFloat
    
    public init(
      minHeight: CGFloat,
      maxHeight: CGFloat
    ) {
      self.minHeight = minHeight
      self.maxHeight = maxHeight
    }
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
    let bottomSheet = BottomSheet(size: .init(minHeight: 400, maxHeight: 200))
    self.view.backgroundColor = .gray
    self.view.addSubview(bottomSheet)
  }
}
#endif

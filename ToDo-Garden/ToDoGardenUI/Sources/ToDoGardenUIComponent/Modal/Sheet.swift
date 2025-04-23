//
//  Sheet.swift
//  ToDoGardenUI
//
//  Created by Noah on 2/3/25.
//

import UIKit

public final class BottomSheet: UIView {
  public var contentView: UIView? {
    didSet {
      self.setupContentViewLayout()
    }
  }
  
  private let grabber = Grabber()
  
  private var topConstraint: NSLayoutConstraint!
  private var initialTopConstant: CGFloat = 0
  
  private var normalTopOffset: CGFloat {
    let screenHeight = UIScreen.main.bounds.height
    let multiplier: CGFloat

    switch screenHeight {
    case 0 ... 667:
      multiplier = 0.63
    case 668 ... 810:
      multiplier = 0.52
    case 811 ... 820:
      multiplier = 0.55
    default:
      multiplier = 0.5
    }
    
    return screenHeight * multiplier
  }
  private var expandedTopOffset: CGFloat! {
    guard let superview else { return nil }
    
    return superview.frame.height * 0.1
  }
  
  private var isLayoutSetup = false
  
  public init() {
    super.init(frame: CGRect.zero)
    self.setup()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
 
  public override func layoutSubviews() {
    super.layoutSubviews()
    if self.isLayoutSetup == false {
      self.setupLayoutDependOnSuperView()
      self.layer.cornerRadius = 20
      self.layer.maskedCorners = [
        CACornerMask.layerMinXMinYCorner,
        CACornerMask.layerMaxXMinYCorner
      ]
      self.setupShadow()
      self.isLayoutSetup = true
    }
  }
}

// MARK: - Setup

extension BottomSheet {
  private func setup() {
    self.backgroundColor = UIColor.white
    self.setupGrabber()
    self.setupPangestureRecognizer()
  }
  
  private func setupGrabber() {
    self.addSubview(self.grabber)
    self.grabber.usingAutolayout()
    NSLayoutConstraint.activate([
      self.grabber.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      self.grabber.topAnchor.constraint(equalTo: self.topAnchor, constant: 10)
    ])
  }
    
  private func setupPangestureRecognizer() {
    let viewDragged = UIPanGestureRecognizer(target: self, action: #selector(self.viewDragged(_:)))
    self.addGestureRecognizer(viewDragged)
    viewDragged.delaysTouchesBegan = false
    viewDragged.delaysTouchesEnded = false
  }
  
  private func setupShadow() {
    self.layer.masksToBounds = false
    self.layer.shadowColor = UIColor.black.cgColor
    self.layer.shadowOpacity = 0.3
    self.layer.shadowOffset = CGSize(width: 0, height: 2)
    self.layer.shadowRadius = 4
  }
}

extension BottomSheet {
  @objc
  private func viewDragged(_ sender: UIPanGestureRecognizer) {
    let translation = sender.translation(in: self)
    let velocity = sender.velocity(in: self)
    
    switch sender.state {
    case  UIGestureRecognizer.State.began:
      self.initialTopConstant = self.topConstraint.constant
    case UIGestureRecognizer.State.changed:
      self.topConstraint.constant = self.initialTopConstant + translation.y
    case UIGestureRecognizer.State.ended, UIGestureRecognizer.State.cancelled:
      if self.handleQuickSwipe(with: velocity) {
        return
      }
      let nearstValue = self.nearest(
        to: self.topConstraint.constant,
        inValues: [self.normalTopOffset, self.expandedTopOffset]
      )
      if nearstValue == self.normalTopOffset {
        self.animateBottomSheet()
      } else if nearstValue == self.expandedTopOffset {
        self.animateBottomSheet(to: State.expanded)
      }
    default:
      break
    }
  }
  
  private func handleQuickSwipe(with velocity: CGPoint) -> Bool {
    if velocity.y < -300 {
      self.animateBottomSheet(to: State.expanded)
      return true
    } else if velocity.y > 300 {
      self.animateBottomSheet(to: State.normal)
      return true
    }
    return false
  }

  public func animateBottomSheet(to state: State = .normal) {
    guard let superview = self.superview else { return }
    let finalConstant: CGFloat
    if state == .normal {
      finalConstant = self.normalTopOffset
    } else {
      finalConstant = self.expandedTopOffset
    }
    self.topConstraint.constant = finalConstant

    UIView.animate(
      withDuration: 0.5,
      delay: 0,
      usingSpringWithDamping: 0.8,
      initialSpringVelocity: 0.0,
      options: .curveEaseInOut,
      animations: {
        superview.layoutIfNeeded()
      }
    )
  }
  
  private func nearest(to number: CGFloat, inValues values: [CGFloat]) -> CGFloat {
    guard let nearestValue = values.min(by: { abs(number - $0) < abs(number - $1) })
    else { return number }
    
    return nearestValue
  }
}

// MARK: - Setup layout

extension BottomSheet {
  private func setupLayoutDependOnSuperView() {
    guard let superview else { return }
    self.usingAutolayout()
    
    self.topConstraint = self.topAnchor.constraint(
      equalTo: superview.topAnchor,
      constant: self.normalTopOffset
    )
    
    NSLayoutConstraint.activate([
      self.topConstraint,
      self.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
      self.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
      self.bottomAnchor.constraint(equalTo: superview.bottomAnchor)
    ])
  }
  
  private func setupContentViewLayout() {
    guard let contentView else { return }
    
    self.addSubview(contentView)
    contentView.usingAutolayout()
    
    NSLayoutConstraint.activate([
      contentView.topAnchor.constraint(equalTo: self.grabber.bottomAnchor),
      contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
    ])
  }
}

extension BottomSheet {
  public enum State {
    case expanded
    case normal
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

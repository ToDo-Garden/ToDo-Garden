//
//  UITextField+SearchGardenTextField.swift
//
//  Created by SONG on 11/24/24.
//

import UIKit.UITextField

import ToDoGardenUIConstant
import ToDoGardenUIResource

extension UITextField {
  public func applySearchGardenStyle() -> UITextField {
    self.configureAppearance()
    self.addPaddingWithImage()
    self.addEditingAction()
    return self
  }
  
  private func configureAppearance() {
    self.backgroundColor = UIColor.toDoGardenGreenBackground
    self.layer.cornerRadius = Constant.SearchGardenTextField.Layout.cornerRadius
    self.placeholder = Constant.SearchGardenTextField.StringLiteral.defaultPlaceHolder
  }
  
  private func addEditingAction() {
    let primaryAction = UIAction { [weak self] _ in
      self?.becomeFirstResponder()
    }
    
    self.addAction(primaryAction, for: UIControl.Event.editingDidBegin)
  }
  
  private func addPaddingWithImage() {
    let constants = Constant.SearchGardenTextField.Layout.self
    let paddingView = UIView(frame: constants.paddingViewRect)
    
    let imageView = UIImageView(image: UIImage.magnifyingGlassImage)
    imageView.frame = constants.imageViewRect
    imageView.contentMode = UIView.ContentMode.center
    imageView.clipsToBounds = true
    imageView.tintColor = UIColor.toDoGardenGreenDark
    
    paddingView.addSubview(imageView)
    self.leftView = paddingView
    self.leftViewMode = UITextField.ViewMode.always
  }
}

@available(iOS 17.0, *)
#Preview {
  let view = UITextField().applySearchGardenStyle()
  view.usingAutolayout()
  view.heightAnchor.constraint(equalToConstant: 32).isActive = true
  view.widthAnchor.constraint(equalToConstant: 338).isActive = true
  return view
}

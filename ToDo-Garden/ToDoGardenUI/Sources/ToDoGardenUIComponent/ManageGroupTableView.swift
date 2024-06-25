//
//  GroupListTableView.swift
//
//
//  Created by SONG on 6/13/24.
//

import UIKit

import ToDoGardenUIAPI
import ToDoGardenUIConstant

public final class ManageGroupTableView: UITableView, ManageGroupTableViewAPI {
  
  override init(frame: CGRect, style: UITableView.Style) {
    super.init(frame: frame, style: style)
    self.commonInit()
  }
  
  @available(*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError()
  }
  
  public override var intrinsicContentSize: CGSize {
    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
    let screenWidth = windowScene?.screen.bounds.width ?? 1.0
    let screenHeight = windowScene?.screen.bounds.height ?? 1.0
    let widthInset = Constant.ManageGroupListTableView.widthInset
    let heightInset = Constant.ManageGroupListTableView.heightInset
    
    return CGSize(
      width: screenWidth + widthInset,
      height: screenHeight + heightInset
    )
  }
}

extension ManageGroupTableView {
  private func commonInit() {
    self.register(type: ManageGroupTableViewCell.self)
    self.backgroundColor = UIColor.clear
    self.separatorStyle = UITableViewCell.SeparatorStyle.none
    self.allowsSelectionDuringEditing = true
    self.dragInteractionEnabled = true
  }
}

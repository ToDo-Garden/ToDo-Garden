//
//  ManageGroupListTableViewCell.swift
//
//
//  Created by SONG on 6/13/24.
//

import UIKit

import FoundationExtension
import ToDoGardenUIAPI

public class ManageGroupTableViewCell: UITableViewCell {
  private var configuration: ManageGroupTableViewCell.Configuration?
  
  private var progressCircle: CircularProgressView?
  private var groupNameButton: UIButton?
  private var rightImageButton: UIButton?
  
  private var rightButtonActionHandler: ((UIColor, String) -> Void)?
  
  public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    self.configuration = nil
    self.progressCircle = nil
    self.groupNameButton = nil
    self.rightImageButton = nil
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.contentView.backgroundColor = UIColor.clear
    self.selectionStyle = UITableViewCell.SelectionStyle.none
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

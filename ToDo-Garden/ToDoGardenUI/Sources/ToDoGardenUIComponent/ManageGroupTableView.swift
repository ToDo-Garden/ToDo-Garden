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
    // TODO: - 윈도우 접근하지 않는 방법 고려
    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
    let screenWidth = windowScene?.screen.bounds.width ?? CGFloat.zero
    let screenHeight = windowScene?.screen.bounds.height ?? CGFloat.zero
    let widthInset = Constant.ManageGroupListTableView.widthInset
    let heightInset = Constant.ManageGroupListTableView.heightInset
    
    return CGSize(
      width: screenWidth + widthInset,
      height: screenHeight + heightInset
    )
  }
  
  public func setEditingMode(_ editing: Bool, animated: Bool) {
    self.setEditing(editing, animated: animated)
    if editing {
      self.enterEditingMode()
    } else {
      self.leaveEditingMode()
    }
    
    // TODO: - 잠재적 문제발생 지점. 애니메이션에 대한 컴플리션으로 수정하기
    Task {
      try await Task.sleep(nanoseconds: Constant.ManageGroupListTableView.sleepTime)
      self.reloadSectionExceptVisibleAndFooterCells()
    }
  }
  
  private func enterEditingMode() {
    guard let visibleCells = self.visibleCells as? [ManageGroupTableViewCell] else {
      return
    }
    visibleCells.forEach { $0.enterEditingMode() }
  }
  
  private func leaveEditingMode() {
    guard let visibleCells = self.visibleCells as? [ManageGroupTableViewCell] else {
      return
    }
    visibleCells.forEach { $0.leaveEditingMode() }
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
  
  public func reloadSectionExceptVisibleAndFooterCells() {
    let section = 0
    let numberOfRows = self.numberOfRows(inSection: section)
    guard numberOfRows > 1 else {
      return
    }
    let visibleIndexPaths = self.indexPathsForVisibleRows ?? []
    var indexPathsToReload: [IndexPath] = []
    for row in 0...(numberOfRows - 1) {
      let indexPath = IndexPath(row: row, section: section)
      if !visibleIndexPaths.contains(indexPath) && row != numberOfRows - 1 {
        indexPathsToReload.append(indexPath)
      }
    }
    self.reloadRows(at: indexPathsToReload, with: UITableView.RowAnimation.none)
  }
}

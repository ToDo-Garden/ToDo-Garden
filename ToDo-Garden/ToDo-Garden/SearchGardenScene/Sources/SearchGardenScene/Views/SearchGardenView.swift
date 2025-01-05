//
//  SearchGardenView.swift
//
//
//  Created by SONG on 11/25/24.
//

import UIKit

import ToDoGardenUIComponent
import ToDoGardenUIResource

final class SearchGardenView: UIVStackView {
  let textField: UITextField
  let tableView: SearchGardenTableView
  
  init() {
    self.textField = UITextField().applySearchGardenStyle()
    self.tableView = SearchGardenTableView()
    super.init(
      spacing: Constant.SearchGardenView.commonMargin,
      arrangedSubviews: []
    )
    self.isUserInteractionEnabled = true
    self.backgroundColor = UIColor.white
    self.setupSubViews()
  }
}

extension SearchGardenView {
  private func setupSubViews() {
    self.setupTextField()
    self.setupDivider()
    self.setupTableView()
  }
  
  private func setupTextField() {
    self.addArrangedSubview(self.textField)
    self.textField.usingAutolayout()
    NSLayoutConstraint.activate(
      [
        self.textField.heightAnchor.constraint(equalToConstant: Constant.SearchGardenView.textfieldHeight),
        self.textField.leadingAnchor.constraint(
          equalTo: self.leadingAnchor,
          constant: Constant.SearchGardenView.commonMargin
        ),
        self.textField.trailingAnchor.constraint(
          equalTo: self.trailingAnchor,
          constant: -Constant.SearchGardenView.commonMargin
        )
      ]
    )
  }
  
  private func setupDivider() {
    let divider = UIView()
    self.addArrangedSubview(divider)
    divider.backgroundColor = UIColor.toDoGardenGreenGray
    divider.usingAutolayout()
    
    NSLayoutConstraint.activate(
      [
        divider.heightAnchor.constraint(equalToConstant: 1.0),
        divider.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        divider.trailingAnchor.constraint(equalTo: self.trailingAnchor)
      ]
    )
  }
  
  private func setupTableView() {
    self.addArrangedSubview(self.tableView)
    self.tableView.usingAutolayout()

    NSLayoutConstraint.activate(
      [
        self.tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        self.tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
      ]
    )
  }
}

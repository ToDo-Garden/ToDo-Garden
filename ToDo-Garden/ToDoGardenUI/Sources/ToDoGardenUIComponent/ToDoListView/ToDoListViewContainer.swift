//
//  ToDoListViewContainer.swift
//  ToDoGardenUI
//
//  Created by Noah on 1/22/25.
//

import UIKit

public final class ToDoListViewContainer: UIViewController {
  public let toDoListView = ToDoListView()
  
  public init() {
    super.init(nibName: nil, bundle: nil)
    self.setup()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension ToDoListViewContainer {
  private func setup() {
    self.setupViewAppearance()
    self.setupConstraints()
  }
  
  private func setupViewAppearance() {
    self.view.backgroundColor = UIColor.white
  }
  
  private func setupConstraints() {
    self.view.addSubview(self.toDoListView)
    self.toDoListView.usingAutolayout()
    self.toDoListView.contentInset = UIEdgeInsets(top: 35, left: 0, bottom: 0, right: 0)
    
    NSLayoutConstraint.activate([
      self.toDoListView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20),
      self.toDoListView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
      self.toDoListView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
      self.toDoListView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
    ])
  }
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  let toDoListViewContainer = ToDoListViewContainer()
  toDoListViewContainer.applySnapshotForPreview()
  
  return toDoListViewContainer
}

extension ToDoListViewContainer {
  public func applySnapshotForPreview() {
    var snapshot = ToDoListView.Snapshot()
    
    let section1 = ToDoListView.ToDoSection(
      headerUIModel: .init(progressColor: .toDoGardenRed, progressRate: 0.6, groupTitle: "영어독해"),
      toDoItems: [.init(toDoUIModel: .init(text: "프로폴리스", foregroundColor: .toDoGardenRed))]
    )
    
    let section2 = ToDoListView.ToDoSection(
      headerUIModel: .init(progressColor: .toDoGardenYellow, progressRate: 0.6, groupTitle: "영어독해"),
      toDoItems: [
        .init(toDoUIModel: .init(text: "비타민", foregroundColor: .toDoGardenYellow)),
        .init(toDoUIModel: .init(text: "비타민", foregroundColor: .toDoGardenYellow)),
        .init(toDoUIModel: .init(text: "비타민", foregroundColor: .toDoGardenYellow)),
        .init(toDoUIModel: .init(text: "비타민", foregroundColor: .toDoGardenYellow)),
        .init(toDoUIModel: .init(text: "비타민", foregroundColor: .toDoGardenYellow)),
        .init(toDoUIModel: .init(text: "비타민", foregroundColor: .toDoGardenYellow))
      ]
    )
    
    snapshot.appendSections([section1, section2])
    
    snapshot.sectionIdentifiers.forEach { section in
      snapshot.appendItems(section.toDoItems, toSection: section)
    }
    self.toDoListView.apply(snapshot)
  }
}
#endif

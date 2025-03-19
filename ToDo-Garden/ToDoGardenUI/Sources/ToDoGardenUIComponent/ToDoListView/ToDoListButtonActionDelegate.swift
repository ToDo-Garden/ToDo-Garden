//
//  ToDoListButtonActionDelegate.swift
//  ToDoGardenUI
//
//  Created by SONG on 3/18/25.
//

import Foundation

// MARK: ToDoListView -> 외부 ViewController에게 라우팅,통신 작업 위임용 파라미터는 변동가능성 있음
@MainActor
public protocol ToDoListButtonActionDelegate: AnyObject {
  func didEditButtonTapped(group: ToDoListView.ToDoSection, todo: ToDoListView.ToDoItem)
  func didDeleteButtonTapped(group: ToDoListView.ToDoSection, todo: ToDoListView.ToDoItem)
  func didCreateToDoButtonTapped(group: ToDoListView.ToDoSection)
  func didTimerButtonTapped(group: ToDoListView.ToDoSection)
}

// MARK: Header -> ToDoListView에게 위임
protocol ToDoGroupSectionHeaderViewDelegate: AnyObject {
  func createToDo(in section: Int)
  func goTimer(in section: Int)
}

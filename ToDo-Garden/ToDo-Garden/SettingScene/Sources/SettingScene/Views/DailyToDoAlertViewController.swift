import Combine
import SwiftUI
import UIKit

import TDFoundation
import ToDoGardenUIComponent
import ToDoGardenUIResource

import SharingGRDB

// swiftlint:disable force_try identifier_name
final class DailyToDoAlertViewController: UIViewController {
  private let noticeLabel = UILabel()
  private let tableView = UITableView()
  private var tableViewHeightConstraint: NSLayoutConstraint!
  
  enum Section { case main }
  private var dataSource: UITableViewDiffableDataSource<Section, DailyToDoAlert>!
  
  @Dependency(\.defaultDatabase) private var database
  
  struct DailyToDoAlerts: FetchKeyRequest {
    func fetch(_ db: Database) throws -> [DailyToDoAlert] {
      try DailyToDoAlert
        .all()
        .order(Column("alertTime"))
        .fetchAll(db)
    }
  }
  @SharedReader(.fetch(DailyToDoAlerts())) private var dailyToDoAlerts: [DailyToDoAlert]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setup()
    self.prepare()
  }
  
  override func setEditing(_ editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: animated)
    self.navigationItem.rightBarButtonItem?.title = editing ? "완료" : "편집"
  }
  
  private func setup() {
    self.setupNavigationItem()
    self.setupNoticeLabel()
    self.setupTableView()
    self.setupAddTimerButton()
  }
  
  private func setupNavigationItem() {
    let leftAction = UIAction { [weak self] _ in
      self?.navigationController?.popViewController(animated: true)
    }
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(
      image: UIImage.backwardButtonImage,
      primaryAction: leftAction
    )
    self.navigationItem.title = "데일리 ToDo 알림"
    let rightAction = UIAction { [weak self] _ in
      self?.isEditing.toggle()
    }
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(
      title: "편집",
      primaryAction: rightAction
    )
  }
  
  private func setupNoticeLabel() {
    self.noticeLabel.text = "오늘 완료하지 못한 ToDo의 알림을 받을 수 있어요."
    self.noticeLabel.textColor = UIColor.toDoGardenGreenDark
    self.noticeLabel.font = UIFont.pretendardDetailRegular12
    self.view.addSubview(self.noticeLabel)
    self.noticeLabel.usingAutolayout()
    
    NSLayoutConstraint.activate([
      self.noticeLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 17),
      self.noticeLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 25)
    ])
  }
  
  private func setupTableView() {
    self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    self.tableView.sectionHeaderTopPadding = 0
    self.tableView.register(type: UITableViewCell.self)
    self.tableView.usingAutolayout()
    self.view.addSubview(self.tableView)
    self.dataSource = UITableViewDiffableDataSource<Section, DailyToDoAlert>(
      tableView: self.tableView
    ) { tableView, indexPath, item in
      let cell = tableView.dequeueReusableCell(type: UITableViewCell.self, for: indexPath)
      cell?.textLabel?.text = "\(item.alertTime)"
      
      return cell
    }
    
    self.tableViewHeightConstraint = self.tableView.heightAnchor.constraint(equalToConstant: 0)
    NSLayoutConstraint.activate([
      self.tableView.topAnchor.constraint(equalTo: self.noticeLabel.bottomAnchor, constant: 15),
      self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 28),
      self.tableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      self.tableViewHeightConstraint
    ])
  }
  
  private func setupAddTimerButton() {
    let button = UnderlineButton(text: "시간 추가하기") { [weak self] in
      self?.presentSettingTimeView()
    }
    let controller = UIHostingController(rootView: button)
    controller.view.usingAutolayout()
    self.addChild(controller)
    self.view.addSubview(controller.view)
    controller.didMove(toParent: self)
    
    NSLayoutConstraint.activate([
      controller.view.topAnchor.constraint(equalTo: self.tableView.bottomAnchor, constant: 12),
      controller.view.leadingAnchor.constraint(equalTo: self.tableView.leadingAnchor, constant: 4),
      controller.view.heightAnchor.constraint(equalToConstant: 34)
    ])
  }
  
  private func presentSettingTimeView() {
    let button = ToDoGardenBoxButton(
      title: "완료",
      buttonType: ToDoGardenBoxButton.Configuration.primaryRoundRectButton
    )
    let timeView = SettingTimeView(
      with: button,
      for: SettingTimeView.Configuration.alarmTimeSetting
    )
    button.addAction(
      UIAction { [weak self, weak timeView] _ in
        guard let self, let timeView else { return }
        do {
          try self.addDailyTodo(timeView.seconds)
        } catch {
          // TODO: 에러를 어떻게 처리할지 논의가 필요.
        }
        self.dismiss(animated: true)
      },
      for: UIControl.Event.touchUpInside
    )
    let viewController = UIViewController()
    viewController.view.addSubview(timeView)
    timeView.equalToParent()
    viewController.modalPresentationStyle = .pageSheet
    viewController.sheetPresentationController?.detents = [.medium()]
    self.present(viewController, animated: true)
  }
  
  private func prepare() {
    let maxAvailableHeight = self.view.bounds.height - self.noticeLabel.frame.maxY - 100
    let tableHeightStream = self.tableView.heightStream(maxAvailableHeight: maxAvailableHeight)
    Task { [weak self] in
      for await height in tableHeightStream {
        guard let self else { return }
        self.tableViewHeightConstraint.constant = height
        UIView.animate(withDuration: 0.3) {
          self.view.layoutIfNeeded()
        }
      }
    }
    
    let dailyToDoAlertStream = self.$dailyToDoAlerts.publisher.asyncStream
    Task { [weak self] in
      for await alerts in dailyToDoAlertStream {
        guard let self else { return }
        var snapshot = NSDiffableDataSourceSnapshot<Section, DailyToDoAlert>()
        snapshot.appendSections([.main])
        snapshot.appendItems(alerts)
        let shouldAnimateDifferences = self.dataSource.snapshot().itemIdentifiers.count != alerts.count
        await self.dataSource.apply(snapshot, animatingDifferences: shouldAnimateDifferences)
      }
    }
  }
}

private extension DailyToDoAlertViewController {
  struct UnderlineButton: View {
    let text: String
    let action: () -> Void
    
    var body: some View {
      Button(
        action: action,
        label: {
          HStack(spacing: 4) {
            Image(uiImage: UIImage.addButton)
            VStack(spacing: 3) {
              Text(text)
                .font(Font.pretendardBodySemiBold13)
                .foregroundColor(Color(UIColor.toDoGardenGreenDark))
              
              Color(UIColor.toDoGardenGreenDark)
                .frame(height: 1)
            }
          }
        }
      )
    }
  }
}

extension DailyToDoAlertViewController {
  func addDailyTodo(_ seconds: Double) throws {
    let todoAlert = DailyToDoAlert(alertTime: seconds)
    _ = try self.database.write { db in
      try todoAlert.inserted(db)
    }
  }
  
  func updateDailyTodo(todoAlert: DailyToDoAlert) throws {
    try database.write { db in
      try todoAlert.update(db)
    }
  }
  
  @discardableResult
  func deleteDailyTodo(todoAlert: DailyToDoAlert) throws -> Bool {
    try database.write { db in
      try todoAlert.delete(db)
    }
  }
}

private extension UITableView {
  func heightStream(maxAvailableHeight: CGFloat) -> AsyncStream<CGFloat> {
    AsyncStream { continuation in
      let initialHeight = min(self.contentSize.height, maxAvailableHeight)
      continuation.yield(initialHeight)
      
      let observer = self.observe(\.contentSize, options: [.new]) { _, change in
        guard let newSize = change.newValue else {
          return
        }
        let newHeight = min(newSize.height, maxAvailableHeight)
        continuation.yield(newHeight)
      }
      
      continuation.onTermination = { _ in
        observer.invalidate()
      }
    }
  }
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  NavigationBarUIUpdator.update()
  PretendardFont.register()
  prepareDependencies {
    $0.defaultDatabase = try! appDatabase()
  }
  
  return UINavigationController(
    rootViewController: DailyToDoAlertViewController()
  )
}
#endif
// swiftlint:enable force_try identifier_name

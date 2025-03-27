import SwiftUI
import UIKit

import TDFoundation
import TDUtility
import ToDoGardenUIComponent
import ToDoGardenUIResource

import SharingGRDB

// swiftlint:disable force_try identifier_name function_body_length
public final class DailyToDoAlertViewController: UIViewController {
  private let noticeLabel = UILabel()
  private let tableView = UITableView()
  private var addTimerButton: UIView!
  private var tableViewHeightConstraint: NSLayoutConstraint!
  
  private var dataSource: UITableViewDiffableDataSource<Int, RowModel>!
  private var scrollID: DailyToDoAlert.ID?

  private var tableViewHeightViewTask: Task<Void, Never>?
  private var dailyToDoAlertsTask: Task<Void, Never>?
  
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
    
  public override func viewDidLoad() {
    super.viewDidLoad()
    self.setup()
    self.prepare()
  }
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.configureTableViewHeight()
  }
  
  deinit {
    self.tableViewHeightViewTask?.cancel()
    self.dailyToDoAlertsTask?.cancel()
  }
  
  public override func setEditing(_ editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: animated)
    self.navigationItem.rightBarButtonItem?.title = editing ? "완료" : "편집"
    self.tableView.setEditing(editing, animated: animated)
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
    self.tableView.delegate = self
    self.tableView.showsVerticalScrollIndicator = false
    self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    self.tableView.sectionHeaderTopPadding = 0
    self.tableView.register(type: DailyToDoAlertRow.self)
    self.tableView.usingAutolayout()
    self.view.addSubview(self.tableView)
    self.dataSource = UITableViewDiffableDataSource<Int, RowModel>(
      tableView: self.tableView
    ) { [weak self] tableView, indexPath, model in
      let cell = tableView.dequeueReusableCell(type: DailyToDoAlertRow.self, for: indexPath)
      cell?.configure(
        seconds: model.alertTime,
        isOn: model.isRepeating,
        action: self?.cellAction(rowModel: model.dbData)
      )
      
      return cell
    }
    
    self.tableViewHeightConstraint = self.tableView.heightAnchor.constraint(equalToConstant: 0)
    NSLayoutConstraint.activate([
      self.tableView.topAnchor.constraint(equalTo: self.noticeLabel.bottomAnchor, constant: 30),
      self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 28),
      self.tableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      self.tableViewHeightConstraint
    ])
  }
  
  private func configureTableViewHeight() {
    let safeAreaFrame = self.view.safeAreaLayoutGuide.layoutFrame
    let maxAvailableHeight = safeAreaFrame.maxY - self.noticeLabel.frame.maxY - (self.addTimerButton.frame.height + 40)
    let tableHeightStream = self.tableView.heightStream(maxAvailableHeight: maxAvailableHeight)
    self.tableViewHeightViewTask = Task {
      for await height in tableHeightStream {
        self.tableViewHeightConstraint.constant = height
        UIView.animate(withDuration: 0.3) {
          self.view.layoutIfNeeded()
        }
      }
    }
  }
  
  private func setupAddTimerButton() {
    let button = UnderlineButton(text: "시간 추가하기") { [weak self] in
      self?.presentSettingTimeView(alertTime: Date().asDouble()) {
        let item = try? self?.addDailyTodo($0)
        self?.scrollID = item?.id
      }
    }
    let controller = UIHostingController(rootView: button)
    controller.view.usingAutolayout()
    self.addChild(controller)
    self.view.addSubview(controller.view)
    controller.didMove(toParent: self)
    self.addTimerButton = controller.view
    
    NSLayoutConstraint.activate([
      controller.view.topAnchor.constraint(equalTo: self.tableView.bottomAnchor, constant: 12),
      controller.view.leadingAnchor.constraint(equalTo: self.tableView.leadingAnchor, constant: 4),
      controller.view.heightAnchor.constraint(equalToConstant: 34)
    ])
  }
  
  private func presentSettingTimeView(
    alertTime: Double,
    action: @escaping (Double) -> Void
  ) {
    let button = ToDoGardenBoxButton(
      title: "완료",
      buttonType: ToDoGardenBoxButton.Configuration.primaryRoundRectButton
    )
    let timeView = SettingTimeView(
      with: button,
      for: SettingTimeView.Configuration.alarmTimeSetting
    )
    timeView.updateSelectedTime(
      hour: Int(alertTime.hour),
      minute: Int(alertTime.minute())
    )
    button.addAction(
      UIAction { [weak self, weak timeView] _ in
        guard let self, let timeView else { return }
        action(timeView.seconds)
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
    let dailyToDoAlertStream = self.$dailyToDoAlerts
      .publisher
      .map { $0.map(\.rowModel) }
      .removeDuplicates()
      .asyncStream
    
    self.dailyToDoAlertsTask = Task { @MainActor in
      for await models in dailyToDoAlertStream {
        var snapshot = NSDiffableDataSourceSnapshot<Int, RowModel>()
        var indexPath: IndexPath?
        for (index, alert) in models.enumerated() {
          if alert.id == self.scrollID {
            indexPath = IndexPath(row: 0, section: index)
          }
          snapshot.appendSections([index])
          snapshot.appendItems([alert], toSection: index)
        }
        await self.dataSource.apply(snapshot, animatingDifferences: true)
        if let indexPath {
          self.tableView.scrollToRow(
            at: indexPath,
            at: UITableView.ScrollPosition.middle,
            animated: true
          )
          self.scrollID = nil
        }
      }
    }
  }
}

private extension DailyToDoAlert {
  var rowModel: DailyToDoAlertViewController.RowModel {
    DailyToDoAlertViewController.RowModel(
      id: self.id,
      alertTime: self.alertTime,
      isRepeating: self.isRepeating
    )
  }
}

// MARK: - DailyToDoAlertViewController + View
private extension DailyToDoAlertViewController {
  struct RowModel: Hashable {
    var dbData: DailyToDoAlert {
      DailyToDoAlert(
        id: self.id,
        alertTime: self.alertTime,
        isRepeating: self.isRepeating
      )
    }
    var id: Int64?
    var alertTime: Double
    var isRepeating: Bool
    
    static func == (lhs: Self, rhs: Self) -> Bool {
      lhs.id == rhs.id && lhs.alertTime == rhs.alertTime
    }
  }
  
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

// MARK: - DailyToDoAlertViewController + UITableViewDelegate
extension DailyToDoAlertViewController: UITableViewDelegate {
  public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 12
  }
  
  public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    let view = UIView()
    view.backgroundColor = UIColor.clear
    return view
  }
  
  public func tableView(
    _ tableView: UITableView,
    heightForHeaderInSection section: Int
  ) -> CGFloat {
    // 0을 적용할 때, 시스템에서 기본값을 적용하는 경우가 있기 때문에 0.001을 반환하도록 구현했습니다.
    return 0.001
  }
  
  public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 58
  }
  
  public func tableView(
    _ tableView: UITableView,
    editingStyleForRowAt indexPath: IndexPath
  ) -> UITableViewCell.EditingStyle {
    return UITableViewCell.EditingStyle.none
  }
  
  public func tableView(
    _ tableView: UITableView,
    shouldIndentWhileEditingRowAt indexPath: IndexPath
  ) -> Bool {
    return false
  }
}

private extension DailyToDoAlertViewController {
  func cellAction(rowModel model: DailyToDoAlert) -> (DailyToDoAlertRow.Operation) -> Void {
    { [weak self] operation in
      switch operation {
      case .delete:
        try? self?.deleteDailyTodo(todoAlert: model)
        
      case .editAlertTime:
        self?.presentSettingTimeView(alertTime: model.alertTime) {
          var copy = model
          copy.alertTime = $0
          try? self?.updateDailyTodo(todoAlert: copy)
        }
        
      case .editRepeating(let value):
        var copy = model
        copy.isRepeating = value
        try? self?.updateDailyTodo(todoAlert: copy)
      }
    }
  }
  
  func addDailyTodo(_ seconds: Double) throws -> DailyToDoAlert {
    let todoAlert = DailyToDoAlert(alertTime: seconds, isRepeating: true)
    return try self.database.write { db in
      try todoAlert.inserted(db)
    }
  }
  
  func updateDailyTodo(todoAlert: DailyToDoAlert) throws {
    try database.write { db in
      try todoAlert.update(db)
    }
  }
  
  func deleteDailyTodo(todoAlert: DailyToDoAlert) throws {
    _ = try database.write { db in
      try todoAlert.delete(db)
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
// swiftlint:enable force_try identifier_name function_body_length

import UIKit

import TDFoundation
import ToDoGardenUIComponent

// swiftlint:disable function_body_length
final class DailyToDoAlertViewController: UIViewController {
  private let noticeLabel = UILabel()
  private let tableView = UITableView()
  private var tableViewHeightConstraint: NSLayoutConstraint!
  
  enum Section {
    case main
  }
  // TODO: preview를 위한 데이터입니다
  var items: [String] = (1...10).map(String.init)
  private var dataSource: UITableViewDiffableDataSource<Section, String>!
  
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
      self?.dismiss(animated: true)
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
    
    self.dataSource = UITableViewDiffableDataSource<Section, String>(
      tableView: self.tableView
    ) { tableView, indexPath, itemIdentifier in
      let cell = tableView.dequeueReusableCell(type: UITableViewCell.self, for: indexPath)
      cell?.textLabel?.text = itemIdentifier
      return cell
    }
    
    self.tableViewHeightConstraint = self.tableView.heightAnchor.constraint(equalToConstant: 0)
    NSLayoutConstraint.activate([
      self.tableView.topAnchor.constraint(equalTo: self.noticeLabel.bottomAnchor, constant: 15),
      self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 28),
      self.tableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      self.tableViewHeightConstraint
    ])
    
    /// 릴리즈 되나 확인 필요.
    Task {
      let maxAvailableHeight = self.view.bounds.height - self.noticeLabel.frame.maxY - 100
      let stream = self.tableView.heightStream(maxAvailableHeight: maxAvailableHeight)
      for await height in stream {
        self.tableViewHeightConstraint.constant = height
        UIView.animate(withDuration: 0.3) {
          self.view.layoutIfNeeded()
        }
      }
    }
  }
  
  private func setupAddTimerButton() {
    let action = UIAction { [weak self] _ in
      self?.presentSettingTimeView()
    }
    let button = UIButton(frame: CGRect.zero, primaryAction: action)
    button.setTitle("시간 추가하기", for: .normal)
    button.setImage(UIImage.addButton, for: .normal)
    button.titleLabel?.textColor = UIColor.toDoGardenGreenDark
    button.titleLabel?.font = UIFont.pretendardBodySemiBold13
    button.usingAutolayout()
    self.view.addSubview(button)
    
    NSLayoutConstraint.activate([
      button.topAnchor.constraint(equalTo: self.tableView.bottomAnchor, constant: 12),
      button.leadingAnchor.constraint(equalTo: self.tableView.leadingAnchor, constant: 4),
      button.heightAnchor.constraint(equalToConstant: 34)
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
      UIAction { [weak self] _ in
        guard let self else { return }
        self.dismiss(animated: true)
        self.items.append("New Item \(self.items.count)")
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.main])
        snapshot.appendItems(self.items, toSection: .main)
        self.dataSource.apply(snapshot, animatingDifferences: true)
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
    var snapshot = dataSource.snapshot()
    snapshot.appendSections([.main])
    snapshot.appendItems(items)
    dataSource.apply(snapshot)
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
  
  return UINavigationController(
    rootViewController: DailyToDoAlertViewController()
  )
}
#endif

// swiftlint:enable function_body_length

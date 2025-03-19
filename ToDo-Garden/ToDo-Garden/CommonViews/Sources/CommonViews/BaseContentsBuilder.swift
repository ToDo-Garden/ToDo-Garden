import UIKit

import EditToDoScene
import HomeScene
import ShareGardenScene
import ShareGardenSceneAPI

// swiftlint:disable all
public struct BaseContent {
  public var viewController: UIViewController
  public var transparentRegionsTask: [() -> DimmingView.TransparentRegion]
}

public struct BaseContentsBuilder {
  public var todoCreate: () -> [BaseContent]
  public var groupManagement: () -> [BaseContent]
  public var todoEdit: () -> [BaseContent]
  public var shareTab: () -> [BaseContent]
}

extension BaseContentsBuilder {
  typealias TransparentRegion = DimmingView.TransparentRegion
  
  @MainActor
  public static let live = BaseContentsBuilder(
    todoCreate: {
      return createHomeContents()
    },
    groupManagement: {
      return createGroupManagementContents()
    },
    todoEdit: {
      return createTodoEditContents()
    },
    shareTab: {
      return createShareTabContents()
    }
  )
}

// MARK: - Home
private func createHomeContents() -> [BaseContent] {
  let viewControllers = createHomeViewControllers()
  let tasks = [
    createToDoListCellRegionTask(for: viewControllers[0]),
    createToDoListCellRegionTask(for: viewControllers[1], isHighlightToDo: true),
    createToDoListCellRegionTask(for: viewControllers[2])
  ]
  
  return [
    BaseContent(viewController: viewControllers[0], transparentRegionsTask: [tasks[0]]),
    BaseContent(viewController: viewControllers[1], transparentRegionsTask: [tasks[1]]),
    BaseContent(viewController: viewControllers[2], transparentRegionsTask: [tasks[2]])
  ]
}

private func createHomeViewControllers() -> [UIViewController] {
  let home1 = HomeSceneViewController()
  let home2 = HomeSceneViewController()
  let home3 = HomeSceneViewController()
  let navi1 = UINavigationController(rootViewController: home1)
  let navi2 = UINavigationController(rootViewController: home2)
  let navi3 = UINavigationController(rootViewController: home3)
  home1.setForHomeGuide()
  home2.setForHomeGuide(isToDoItemVisible: true)
  home3.setForHomeGuide()

  return [navi1, navi2, navi3]
}

private func createToDoListCellRegionTask(for viewController: UIViewController, isHighlightToDo: Bool = false) -> () -> DimmingView.TransparentRegion {
  guard let navi = viewController as? UINavigationController,
      let homeVC = navi.topViewController as? HomeSceneViewController else {
    return { DimmingView.TransparentRegion(rect: .zero, cornerRadius: .zero)}
  }
  
  return {
    let rect: CGRect
    if isHighlightToDo {
      let frame = homeVC.getToDoListToDo().frame(in: homeVC.view)
      rect = frame.insetBy(dx: 10.0, dy: 5.0)
    } else {
      let frame = homeVC.getToDoListGroup().frame(in: homeVC.view)
      rect = frame.offsetBy(dx: 0.0, dy: -5.0).insetBy(dx: 10.0, dy: 0.0)
    }
    
    return DimmingView.TransparentRegion(rect: rect, cornerRadius: 10.0)
  }
}

// MARK: - Group Management
private func createGroupManagementContents() -> [BaseContent] {
  let viewControllers = createGroupManagementViewControllers()
  let navigationControllers = createNavigationControllers(from: viewControllers)
  
  let normalTableViewRegionTask = createNormalTableViewRegionTask(for: viewControllers[0])
  let footerRegionTask = createFooterRegionTask(for: viewControllers[0])
  let rightButtonRegionTask = createRightButtonRegionTask(for: viewControllers[1])
  let editTableViewRegionTask = createEditTableViewRegionTask(for: viewControllers[2])
  
  return [
    BaseContent(viewController: navigationControllers[0], transparentRegionsTask: [normalTableViewRegionTask]),
    BaseContent(viewController: navigationControllers[1], transparentRegionsTask: [footerRegionTask]),
    BaseContent(viewController: navigationControllers[2], transparentRegionsTask: [rightButtonRegionTask, editTableViewRegionTask])
  ]
}

private func createGroupManagementViewControllers() -> [ManageGroupViewControllerForGuide] {
  return [
    ManageGroupViewControllerForGuide(),
    ManageGroupViewControllerForGuide(),
    ManageGroupViewControllerForGuide(isEditMode: true)
  ]
}

private func createNormalTableViewRegionTask(for viewController: ManageGroupViewControllerForGuide) -> () -> DimmingView.TransparentRegion {
  return {
    let cellRect = viewController.getTableViewCell().frame(in: viewController.view)
    let rect = CGRect(
      x: Int(cellRect.minX),
      y: Int(cellRect.minY),
      width: Int(cellRect.width),
      height: Int(cellRect.height) * 3
    ).offsetBy(dx: 0.0, dy: Constants.safeAreaTopInset + calculateYOffset(vc: viewController))
    
    return DimmingView.TransparentRegion(rect: rect, cornerRadius: 18.0)
  }
}

private func createFooterRegionTask(for viewController: ManageGroupViewControllerForGuide) -> () -> DimmingView.TransparentRegion {
  return {
    let cellRect = viewController.footerView.frame(in: viewController.view)
    let rect = CGRect(x: Int(cellRect.minX), y: Int(cellRect.midY), width: Int(cellRect.width), height: Int(cellRect.height))
    
    return DimmingView.TransparentRegion(rect: rect, cornerRadius: 14.0)
  }
}

private func createRightButtonRegionTask(for viewController: ManageGroupViewControllerForGuide) -> () -> DimmingView.TransparentRegion {
  return {
    let buttonRect = viewController.getRightBarButton().frame(in: viewController.view)
    let rect = CGRect(x: Int(buttonRect.minX), y: Int(buttonRect.minY), width: Int(buttonRect.width), height: Int(buttonRect.height)).insetBy(dx: -5.0, dy: -5.0)
    
    return DimmingView.TransparentRegion(rect: rect.offsetBy(dx: -(buttonRect.width / 2) - 1, dy: Constants.safeAreaTopInset1Minus), cornerRadius: 8.0)
  }
}

private func createEditTableViewRegionTask(for viewController: ManageGroupViewControllerForGuide) -> () -> DimmingView.TransparentRegion {
  return {
    let cellRect = viewController.getTableViewCell().frame(in: viewController.view)
    let rect = CGRect(
      x: Int(cellRect.minX),
      y: Int(cellRect.minY),
      width: Int(cellRect.width),
      height: Int(cellRect.height) * 3
    ).offsetBy(dx: 0.0, dy: Constants.safeAreaTopInset + calculateYOffset(vc: viewController))
    
    return DimmingView.TransparentRegion(rect: rect, cornerRadius: 18.0)
  }
}

// MARK: - Todo Edit
private func createTodoEditContents() -> [BaseContent] {
  let home = HomeSceneViewController()
  let homeNavigationController = UINavigationController(rootViewController: home)
  home.setForEditToDoGuide(swipedCell: ToDoListViewForGuide())
  homeNavigationController.navigationBar.isHidden = true
  let viewControllers = [
    homeNavigationController,
    UINavigationController(rootViewController: EditToDoViewController()),
    UINavigationController(rootViewController: EditToDoViewController())
  ]
  
  var transparentRegionsTasks: [[() -> DimmingView.TransparentRegion]] = []
  
  viewControllers.enumerated().forEach { (index, viewController) in
    let task = createEditToDoGuideTransparentRegionsTask(for: viewController, index: index)
    transparentRegionsTasks.append(task)
  }
  
  return [
    BaseContent(viewController: viewControllers[0], transparentRegionsTask: transparentRegionsTasks[0]),
    BaseContent(viewController: viewControllers[1], transparentRegionsTask: transparentRegionsTasks[1]),
    BaseContent(viewController: viewControllers[2], transparentRegionsTask: transparentRegionsTasks[2])
  ]
}

// MARK: - Share Tab
@MainActor
private func createShareTabContents() -> [BaseContent] {
  let mockDependency = MockFriendsGardenStore()
  let viewControllers = [
    ShareGardenSceneViewController(friendsGardenStore: mockDependency),
    ShareGardenSceneViewController(friendsGardenStore: mockDependency)
  ]
  
  let getProfileViewRegionTask = createProfileViewRegionTask(for: viewControllers[0], verticalOffset: Constants.safeAreaTopInset3)
  let getShareButtonRegionTask = createShareButtonRegionTask(for: viewControllers[1], verticalOffset: Constants.safeAreaTopInset2)
  
  viewControllers.forEach { $0.setForGuide() }
  
  let navigationControllers = createNavigationControllers(from: viewControllers)
  
  return [
    BaseContent(viewController: navigationControllers[0], transparentRegionsTask: [getProfileViewRegionTask]),
    BaseContent(viewController: navigationControllers[1], transparentRegionsTask: [getShareButtonRegionTask])
  ]
}

// MARK: - Helper Methods

private func calculateYOffset(vc: UIViewController?) -> CGFloat {
  guard let vc = vc, let navi = vc.navigationController else {
    return 0.0
  }
  
  let navigationBarHeight = navi.navigationBar.frame(in: vc.view).height
  return navigationBarHeight
}

private func createNavigationControllers(from viewControllers: [UIViewController]) -> [UINavigationController] {
  return viewControllers.map { viewController in
    let naviController = UINavigationController(rootViewController: viewController)
    naviController.view.preservesSuperviewLayoutMargins = true
    naviController.navigationBar.isHidden = true
    return naviController
  }
}

private func createEditToDoGuideTransparentRegionsTask(for viewController: UIViewController, index: Int) -> [() -> DimmingView.TransparentRegion] {
  
  switch index {
  case 0:
    guard let topVC = (viewController as? UINavigationController)?.topViewController,
      let homeVC = topVC as? HomeSceneViewController else { return [] }
    let swipedCell = homeVC.getSwipedCell()
    let regionTask = {
      let rect = swipedCell.frame(in: homeVC.view).offsetBy(dx: 9.5, dy: -2.0).insetBy(dx: 5.0, dy: -5.0)
      return DimmingView.TransparentRegion(rect: rect, cornerRadius: 10.0)
    }
    
    return [regionTask]
  case 1:
    guard let topVC = (viewController as? UINavigationController)?.topViewController,
      let editToDoVC = topVC as? EditToDoViewController else { return [] }
    editToDoVC.setForGuide(index: index)
    return [
      createTodoNameInputViewRegionTask(for: editToDoVC, in: topVC),
      createGroupSelectionViewRegionTask(for: editToDoVC, in: topVC)
    ]
  case 2:
    guard let topVC = (viewController as? UINavigationController)?.topViewController,
      let editToDoVC = topVC as? EditToDoViewController else { return [] }
    editToDoVC.setForGuide(index: index)
    return [
      createSegmentedControlRegionTask(for: editToDoVC, in: topVC),
      createAlarmTimeViewRegionTask(for: editToDoVC, in: topVC)
    ]
  default:
    return []
  }
}
private func createTodoNameInputViewRegionTask(for editToDoVC: EditToDoViewController, in viewController: UIViewController) -> () -> DimmingView.TransparentRegion {
  return {
    let rect = editToDoVC.getToDoNameInputView().frame(in: viewController.view).offsetBy(dx: 0.0, dy: Constants.safeAreaTopInset2Minus + calculateYOffset(vc: viewController)).insetBy(dx: -9.0, dy: -6)
    return DimmingView.TransparentRegion(rect: rect, cornerRadius: 10.0)
  }
}

private func createGroupSelectionViewRegionTask(for editToDoVC: EditToDoViewController, in viewController: UIViewController) -> () -> DimmingView.TransparentRegion {
  return {
    let rect = editToDoVC.getGroupSelectionView().frame(in: viewController.view).offsetBy(dx: 0.0, dy: Constants.safeAreaTopInset2Minus + calculateYOffset(vc: viewController)).insetBy(dx: 5.0, dy: -5)
    return DimmingView.TransparentRegion(rect: rect, cornerRadius: 10.0)
  }
}

private func createSegmentedControlRegionTask(for editToDoVC: EditToDoViewController, in viewController: UIViewController) -> () -> DimmingView.TransparentRegion {
  return {
    let rect = editToDoVC.getSegmentedControl().frame(in: viewController.view).offsetBy(dx: 0.0, dy: Constants.safeAreaTopInset1Minus + calculateYOffset(vc: viewController)).insetBy(dx: -5, dy: -5)
    return DimmingView.TransparentRegion(rect: rect, cornerRadius: 8.0)
  }
}

private func createAlarmTimeViewRegionTask(for editToDoVC: EditToDoViewController, in viewController: UIViewController) -> () -> DimmingView.TransparentRegion {
  return {
    let rect = editToDoVC.getAlarmTimeView().frame(in: viewController.view).offsetBy(dx: 0.0, dy: Constants.safeAreaTopInset1Minus + calculateYOffset(vc: viewController)).insetBy(dx: -5, dy: -5)
    return DimmingView.TransparentRegion(rect: rect, cornerRadius: 15.0)
  }
}

private func createProfileViewRegionTask(for viewController: ShareGardenSceneViewController, verticalOffset: CGFloat) -> () -> DimmingView.TransparentRegion {
  return {
    let frame = viewController.getMyProfileView().frame(in: viewController.view)
    let rect = frame.offsetBy(dx: .zero, dy: verticalOffset).insetBy(dx: 10.0, dy: .zero)
    return DimmingView.TransparentRegion(rect: rect, cornerRadius: 18.0)
  }
}

private func createShareButtonRegionTask(for viewController: ShareGardenSceneViewController, verticalOffset: CGFloat) -> () -> DimmingView.TransparentRegion {
  return {
    let frame = viewController.getShareButton().frame(in: viewController.view)
    let rect = frame.offsetBy(dx: .zero, dy: verticalOffset + 2).insetBy(dx: -2.5, dy: -2.5)
    return DimmingView.TransparentRegion(rect: rect, cornerRadius: 7.5)
  }
}

// MARK: - Backport: 필요하면 공용 파일로 옮기겠습니다.
extension UIView {
  func frame(in coordinateSpace: UIView) -> CGRect {
    if #available(iOS 17.0, *) {
      self.frame(in: coordinateSpace) ?? CGRect.zero
    } else {
      self.convert(self.bounds, to: coordinateSpace)
    }
  }
}

// swiftlint:enable all

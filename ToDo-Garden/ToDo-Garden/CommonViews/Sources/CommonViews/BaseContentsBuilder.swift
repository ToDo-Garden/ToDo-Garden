import UIKit

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
      []
    },
    groupManagement: {
      let viewControllers = [
        ManageGroupViewControllerForGuide(),
        ManageGroupViewControllerForGuide(),
        ManageGroupViewControllerForGuide(isEditMode: true)
      ]
      
      let navigationControllers = viewControllers.map { UINavigationController(rootViewController: $0) }
      
      return [
        BaseContent(
          viewController: navigationControllers[0], 
          transparentRegionsTask: [viewControllers[0].getTableViewTransparentRegion]
        ),
        BaseContent(
          viewController: navigationControllers[1], 
          transparentRegionsTask: [viewControllers[1].getFooterViewTransparentRegion]
        ),
        BaseContent(
          viewController: navigationControllers[2], 
          transparentRegionsTask: [
            viewControllers[2].getTableViewTransparentRegion,
            viewControllers[1].getRightBarButtonTransparentRegion
          ]
        )
      ]
    },
    todoEdit: {
      []
    },
    shareTab: {
      []
    }
  )
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

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
      []
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
  func _frame(in coordinateSpace: UIView) -> CGRect {
    if #available(iOS 17.0, *) {
      self.frame(in: coordinateSpace) ?? CGRect.zero
    } else {
      self.convert(self.bounds, to: coordinateSpace)
    }
  }
}
//let viewController = TimerSceneSceneBuilder(dependency: .live).build()
//let navi = UINavigationController(rootViewController: viewController)
//viewController.title = "Navigation Title"
//
//return [
//  .init(
//    viewController: navi,
//    transparentRegionsTask: [
//      {
//        TransparentRegion(
//          rect: viewController.timerProgressView
//            ._frame(in: viewController.view),
//          cornerRadius: 10
//        )
//      },
//      {
//        TransparentRegion(
//          rect: viewController.timeLabel
//            ._frame(in: viewController.view),
//          cornerRadius: 0
//        )
//      }
//    ]
//  )
//]

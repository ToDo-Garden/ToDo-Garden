import UIKit

import ToDoGardenUIConstant
import ToDoGardenUIResource

extension Styled.Row {
  public enum Configuration {
    var profileModel: ProfileModel? {
      if case let Self.profile(model) = self {
        return model
      }
      return nil
    }
    
    var listPrimaryModel: ListPrimaryModel? {
      if case let Self.listPrimary(model) = self {
        return model
      }
      return nil
    }
    var todoListModel: TodoListModel? {
      if case let Self.todoList(model) = self {
        return model
      }
      return nil
    }
    var repeatOtherDaysModel: RepeatOtherDaysModel? {
      if case let Self.repeatOtherDays(model) = self {
        return model
      }
      return nil
    }
    
    case profile(ProfileModel)
    case listPrimary(ListPrimaryModel)
    case todoList(TodoListModel)
    case repeatOtherDays(RepeatOtherDaysModel)
  }
}

extension Styled.Row.Configuration {
  public struct ProfileModel {
    public var style: Style
    public var title: String
    public var description: String
    public var image: UIImage
    
    public init(
      style: Style,
      title: String,
      description: String,
      image: UIImage? = nil
    ) {
      self.style = style
      self.title = title
      self.description = description
      self.image = image ?? style.defaultImage
    }
    
    subscript<T>(style keypath: KeyPath<Style, T>) -> T {
      style[keyPath: keypath]
    }
  }
  
  public struct ListPrimaryModel: Equatable {
    let title: String
    let color: UIColor
    
    public init(title: String, color: UIColor) {
      self.title = title
      self.color = color
    }
  }
  
  public struct RepeatOtherDaysModel: Equatable {
    let title: String
    
    public init(title: String) {
      self.title = title
    }
  }
  
  public struct TodoListModel: Equatable {
    public static let empty = Self()
    public var text: String?
    public var isSelected: Bool
    public var hasAlert: Bool
    
    public init(
      text: String? = nil,
      isSelected: Bool = false,
      hasAlert: Bool = false
    ) {
      self.text = text
      self.isSelected = isSelected
      self.hasAlert = hasAlert
    }
  }
}

extension Styled.Row.Configuration.ProfileModel {
  public enum Style {
    var axis: NSLayoutConstraint.Axis {
      self == .shareRow
      ? NSLayoutConstraint.Axis.horizontal
      : NSLayoutConstraint.Axis.vertical
    }
    
    var innerPadding: NSDirectionalEdgeInsets {
      switch self {
      case Self.setting:
        return NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
      case Self.shareProfile:
        return NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 36)
      case Self.shareRow:
        return NSDirectionalEdgeInsets(top: 6, leading: 25, bottom: 6, trailing: 25)
      }
    }
    
    var defaultImage: UIImage {
      self == Self.shareRow
      ? UIImage.defaultProfileImage
      : UIImage.defaultFriendProfileImage
    }
    
    var imageSize: CGSize {
      self == Self.shareRow
      ? CGSize(width: 36, height: 36)
      : CGSize(width: 56, height: 56)
    }
    
    var profileImageTrailingPadding: CGFloat {
      switch self {
      case Self.setting:
        return 8
      case Self.shareProfile:
        return 15
      case Self.shareRow:
        return 6
      }
    }
    
    var titleFont: UIFont {
      self == Self.shareRow
      ? UIFont.pretendardBodyBold
      : UIFont.pretendardHeadBold
    }
    
    var descriptionFont: UIFont {
      self == Self.shareRow
      ? UIFont.pretendardBodyMedium
      : UIFont.pretendardDetailLight
    }
    
    case setting
    case shareProfile
    case shareRow
  }
}

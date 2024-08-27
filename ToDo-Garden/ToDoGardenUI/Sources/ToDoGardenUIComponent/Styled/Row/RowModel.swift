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
  public struct ProfileModel: Equatable {
    public static func primary(
      image: UIImage = UIImage.defaultProfileImage,
      title: String,
      description: String
    ) -> Self {
      return Self(
        image: image,
        title: title,
        titleFont: UIFont.pretendardHeadBold,
        description: description,
        descriptionFont: UIFont.pretendardDetailLight,
        axis: NSLayoutConstraint.Axis.vertical,
        profileSize: Constant.Styled.Row.Profile.shareProfileSize
      )
    }
    
    public static func gardenInfo(
      image: UIImage = UIImage.defaultFriendProfileImage,
      title: String,
      description: String
    ) -> Self {
      return Self(
        image: image,
        title: title,
        titleFont: UIFont.pretendardBodySemiBold,
        description: description,
        descriptionFont: UIFont.pretendardBodyMedium,
        axis: NSLayoutConstraint.Axis.horizontal,
        profileSize: Constant.Styled.Row.Profile.friendListProfileSize
      )
    }
    var image: UIImage = UIImage.defaultFriendProfileImage
    var title: String
    var titleFont: UIFont
    var description: String
    var descriptionFont: UIFont
    var axis: NSLayoutConstraint.Axis
    var profileSize: CGSize
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

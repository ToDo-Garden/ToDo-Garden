import ToDoGardenUIResource
import UIKit

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
    
    case profile(ProfileModel)
    case listPrimary(ListPrimaryModel)
    case todoList(TodoListModel)
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
        axis: .vertical
      )
    }
    
    public static func gardenInfo(
      image: UIImage = UIImage.defaultProfileImage,
      title: String,
      description: String
    ) -> Self {
      return Self(
        image: image,
        title: title,
        titleFont: UIFont.pretendardBodySemiBold,
        description: description,
        descriptionFont: UIFont.pretendardBodyMedium,
        axis: .horizontal
      )
    }
    var image: UIImage = UIImage.defaultFriendProfileImage
    var title: String
    var titleFont: UIFont
    var description: String
    var descriptionFont: UIFont
    var axis: NSLayoutConstraint.Axis
  }
  
  public struct ListPrimaryModel: Equatable {
    let title: String
    let color: UIColor
  }
  
  public struct TodoListModel: Equatable {
    public static let empty = Self()
    public var text: String?
    public var isSelected: Bool
    
    public init(text: String? = nil, isSelected: Bool = false) {
      self.text = text
      self.isSelected = isSelected
    }
  }
}

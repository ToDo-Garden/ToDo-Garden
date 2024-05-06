import UIKit

extension Styled.TextField {
  public enum Configuration: Equatable {
    var primaryModel: PrimaryModel? {
      if case let Self.primary(model) = self {
        return model
      }
      return nil
    }
    
    var groupEditModel: GroupEditModel? {
      if case let Self.groupEdit(model) = self {
        return model
      }
      return nil
    }
    
    case primary(PrimaryModel)
    case groupEdit(GroupEditModel)
  }
}

extension Styled.TextField.Configuration {
  public struct PrimaryModel: Equatable {
    public static let standard = Self(
      cornerRadius: 10,
      image: UIImage.searchIconImage,
      imageLeadingConstant: 7,
      imageTrailingConstant: 4
    )
    
    let cornerRadius: CGFloat
    let image: UIImage?
    let imageLeadingConstant: CGFloat
    let imageTrailingConstant: CGFloat
  }
  
  public struct GroupEditModel: Equatable {
    public static let standard = Self(mainColor: UIColor.toDoGardenGreenDark, bottomLineDisplayMode: DisPlayMode.always)
    public static let todoList = Self(mainColor: UIColor.toDoGardenRed, bottomLineDisplayMode: DisPlayMode.editing)
    
    var mainColor: UIColor
    var image: UIImage = UIImage(systemName: "xmark.circle.fill") ?? UIImage.searchIconImage
    var bottomLineDisplayMode: DisPlayMode
  }
}

extension Styled.TextField.Configuration.GroupEditModel {
  enum DisPlayMode: Equatable {
    case always
    case editing
    case none
  }
}

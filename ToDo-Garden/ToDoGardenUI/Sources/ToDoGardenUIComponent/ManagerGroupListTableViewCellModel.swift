//
//  ManageGroupListTableViewCell.swift
//
//
//  Created by SONG on 6/16/24.
//

import UIKit

import ToDoGardenUIConstant

extension ManageGroupListTableViewCell {
  public struct Configuration {
    public enum Style {
      case primary(
        id: String,
        groupName: String,
        progressColor: UIColor,
        progressRate: Float
      )
      case secondary(
        id: String,
        groupName: String,
        progressColor: UIColor,
        progressRate: Float
      )
    }

    struct Model {
      let id: String
      var progressCircle: ProgressCircle
      var groupNameButton: GroupNameButton
      var rightImageButton: RightImageView
      
      init(
        id: String,
        progressCircle: ProgressCircle,
        groupNameButton: GroupNameButton,
        rightImageButton: RightImageView
      ) {
        self.id = id
        self.progressCircle = progressCircle
        self.groupNameButton = groupNameButton
        self.rightImageButton = rightImageButton
      }
    }
  }
  
  struct ModelParameters {
    let id: String
    let groupName: String
    let progressColor: UIColor
    let progressRate: Float
    let isCreateToDoButton: Bool
    let rightImage: UIImage
    let rightImageHidden: Bool
    let rightImageTrailing: CGFloat
  }
}

extension ManageGroupListTableViewCell.Configuration.Model {
  struct ProgressCircle {
    var progressColor: Observable<UIColor>
    var progressRate: Observable<Float>
    let backgroundColor: UIColor
    let lineWidth: CGFloat
    let size: CGSize
    let leading: CGFloat
  }
  
  struct GroupNameButton {
    var groupName: Observable<String>
    let cornerRadius: CGFloat
    let isCreateToDoButton: Bool
    let leading: CGFloat
    let contentInsets: NSDirectionalEdgeInsets
    let height: CGFloat
    let widthMultiplier: CGFloat
  }
  
  struct RightImageView {
    var isHidden: Observable<Bool>
    let image: UIImage
    let size: CGSize
    let trailing: CGFloat
  }
}

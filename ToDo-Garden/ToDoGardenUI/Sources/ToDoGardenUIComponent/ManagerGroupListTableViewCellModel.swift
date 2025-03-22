//
//  ManageGroupListTableViewCell.swift
//
//
//  Created by SONG on 6/16/24.
//

import UIKit

import TDUtility
import ToDoGardenUIConstant

extension ManageGroupTableViewCell {
  public struct Configuration {
    public enum Style {
      case primary(
        id: UUID,
        groupName: String,
        progressColor: UIColor,
        progressRate: Float,
        isEditing: Bool
      )
      case secondary(
        id: UUID,
        groupName: String,
        progressColor: UIColor,
        progressRate: Float
      )
    }
    
    var model: Model?
    
    public init(style: Style) {
      let parameters = self.createParameters(for: style)
      self.model = self.createModel(with: parameters)
    }
    
    private func createParameters(for style: Style) -> ModelParameters {
      let constants = Constant.ManageGroupListTableViewCell.self
      switch style {
      case .primary(let id, let groupName, let progressColor, let progressRate, let isEditing):
        return ModelParameters(
          id: id,
          groupName: groupName,
          progressColor: progressColor,
          progressRate: progressRate,
          isCreateToDoButton: false,
          rightImage: UIImage.forwardButtonImage,
          rightImageHidden: !isEditing,
          rightImageTrailing: constants.RightImageView.trailingPrimary
        )
      case .secondary(let id, let groupName, let progressColor, let progressRate):
        return ModelParameters(
          id: id,
          groupName: groupName,
          progressColor: progressColor,
          progressRate: progressRate,
          isCreateToDoButton: true,
          rightImage: UIImage.timerButtonImage,
          rightImageHidden: false,
          rightImageTrailing: constants.RightImageView.trailingSecondary
        )
      }
    }
    
    private func createModel(with parameters: ModelParameters) -> Model {
      let progressCircle = createProgressCircle(
        progressColor: parameters.progressColor,
        progressRate: parameters.progressRate
      )
      
      let groupNameButton = createGroupNameButton(
        groupName: parameters.groupName,
        isCreateToDoButton: parameters.isCreateToDoButton
      )
      
      let rightImageView = createRightImageView(
        image: parameters.rightImage,
        isHidden: parameters.rightImageHidden,
        trailing: parameters.rightImageTrailing
      )
      
      return Model(
        id: parameters.id,
        progressCircle: progressCircle,
        groupNameButton: groupNameButton,
        rightImageButton: rightImageView
      )
    }
    private func createProgressCircle(
      progressColor: UIColor,
      progressRate: Float
    ) -> Model.ProgressCircle {
      let constants = Constant.ManageGroupListTableViewCell.self
      return Model.ProgressCircle(
        progressColor: ObservingValue(progressColor),
        progressRate: ObservingValue(progressRate),
        backgroundColor: UIColor.toDoGardenGray1,
        lineWidth: constants.ProgressCircle.lineWidth,
        size: constants.CommonSize.size,
        leading: constants.ProgressCircle.leading
      )
    }
    
    private func createGroupNameButton(
      groupName: String,
      isCreateToDoButton: Bool
    ) -> Model.GroupNameButton {
      let constants = Constant.ManageGroupListTableViewCell.self
      return Model.GroupNameButton(
        groupName: ObservingValue(groupName),
        cornerRadius: constants.GroupNameButton.cornerRadius,
        isCreateToDoButton: isCreateToDoButton,
        leading: constants.GroupNameButton.leading,
        contentInsets: NSDirectionalEdgeInsets(
          top: constants.GroupNameButton.verticalInset,
          leading: constants.GroupNameButton.horizontalInset,
          bottom: constants.GroupNameButton.verticalInset,
          trailing: constants.GroupNameButton.horizontalInset
        ),
        height: constants.GroupNameButton.height,
        widthMultiplier: constants.GroupNameButton.widthMultiplier
      )
    }
    
    private func createRightImageView(
      image: UIImage,
      isHidden: Bool,
      trailing: CGFloat
    ) -> Model.RightImageView {
      let constants = Constant.ManageGroupListTableViewCell.self
      return Model.RightImageView(
        isHidden: ObservingValue(isHidden),
        image: image,
        size: constants.CommonSize.size,
        trailing: trailing
      )
    }
    
    struct Model {
      let id: UUID
      var progressCircle: ProgressCircle
      var groupNameButton: GroupNameButton
      var rightImageButton: RightImageView
      
      init(
        id: UUID,
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
    let id: UUID
    let groupName: String
    let progressColor: UIColor
    let progressRate: Float
    let isCreateToDoButton: Bool
    let rightImage: UIImage
    let rightImageHidden: Bool
    let rightImageTrailing: CGFloat
  }
}

extension ManageGroupTableViewCell.Configuration.Model {
  struct ProgressCircle {
    var progressColor: ObservingValue<UIColor>
    var progressRate: ObservingValue<Float>
    let backgroundColor: UIColor
    let lineWidth: CGFloat
    let size: CGSize
    let leading: CGFloat
  }
  
  struct GroupNameButton {
    var groupName: ObservingValue<String>
    let cornerRadius: CGFloat
    let isCreateToDoButton: Bool
    let leading: CGFloat
    let contentInsets: NSDirectionalEdgeInsets
    let height: CGFloat
    let widthMultiplier: CGFloat
  }
  
  struct RightImageView {
    var isHidden: ObservingValue<Bool>
    let image: UIImage
    let size: CGSize
    let trailing: CGFloat
  }
}

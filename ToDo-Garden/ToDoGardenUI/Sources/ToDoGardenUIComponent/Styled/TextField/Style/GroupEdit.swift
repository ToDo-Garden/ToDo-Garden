import UIKit

import ToDoGardenUIConstant

extension Styled.TextField {
  func buildGroupEditStyle(model: Configuration.GroupEditModel) {
    self.buildClearButton(model: model)
    self.buildBottomLine(color: model.mainColor)
  }
  
  private func buildClearButton(model: Configuration.GroupEditModel) {
    if let button = self.value(forKeyPath: "_clearButton") as? UIButton {
      button.setImage(model.image, for: .normal)
      button.tintColor = model.mainColor
      self.$configuration
        .compactMap(\.groupEditModel)
        .removeDuplicates()
        .sink { [weak button] model in
          button?.tintColor = model.mainColor
        }
        .store(in: &self.cancellables)
    }
  }
  
  private func buildBottomLine(color: UIColor) {
    let line = UIProgressView(progressViewStyle: .bar)
    line.trackTintColor = UIColor.toDoGardenGray1
    line.usingAutolayout()
    self.addSubview(line)
    NSLayoutConstraint.activate([
      line.bottomAnchor.constraint(equalTo: bottomAnchor),
      line.leadingAnchor.constraint(equalTo: leadingAnchor),
      line.trailingAnchor.constraint(equalTo: trailingAnchor),
      line.heightAnchor.constraint(equalToConstant: Constant.Styled.TextField.GroupEdit.bottomLineHeight)
    ])
    self.bindingBottomLine(line: line)
    self.bottomLine = line
  }
  
  private func bindingBottomLine(line: UIProgressView) {
    self.$configuration
      .compactMap(\.groupEditModel)
      .removeDuplicates()
      .sink { [weak line] model in
        line?.progressTintColor = model.mainColor
      }
      .store(in: &self.cancellables)
  }
}

//
//  CalendarView.swift
//
//
//  Created by Wood on 5/31/24.
//

import UIKit

public final class CalendarView: UIView {
  private var model: Model

  public init(model: Model) {
    self.model = model
    super.init(frame: CGRect.zero)
  }

  @available(*, deprecated)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension CalendarView {
  public struct Model {
    let borderWidth: CGFloat
    let cornerRadius: CGFloat
    let collectionView: Model.CollectionView

    public static let primary = Self(
      borderWidth: Constant.CalendarView.Layout.Primary.borderWidth,
      cornerRadius: Constant.CalendarView.Layout.Primary.cornerRadius,
      collectionView: CollectionView(
        itemSize: Constant.CalendarView.Layout.Primary.itemSize,
        itemSpacing: Constant.CalendarView.Layout.Primary.itemSpacing,
        lineSpacing: Constant.CalendarView.Layout.Primary.lineSpacing
      )
    )
  }
}

extension CalendarView.Model {
  public struct CollectionView {
    let itemSize: CGSize
    let itemSpacing: CGFloat
    let lineSpacing: CGFloat
  }
}

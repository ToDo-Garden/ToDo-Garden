//
//  GuideDetailViewController+static.swift
//  GuideScene
//
//  Created by SONG on 3/25/25.
//

extension GuideDetailViewController {
  public static func todoCreate() -> GuideDetailViewController {
    return GuideDetailViewController(.todoCreate)
  }

  public static func groupManagement() -> GuideDetailViewController {
    return GuideDetailViewController(.groupManagement)
  }

  public static func shareTab() -> GuideDetailViewController {
    return GuideDetailViewController(.shareTab)
  }

  public static func todoEdit() -> GuideDetailViewController {
    return GuideDetailViewController(.todoEdit)
  }
}

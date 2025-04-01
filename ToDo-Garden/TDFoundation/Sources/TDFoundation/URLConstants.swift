//
//  URLConstants.swift
//  TDFoundation
//
//  Created by SONG on 12/18/24.
//

import Foundation

public enum URLConstants {
  public enum Auth { }
  public enum ToDo { }
  public enum Group { }
  public enum Garden { }
  public enum Profile { }
  public enum Timer { }
  public enum Stats { }
  public enum Itunes { }
  public enum Apps { }
}

// swiftlint:disable all
extension URLConstants.Auth {
  public static let appleLoginURL = URL(string: "https://dupsiwbkfitzegzlrwgv.supabase.co/auth/v1/token?grant_type=id_token")!
  public static let signUpURL = URL(string: "https://dupsiwbkfitzegzlrwgv.supabase.co/rest/v1/rpc/sign_up")!
  public static let validateUserURL = URL(string: "https://dupsiwbkfitzegzlrwgv.supabase.co/rest/v1/rpc/validate_user")!
  // ↑ 기존유저/신규유저 체크 URL
  public static let refreshTokenURL = URL(string: "https://dupsiwbkfitzegzlrwgv.supabase.co/auth/v1/token?grant_type=refresh_token")!
  public static let withDrawURL = URL(string: "https://dupsiwbkfitzegzlrwgv.supabase.co/rest/v1/rpc/cancel_membership")!
  public static let logoutURL = URL(string: "https://dupsiwbkfitzegzlrwgv.supabase.co/auth/v1/logout?scope=global")!
}

extension URLConstants.ToDo {
  public static let fetchToDoDetail = URL(string: "https://dupsiwbkfitzegzlrwgv.supabase.co/rest/v1/rpc/detail")!
  public static let editToDo = URL(string: "https://dupsiwbkfitzegzlrwgv.supabase.co/rest/v1/todos")!
  public static let deleteToDo = URL(string: "https://dupsiwbkfitzegzlrwgv.supabase.co/rest/v1/rpc/delete_todo")!
  public static let fetchToDoList = URL(string: "https://dupsiwbkfitzegzlrwgv.supabase.co/rest/v1/rpc/todo_list")!
  public static let todoBatch = URL(string: "https://dupsiwbkfitzegzlrwgv.supabase.co/rest/v1/rpc/edit_todos")!
}

extension URLConstants.Group {
  public static let fetchGroups = URL(string: "https://dupsiwbkfitzegzlrwgv.supabase.co/rest/v1/rpc/grouplist")!
  public static let addGroup = URL(string: "https://dupsiwbkfitzegzlrwgv.supabase.co/rest/v1/rpc/make_group")!
  public static let saveEdittedGroup = URL(string: "https://dupsiwbkfitzegzlrwgv.supabase.co/rest/v1/rpc/edit_groups")!
}

extension URLConstants.Garden {
  public static let searchGarden = URL(string: "https://dupsiwbkfitzegzlrwgv.supabase.co/rest/v1/rpc/search_garden")!
  public static let loadUserGarden = URL(string:"https://dupsiwbkfitzegzlrwgv.supabase.co/rest/v1/rpc/friend")!
  public static let addGarden = URL(string: "https://dupsiwbkfitzegzlrwgv.supabase.co/rest/v1/rpc/add_friend")!
  public static let loadMyGarden = URL(string:"https://dupsiwbkfitzegzlrwgv.supabase.co/rest/v1/rpc/my_garden")!
  public static let loadMyFriendList = URL(string: "https://dupsiwbkfitzegzlrwgv.supabase.co/rest/v1/rpc/friends_garden_list")!
  public static let deleteGarden = URL(string: "https://dupsiwbkfitzegzlrwgv.supabase.co/rest/v1/rpc/delete_friend")!
}

extension URLConstants.Stats {
  public static let getCurrentContinuousDays = URL(string: "https://dupsiwbkfitzegzlrwgv.supabase.co/rest/v1/rpc/get_current_consecutive_days")!
  public static let getMaxRecords = URL(string: "https://dupsiwbkfitzegzlrwgv.supabase.co/rest/v1/rpc/get_max_records")!
  public static let getSummary = URL(string: "https://dupsiwbkfitzegzlrwgv.supabase.co/rest/v1/rpc/get_summary")!
}

extension URLConstants.Profile {
  public static let getUserProfile = URL(string: "https://dupsiwbkfitzegzlrwgv.supabase.co/rest/v1/rpc/get_my_info")!
  public static let getProfileImage = URL(string: "https://dupsiwbkfitzegzlrwgv.supabase.co/storage/v1/object/authenticated/profileImages/")!
  public static let changeProfileImage = URL(string: "https://dupsiwbkfitzegzlrwgv.supabase.co/storage/v1/object/profileImages/")!
  public static let changeIntroduction = URL(string: "https://dupsiwbkfitzegzlrwgv.supabase.co/rest/v1/rpc/edit_introduction")!
  public static let changeNickname = URL(string: "https://dupsiwbkfitzegzlrwgv.supabase.co/rest/v1/rpc/edit_nickname")!
}

extension URLConstants.Timer {
  public static let postCompletedTimerItems = URL(string: "https://dupsiwbkfitzegzlrwgv.supabase.co/rest/v1/rpc/complete_timer")!
}

extension URLConstants.Itunes {
  public static let lookup = URL(string: "https://itunes.apple.com/lookup")!
}

extension URLConstants.Apps {
  //TODO: - app id 넣어야합니다.
  public static let appstore = URL(string: "https://apps.apple.com/app/id/여기에")!
}
// swiftlint:enable all

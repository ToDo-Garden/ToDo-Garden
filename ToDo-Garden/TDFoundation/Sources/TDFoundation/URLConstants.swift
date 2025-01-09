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
}

// swiftlint:disable all
extension URLConstants.Auth {
  public static let appleLoginURL = URL(string: "https://dupsiwbkfitzegzlrwgv.supabase.co/auth/v1/token?grant_type=id_token")!
  public static let signUpURL = URL(string: "https://dupsiwbkfitzegzlrwgv.supabase.co/rest/v1/rpc/sign_up")!
  public static let validateUserURL = URL(string: "https://dupsiwbkfitzegzlrwgv.supabase.co/rest/v1/rpc/validate_user")!
  // ↑ 기존유저/신규유저 체크 URL
  public static let refreshTokenURL = URL(string: "https://dupsiwbkfitzegzlrwgv.supabase.co/auth/v1/token?grant_type=refresh_token")!
}

extension URLConstants.Group {
  public static let fetchGroups = URL(string: "https://dupsiwbkfitzegzlrwgv.supabase.co/rest/v1/rpc/grouplist")!
  public static let addGroup = URL(string: "https://dupsiwbkfitzegzlrwgv.supabase.co/rest/v1/rpc/make_group")!
}

extension URLConstants.Garden {
  public static let searchGarden = URL(string: "https://dupsiwbkfitzegzlrwgv.supabase.co/rest/v1/rpc/search_garden")!
  public static let loadUserGarden = URL(string:"https://dupsiwbkfitzegzlrwgv.supabase.co/rest/v1/rpc/friend")!
  public static let addGarden = URL(string: "https://dupsiwbkfitzegzlrwgv.supabase.co/rest/v1/rpc/add_friend")!
}

extension URLConstants.Stats {
  public static let getCurrentContinuousDays = URL(string: "https://dupsiwbkfitzegzlrwgv.supabase.co/rest/v1/rpc/get_current_consecutive_days")!
  public static let getMaxRecords = URL(string: "https://dupsiwbkfitzegzlrwgv.supabase.co/rest/v1/rpc/get_max_records")!
  public static let getSummary = URL(string: "https://dupsiwbkfitzegzlrwgv.supabase.co/rest/v1/rpc/get_summary")!
}
// swiftlint:enable all

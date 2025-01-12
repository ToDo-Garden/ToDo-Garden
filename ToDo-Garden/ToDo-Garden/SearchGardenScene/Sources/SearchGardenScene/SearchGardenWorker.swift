//
//  SearchGardenWorker.swift
//
//
//  Created by SONG on 11/18/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit.UIImage

import HTTPClientAPI
import SearchGardenSceneAPI
import SearchGardenSceneEntity
import TDFoundation
import ToDoGardenUIComponent // TODO: 제거 예정

public struct SearchGardenWorker: SearchGardenWorkable {
  private let httpclient: HTTPClientAPI
  
  public init(httpclient: HTTPClientAPI) {
    self.httpclient = httpclient
  }
  
  // swiftlint:disable function_body_length
  public func loadSearchedGardenList(
    inputText: String,
    page: Int
  ) async throws -> SearchGarden.SearchedGardenList {
    var result: [SearchGardenUser] = []
    let fetchedData = try await self.fetchSearchedGarden(
      inputText: inputText,
      page: page
    )
    guard let users = fetchedData.data else {
      return SearchGarden.SearchedGardenList(
        searchedGardens: [],
        page: page,
        isEndPage: fetchedData.isEndPage
      )
    }
    
    for user in users {
      guard let id = UUID(uuidString: user.id) else {
        throw HTTPClientError.deserializationError
      }
      
      //      var userImage: UIImage?
      //      if let urlString = user.imageurl, let url = URL(string: urlString) {
      //        let imageData = try await self.downloadImage(imageURL: url)
      //        userImage = UIImage(data: imageData)
      //      } else {
      //        userImage = nil
      //      }
      
      result.append(
        SearchGardenUser(
          id: id,
          nickname: user.nickname,
          customId: user.customId,
          userImage: nil
        )
      )
    }
    
    return SearchGarden.SearchedGardenList(
      searchedGardens: result,
      page: page,
      isEndPage: fetchedData.isEndPage
    )
  }
}

// - MARK: 통신 수행 메서드
extension SearchGardenWorker {
  public func loadFriendGarden(userID: UUID) async throws -> SearchGarden.LoadFriendGardenDTO.Response {
    let request = try self.makeHTTPRequestForLoadingFriendGarden(userID: userID)
    let result = try await self.httpclient.send(
      input: request,
      serializer: { $0 },
      deserializer: { response in
        try self.checkStatusCode(response: response)
        let decodedBody: SearchGarden.LoadFriendGardenDTO.Response = try self.decodeBody(response: response)
        return decodedBody
      }
    )
    return result
  }
  
  public func addGarden(userID: UUID) async throws {
    let request = try self.makeHTTPRequestForAddingGarden(userID: userID)
    try await self.httpclient.send(
      input: request,
      serializer: { $0 },
      deserializer: { response in
        try self.checkStatusCode(response: response)
      }
    )
  }
  
  private func fetchSearchedGarden(
    inputText: String,
    page: Int
  ) async throws -> SearchGarden.SearchGardenUsersDTO.Response {
    let httpRequest = try self.makeHTTPRequestForFetchingGarden(inputText: inputText, page: page)
    
    let fetchedData = try await self.httpclient.send(
      input: httpRequest,
      serializer: { $0 },
      deserializer: { response in
        try self.checkStatusCode(response: response)
        let decodedBody: SearchGarden.SearchGardenUsersDTO.Response = try self.decodeBody(response: response)
        return decodedBody
      }
    )
    return fetchedData
  }
  
  private func downloadImage(imageURL: URL) async throws -> Data {
    let httpRequest = try self.makeHTTPRequestForLoadingImage(url: imageURL)
    
    let downloadedData = try await self.httpclient.send(
      input: httpRequest,
      serializer: { $0 },
      deserializer: { response in
        try self.checkStatusCode(response: response)
        guard let data = response.body else {
          throw HTTPClientError.deserializationError
        }
        
        return data
      }
    )
    return downloadedData
  }
}
// swiftlint:enable function_body_length

// - MARK: Make HTTPRequest
extension SearchGardenWorker {
  private func makeHTTPRequestForFetchingGarden(inputText: String, page: Int) throws -> HTTPRequest {
    guard let accessToken = try KeychainManager.shared.load(forKey: KeychainManager.KeychainKey.accessToken),
      let accessTokenString = String(data: accessToken, encoding: .utf8) else {
      throw KeychainError.nonExistentKey
    }
    
    return HTTPRequest(
      method: .get,
      endPoint: URLConstants.Garden.searchGarden,
      queryItems: [
        "pageindex": "\(page)",
        "search_id": inputText
      ]
    )
  }
  
  private func makeHTTPRequestForLoadingImage(url: URL) throws -> HTTPRequest {
    guard let accessToken = try KeychainManager.shared.load(forKey: KeychainManager.KeychainKey.accessToken),
      let accessTokenString = String(data: accessToken, encoding: .utf8) else {
      throw KeychainError.nonExistentKey
    }
    
    return HTTPRequest(
      method: .get,
      endPoint: url
    )
  }
  
  private func makeHTTPRequestForLoadingFriendGarden(userID: UUID) throws -> HTTPRequest {
    guard let accessToken = try KeychainManager.shared.load(forKey: KeychainManager.KeychainKey.accessToken),
      let accessTokenString = String(data: accessToken, encoding: .utf8) else {
      throw KeychainError.nonExistentKey
    }
    
    return HTTPRequest(
      method: .get,
      endPoint: URLConstants.Garden.loadUserGarden,
      queryItems: ["garden_id": userID.uuidString]
    )
  }
  
  private func makeHTTPRequestForAddingGarden(userID: UUID) throws -> HTTPRequest {
    guard let accessToken = try KeychainManager.shared.load(forKey: KeychainManager.KeychainKey.accessToken),
      let accessTokenString = String(data: accessToken, encoding: .utf8) else {
      throw KeychainError.nonExistentKey
    }
    
    let body = try JSONEncoder().encode(SearchGarden.AddGardenDTO.Response(gardenId: userID.uuidString))
    
    return HTTPRequest(
      method: .post,
      endPoint: URLConstants.Garden.addGarden,
      body: body
    )
  }
}

extension SearchGardenWorker {
  private func checkStatusCode(response: HTTPResponse) throws {
    guard response.statusCode >= 200 && response.statusCode < 400 else {
      throw HTTPClientError.badStatusCode(response.statusCode)
    }
  }
  
  private func decodeBody<T: Decodable>(response: HTTPResponse) throws -> T {
    guard let data = response.body else {
      throw HTTPClientError.deserializationError
    }
    
    return try JSONDecoder().decode(T.self, from: data)
  }
}

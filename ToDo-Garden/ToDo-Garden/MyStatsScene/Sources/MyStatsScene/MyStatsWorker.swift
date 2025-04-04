import UIKit

import HTTPClientAPI
import MyStatsSceneAPI
import MyStatsSceneEntity
import TDFoundation

public struct MyStatsWorker: MyStatsWorkable {
  private let httpClient: HTTPClientAPI
  
  public init(httpClient: HTTPClientAPI) {
    self.httpClient = httpClient
  }
  
  public func fetchProfileViewData() async throws -> MyStats.FetchedProfileViewData {
    let result = try await self.downloadProfileData()
    
    var imageData: UIImage?
    if let urlString = result.imageUrl,
      let imageUrl = URL(string: urlString) {
      imageData = try await Cache.shared.execute(id: imageUrl, isDownsample: true)
    } else {
      imageData = nil
    }
    
    return MyStats.FetchedProfileViewData(
      nickname: result.nickname,
      profileImage: imageData,
      continuousRecordCount: result.continuousRecordCount,
      continuousRecordStartDate: result.continuousRecordStartDate,
      continuousRecordEndDate: result.continuousRecordEndDate
    )
  }
  
  public func fetchLongestRecordsViewData() async throws -> MyStats.FetchedLongestRecordViewData {
    let result = try await self.downloadLongestRecordsViewData()
    return result
  }
  
  public func fetchSummaryViewData() async throws -> MyStats.FetchedSummaryViewData {
    let result = try await self.downloadSummaryData()
    return result
  }
}

extension MyStatsWorker {
  private func downloadProfileData() async throws -> MyStats.ProfileViewDataDTO {
    let request = HTTPRequest(
      method: .get,
      endPoint: URLConstants.Stats.getCurrentContinuousDays
    )
    
    let result = try await self.httpClient.send(
      input: request,
      serializer: { $0 },
      deserializer: { response in
        guard response.statusCode >= 200 && response.statusCode < 400 else {
          throw HTTPClientError.badStatusCode(response.statusCode)
        }
        
        guard let data = response.body else {
          throw HTTPClientError.deserializationError
        }
        
        return try JSONDecoder().decode(MyStats.ProfileViewDataDTO.self, from: data)
      }
    )
    return result
  }
  
  private func downloadLongestRecordsViewData() async throws -> MyStats.FetchedLongestRecordViewData {
    let request = HTTPRequest(method: .get, endPoint: URLConstants.Stats.getMaxRecords)
    let result = try await self.httpClient.send(
      input: request,
      serializer: { $0 },
      deserializer: { response in
        guard response.statusCode >= 200 && response.statusCode < 400 else {
          throw HTTPClientError.badStatusCode(response.statusCode)
        }
        
        guard let data = response.body else {
          throw HTTPClientError.deserializationError
        }
        
        return try JSONDecoder().decode(MyStats.FetchedLongestRecordViewData.self, from: data)
      }
    )
    return result
  }
  
  private func downloadSummaryData() async throws -> MyStats.FetchedSummaryViewData {
    let request = HTTPRequest(method: .get, endPoint: URLConstants.Stats.getSummary)
    let result = try await self.httpClient.send(
      input: request,
      serializer: { $0 },
      deserializer: { response in
        guard response.statusCode >= 200 && response.statusCode < 400 else {
          throw HTTPClientError.badStatusCode(response.statusCode)
        }
        
        guard let data = response.body else {
          throw HTTPClientError.deserializationError
        }
        
        return try JSONDecoder().decode(MyStats.FetchedSummaryViewData.self, from: data)
      }
    )
    return result
  }
}

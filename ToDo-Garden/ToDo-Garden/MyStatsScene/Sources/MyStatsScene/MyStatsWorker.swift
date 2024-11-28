import Foundation

import MyStatsSceneAPI
import MyStatsSceneEntity

public enum MyStatsWorkerError: Error {
  case fetchProfileDataFailed
  case fetchLongestRecordDataFailed
  case fetchSummaryDataFailed
}

public struct MyStatsWorker: MyStatsWorkable {
  public init() {}
  
  public func fetchProfileViewData() async throws -> MyStats.FetchedProfileViewData {
    do {
      
      return MyStats.FetchedProfileViewData(
        continuousRecordCount: 99,
        continuousRecordStartDate: Date.distantPast,
        continuousRecordEndDate: Date.distantFuture
      )
    } catch {
      throw MyStatsWorkerError.fetchProfileDataFailed
    }
  }
  
  public func fetchLongestRecordsViewData() async throws -> MyStats.FetchedLongestRecordViewData {
    do {
      return MyStats.FetchedLongestRecordViewData(
        concentratedRecordGroupName: "킹왕짱그룹",
        concentratedRecordCount: 99,
        concentratedRecordDate: Date.now,
        longestContinuousRecordCount: 10,
        longestContinuousRecordStartDate: Date.distantPast,
        longestContinuousRecordEndDate: Date.distantFuture
      )
    } catch {
      throw MyStatsWorkerError.fetchLongestRecordDataFailed
    }
  }
  
  public func fetchSummaryViewData() async throws -> MyStats.FetchedSummaryViewData {
    do {
      return MyStats.FetchedSummaryViewData(
        concentratedTime: 3660,
        completedCount: 3.5
      )
    } catch {
      throw MyStatsWorkerError.fetchSummaryDataFailed
    }
  }
}

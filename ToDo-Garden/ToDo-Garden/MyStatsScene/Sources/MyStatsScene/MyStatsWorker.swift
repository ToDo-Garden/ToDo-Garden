import Foundation

import MyStatsSceneAPI
import MyStatsSceneEntity

public struct MyStatsWorker: MyStatsWorkable {
  public init() {}
  
  public func fetchProfileViewData() async throws -> MyStats.FetchedProfileViewData {
    do {
      // TODO: RESTAPI 연동
      
      return MyStats.FetchedProfileViewData(
        continuousRecordCount: 99,
        continuousRecordStartDate: Date.distantPast,
        continuousRecordEndDate: Date.distantFuture
      )
    } catch {
      throw MyStats.MyStatsWorkerError.fetchProfileDataFailed
    }
  }
  
  public func fetchLongestRecordsViewData() async throws -> MyStats.FetchedLongestRecordViewData {
    do {
      // TODO: RESTAPI 연동
      return MyStats.FetchedLongestRecordViewData(
        concentratedRecordGroupName: "킹왕짱그룹",
        concentratedRecordCount: 99,
        concentratedRecordDate: Date.now,
        longestContinuousRecordCount: 10,
        longestContinuousRecordStartDate: Date.distantPast,
        longestContinuousRecordEndDate: Date.distantFuture
      )
    } catch {
      throw MyStats.MyStatsWorkerError.fetchLongestRecordDataFailed
    }
  }
  
  public func fetchSummaryViewData() async throws -> MyStats.FetchedSummaryViewData {
    do {
      // TODO: RESTAPI 연동
      return MyStats.FetchedSummaryViewData(
        concentratedTime: 3660,
        completedCount: 3.5
      )
    } catch {
      throw MyStats.MyStatsWorkerError.fetchSummaryDataFailed
    }
  }
}

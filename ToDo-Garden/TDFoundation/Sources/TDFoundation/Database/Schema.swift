import Foundation

import SharingGRDB

// swiftlint:disable force_try identifier_name
public func appDatabase() throws -> any DatabaseWriter {
  var configuration = Configuration()
  configuration.foreignKeysEnabled = true
  #if DEBUG
    configuration.prepareDatabase { db in
      db.trace(options: .profile) {
        print($0.expandedDescription)
      }
    }
  #endif
  
  @Dependency(\.context) var context
  let database: any DatabaseWriter = if context == .live {
    try DatabasePool(
      path: URL.dbPath,
      configuration: configuration
    )
  } else {
    try DatabaseQueue(configuration: configuration)
  }
  try! database.migrate()
  
  return database
}

private extension URL {
  static var dbPath: String {
    FileManager.default
      .urls(for: .documentDirectory, in: .userDomainMask)[0]
      .appendingPathComponent("db.sqlite")
      .path
  }
}

extension DatabaseWriter {
  public func migrate() throws {
    var migrator = DatabaseMigrator()
    defer { try! migrator.migrate(self) }
    #if DEBUG
      migrator.eraseDatabaseOnSchemaChange = true
    #endif
    migrator.registerMigration("Create 'dailyToDoAlerts' table") { db in
      try db.create(table: DailyToDoAlert.databaseTableName) { t in
        t.autoIncrementedPrimaryKey("id")
        t.column("alertTime", .double)
          .notNull()
        t.column("isRepeating", .boolean)
          .defaults(to: true)
          .notNull()
      }
    }
  }
}

public struct DailyToDoAlert: Equatable {
  public var id: Int64?
  public var alertTime: Double
  public var isRepeating: Bool
  
  public init(
    id: Int64? = nil,
    alertTime: Double,
    isRepeating: Bool
  ) {
    self.id = id
    self.alertTime = alertTime
    self.isRepeating = isRepeating
  }
}

extension DailyToDoAlert: FetchableRecord, MutablePersistableRecord {
  public static let databaseTableName: String = "dailyToDoAlerts"
  
  public mutating func didInsert(_ inserted: InsertionSuccess) {
    self.id = inserted.rowID
  }
}

extension DailyToDoAlert: Sendable, Hashable, Codable { }
// swiftlint:enable force_try identifier_name

import Foundation

import SharingGRDB

// swiftlint:disable force_try identifier_name function_body_length
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

    try createDailyToDoAlertsTable(migrator: &migrator)
    try createMyGroupsAndMyToDosTables(migrator: &migrator)
    try createTodoBatchItemTable(migrator: &migrator)
    try createPendingEditGroupTable(migrator: &migrator)
  }
  
  private func createDailyToDoAlertsTable(migrator: inout DatabaseMigrator) throws {
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
  
  private func createMyGroupsAndMyToDosTables(migrator: inout DatabaseMigrator) throws {
    migrator.registerMigration("Create 'MyGroups' table") { db in
      try db.create(table: MyGroup.databaseTableName) { t in
        t.primaryKey("groupId", .text, onConflict: .replace)
        t.column("date", .text).notNull()
        t.column("name", .text).notNull()
        t.column("color", .text).notNull()
      }
    }
    
    migrator.registerMigration("Create 'MyToDos' table") { db in
      try db.create(table: MyToDo.databaseTableName) { t in
        t.primaryKey("todoId", .text, onConflict: .replace)
        t.column("groupId", .text)
          .notNull()
          .references(MyGroup.databaseTableName, onDelete: .cascade)
        t.column("date", .text).notNull()
        t.column("name", .text).notNull()
        t.column("isDone", .boolean).notNull().defaults(to: false)
        t.column("startDay", .text)
        t.column("endDay", .text)
        t.column("alarmTime", .integer)
        t.column("isAlarmOn", .boolean).notNull().defaults(to: false)
        t.column("isOnlyToday", .boolean).notNull().defaults(to: true)
        t.column("repeatToDoId", .text)
      }
    }
  }
  
  private func createTodoBatchItemTable(migrator: inout DatabaseMigrator) throws {
    migrator.registerMigration("Create 'todoBatchItem' table") { db in
      try db.create(table: TodoBatchItem.databaseTableName) { t in
        t.primaryKey("localId", .text, onConflict: .replace)
        t.column("name", .text)
          .notNull()
        t.column("isDone", .boolean)
          .notNull()
          .defaults(to: false)
        t.column("createdAt", .text)
          .notNull()
        t.column("isAlarmOn", .boolean)
          .notNull()
          .defaults(to: false)
        t.column("alarmTime", .double)
        t.column("isOnlyToday", .boolean)
          .notNull()
          .defaults(to: true)
        t.column("startDay", .text)
        t.column("endDay", .text)
        t.column("isDelete", .boolean)
          .notNull()
          .defaults(to: false)
        t.column("groupId", .text)
          .notNull()
          .references(MyGroup.databaseTableName, onDelete: .cascade)
      }
    }
  }
  
  private func createPendingEditGroupTable(migrator: inout DatabaseMigrator) throws {
    migrator.registerMigration("Create 'pendingEditGroup' table") { db in
      try db.create(table: "pendingEditGroup") { t in
        t.column("requestData", .blob).notNull()
      }
    }
  }
}

public struct DailyToDoAlert: Identifiable {
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

public struct DailyToDoAlerts: FetchKeyRequest {
  public init() { }
  
  public func fetch(_ db: Database) throws -> [DailyToDoAlert] {
    try DailyToDoAlert
      .all()
      .order(Column("alertTime"))
      .fetchAll(db)
  }
}
// swiftlint:enable force_try identifier_name function_body_length

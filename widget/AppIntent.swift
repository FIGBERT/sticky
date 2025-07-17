//
//  AppIntent.swift
//  widget
//
//  Created by figbert on 7/17/25.
//

import WidgetKit
import AppIntents
import SwiftData

struct ConfigurationAppIntent: WidgetConfigurationIntent {
  static var title: LocalizedStringResource = "Select Board"
  static var description: IntentDescription = "The set of stickies to display."

  @Parameter(title: "Board")
  var selected: BoardEntity?
}

struct BoardEntity: AppEntity {
  var id: String

  static var typeDisplayRepresentation: TypeDisplayRepresentation = "Board"
  static var defaultQuery = BoardQuery()

  var displayRepresentation: DisplayRepresentation {
    DisplayRepresentation(title: "\(id)")
  }
}

struct BoardQuery: EntityQuery {
  func entities(for identifiers: [BoardEntity.ID]) async throws -> [BoardEntity] {
    await boards()
  }

  func suggestedEntities() async throws -> [BoardEntity] {
    await boards()
  }

  func defaultResult() async -> BoardEntity? {
    await boards().first
  }

  @MainActor
  private func boards() -> [BoardEntity] {
    guard let container = try? ModelContainer(for: Board.self, Note.self) else {
      return []
    }

    guard let boards = try? container.mainContext.fetch(FetchDescriptor<Board>()) else {
      return []
    }

    return boards.map({ BoardEntity(id: $0.name) })
  }
}


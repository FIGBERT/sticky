//
//  Manager.swift
//  sticky
//
//  Created by figbert on 6/26/25.
//

import SwiftUI
import SwiftData

@Observable
class Manager {
  private let container = try? ModelContainer(for: Board.self, Note.self)
  private var context: ModelContext? { container?.mainContext }

  var selected: Board.ID?
  var board: Board? {
    boards.first(where: { $0.id == selected })
  }

  var boards: [Board] {
    let query = FetchDescriptor<Board>(sortBy: [.init(\.name)])
    let result = try? context?.fetch(query)

    return result ?? []
  }
  var notes: [Note] {
    guard let board = selected else { return [] }

    let query = FetchDescriptor<Note>(predicate: #Predicate { $0.board?.id == board })
    let result = try? context?.fetch(query)

    return result ?? []
  }

  func addNote(_ color: PadColor) {
    context?.insert(Note(color, parent: board!))
    try? context?.save()
  }
  func addBoard() {
    let next = Board(number: boards.count+1)
    context?.insert(next)
    try? context?.save()
    selected = next.id
  }
  func removeBoard() {
    if let board = selected {
      try? context?.delete(model: Board.self, where: #Predicate{ $0.id == board })
      try? context?.save()
      findBoardSelection()
    }
  }
  func findBoardSelection() {
    if boards.isEmpty {
      addBoard()
    } else {
      selected = boards.first?.id
    }
  }
}

//
//  Manager.swift
//  sticky
//
//  Created by figbert on 6/26/25.
//

import SwiftUI

@Observable
class Manager {
  var boards: [UUID: Board] = [:]
  var board: UUID?

  var note = Note()
  func reset() {
    note = Note()
  }

  func append(_ type: ManagerObject) {
    switch type {
    case .board:
      let add = Board(number: boards.count + 1)
      boards[add.id] = add
      board = add.id
    case .note:
      guard let board = board else { return }
      boards[board]?.notes.append(note)
    }
  }
  func remove(_ type: ManagerObject) {
    switch type {
    case .board:
      guard let id = board else { return }
      boards.removeValue(forKey: id)
      board = boards.keys.first
    case .note:
      return
    }
  }

  init() {
    let first = Board(number: 1)
    boards[first.id] = first
  }
}

@Observable
class Board: Identifiable {
  let id: UUID = UUID()
  var name: String = "My Board"
  var notes: [Note] = []

  init(number: Int) {
    name = "Board \(number)"
  }
}

@Observable
class Note: Identifiable {
  let id: UUID = UUID()
  var content: AttributedString = ""
  var color: Color = .padYellow
  var offset: CGSize = .zero

  init(_ content: AttributedString, color: Color) {
    self.content = content
    self.color = color
  }

  init(_ content: AttributedString) {
    self.content = content
  }

  init(_ color: Color) {
    self.color = color
  }

  init() {}
}

enum ManagerObject {
  case board, note
}

enum PadColor: CaseIterable {
  case yellow, blue, green, pink

  var color: Color {
    switch self {
    case .yellow: return .padYellow
    case .blue: return .padBlue
    case .green: return .padGreen
    case .pink: return .padPink
    }
  }
}

extension Color {
  static let padYellow = Color(.displayP3, red: 252/255, green: 244/255, blue: 167/255)
  static let padBlue = Color(.displayP3, red: 188/255, green: 242/255, blue: 253/255)
  static let padGreen = Color(.displayP3, red: 195/255, green: 253/255, blue: 170/255)
  static let padPink = Color(.displayP3, red: 246/255, green: 201/255, blue: 200/255)
}

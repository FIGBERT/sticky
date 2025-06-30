//
//  Manager.swift
//  sticky
//
//  Created by figbert on 6/26/25.
//

import SwiftUI

@Observable
class Manager {
  var notes: [Note] = []
  var note = Note()

  func append() {
    notes.append(note)
  }

  func remove() {
    notes.removeAll { $0.id == note.id }
  }

  func reset() {
    note = Note()
  }
}

@Observable
class Note: Identifiable {
  let id: UUID = UUID()
  var content: AttributedString = ""
  var color: Color = .padYellow

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

//
//  Model.swift
//  sticky
//
//  Created by figbert on 7/16/25.
//

import SwiftUI
import SwiftData

@Model
class Board: Identifiable {
  @Attribute(.unique) var name: String
  @Relationship(deleteRule: .cascade, inverse: \Note.board) var notes: [Note]

  init(number: Int) {
    name = "Board \(number)"
    notes = []
  }
}

@Model
class Note: Identifiable {
  var content: AttributedString
  var color: PadColor
  private var x: Double
  private var y: Double
  var board: Board?

  var offset: CGSize {
    get { .init(width: x, height: y) }
    set {
      x = newValue.width
      y = newValue.height
    }
  }

  init(_ clr: PadColor, parent: Board) {
    content = ""
    color = clr
    x = 0
    y = 0
    board = parent
  }

  convenience init(_ parent: Board) {
    self.init(.yellow, parent: parent)
  }
}

enum PadColor: CaseIterable, Codable {
  case yellow, blue, green, pink

  var value: Color {
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

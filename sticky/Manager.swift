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
  var selected: Board.ID? = nil
  var zapping: Bool = false
}

extension Array where Element: Board {
  subscript(id: Board.ID?) -> Board? {
    first { $0.id == id }
  }
}

//
//  Note.swift
//  sticky
//
//  Created by figbert on 6/19/25.
//

import SwiftUI

struct Note: Identifiable {
  let id: UUID = UUID()
  var content: String = ""
  var color: Color = .yellow
}

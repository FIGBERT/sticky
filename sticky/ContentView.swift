//
//  ContentView.swift
//  sticky
//
//  Created by figbert on 6/19/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
  @Environment(Manager.self) var manager

  var body: some View {
    ZStack {
      ForEach(manager.notes) { note in
        StickyEditor(note: note)
      }
    }
      .frame(minWidth: 1000, minHeight: 540)
      .padding()
  }
}

#Preview(windowStyle: .automatic) {
  ContentView()
    .environment(Manager())
}

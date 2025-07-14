//
//  ContentView.swift
//  sticky
//
//  Created by figbert on 6/19/25.
//

import SwiftUI

struct ContentView: View {
  @Environment(Manager.self) var manager

  var body: some View {
    ZStack {
      ForEach(manager.boards[manager.board ?? UUID()]?.notes ?? []) { note in
        StickyEditor(note: note)
      }
    }
      .frame(minWidth: 1000, minHeight: 540)
      .padding()
      .onAppear {
        if manager.board == nil {
          manager.board = manager.boards.keys.first
        }
      }
  }
}

#Preview(windowStyle: .automatic) {
  ContentView()
    .environment(Manager())
}

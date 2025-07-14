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
    VStack {
      StickyCreator()
        .environment(manager)

      Spacer()

      ZStack {
        ForEach(manager.boards[manager.board ?? UUID()]?.notes ?? []) { note in
          StickyEditor(note: note)
        }
      }

//      This button should delete a board, or a note if you drag the note to it
//      if manager.boards.count > 1 {
//        Button {
//          manager.remove(.board)
//        } label: {
//          Label("Delete", systemImage: "trash")
//        }
//      }
    }
      .frame(minWidth: 1000)
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

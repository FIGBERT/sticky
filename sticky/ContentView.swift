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
      BoardBar()
        .padding()

      Spacer()

      StickyCreator()
        .environment(manager)

      Spacer()

      ZStack {
        ForEach(manager.boards[manager.board ?? UUID()]?.notes ?? []) { note in
          StickyEditor(note: note)
        }
      }
    }
      .padding()
      .onAppear {
        if manager.board == nil {
          manager.board = manager.boards.keys.first
        }
      }
  }
}

struct BoardBar: View {
  @Environment(Manager.self) var manager: Manager
  @State private var editing = false

  var name: Binding<String> {
    Binding<String>(
      get: {
        guard let uuid = manager.board else {
          return "PLACEHOLDER"
        }
        guard let board = manager.boards[uuid] else {
          return "PLACEHOLDER"
        }
        return board.name
      }, set: { update in
        guard let uuid = manager.board else {
          return
        }
        guard let board = manager.boards[uuid] else {
          return
        }
        board.name = update
      }
    )
  }
  var board: Binding<UUID> {
    Binding<UUID>(
      get: {
        guard let uuid = manager.board else {
          return UUID()
        }
        return uuid
      }, set: { update in
        manager.board = update
      }
    )
  }

  var body: some View {
    HStack {
      if !editing {
        Picker("Board", selection: board) {
          ForEach(Array(manager.boards.values)) { board in
            Text(board.name).tag(board.id)
          }
        }
      } else {
        TextField("My Board", text: name)
          .onSubmit {
            editing = false
          }
          .font(.title)
      }

      Spacer()

      Button {
        editing.toggle()
      } label: {
        Label(editing ? "Done" : "Edit", systemImage: editing ? "checkmark" : "pencil")
      }

      Button {
        manager.append(.board)
      } label: {
        Label("Create", systemImage: "plus")
      }

      if manager.boards.count > 1 {
        Button {
          manager.remove(.board)
        } label: {
          Label("Delete", systemImage: "trash")
        }
      }
    }
  }
}

#Preview(windowStyle: .automatic) {
  ContentView()
    .environment(Manager())
}

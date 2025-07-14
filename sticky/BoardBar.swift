//
//  BoardBar.swift
//  sticky
//
//  Created by figbert on 7/13/25.
//

import SwiftUI

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
          ForEach(Array(manager.boards.values.sorted(by: { $0.name < $1.name }))) { board in
            Text(board.name).tag(board.id)
          }
        }
      } else {
        TextField("My Board", text: name)
          .padding(.leading)
          .onSubmit {
            editing = false
          }
      }

      Spacer()

      Button {
        editing.toggle()
      } label: {
        Label(editing ? "Save Name" : "Edit Name", systemImage: editing ? "checkmark" : "pencil")
      }

      Button {
        manager.append(.board)
      } label: {
        Label("New Board", systemImage: "plus")
      }
    }
  }
}

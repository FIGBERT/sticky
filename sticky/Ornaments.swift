//
//  Ornaments.swift
//  sticky
//
//  Created by figbert on 7/13/25.
//

import SwiftUI
import SwiftData

struct BoardBar: View {
  @Environment(Manager.self) var manager

  @State private var editing = false
  @State private var name = ""

  var board: Binding<Board.ID?>{
    Binding<Board.ID?>(
      get: { manager.selected },
      set: { newVal in
        manager.selected = newVal
      }
    )
  }

  var body: some View {
    HStack {
      if !editing {
        Picker("Board", selection: board) {
          ForEach(manager.boards) { board in
            Text(board.name).tag(Optional(board.id))
          }
        }
      } else {
        TextField("Board", text: $name)
          .padding(.leading)
          .onSubmit {
            manager.board?.name = name
            editing = false
          }
      }

      Spacer()

      Button {
        if editing {
          manager.board?.name = name
        } else {
          name = manager.board?.name ?? ""
        }
        editing.toggle()
      } label: {
        Label(editing ? "Save Name" : "Edit Name", systemImage: editing ? "checkmark" : "pencil")
      }

      Button {
        manager.addBoard()
      } label: {
        Label("New Board", systemImage: "plus")
      }
    }
  }
}

struct DeleteBoardButton: View {
  @Environment(Manager.self) var manager

  var body: some View {
    Button {
      manager.removeBoard()
    } label: {
      Label("Delete", systemImage: "trash")
        .labelStyle(.iconOnly)
    }
  }
}

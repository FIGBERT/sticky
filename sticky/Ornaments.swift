//
//  Ornaments.swift
//  sticky
//
//  Created by figbert on 7/13/25.
//

import SwiftUI
import SwiftData
import WidgetKit

struct BoardBar: View {
  @Environment(\.modelContext) var context
  @Environment(Manager.self) var manager

  @Query(sort: \Board.name, order: .forward) var boards: [Board]

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
          ForEach(boards) { board in
            Text(board.name).tag(Optional(board.id))
          }
        }
      } else {
        TextField("Board", text: $name)
          .padding(.leading)
          .onSubmit {
            boards[manager.selected]?.name = name
            editing = false
          }
      }

      Spacer()

      Button {
        if editing {
          boards[manager.selected]?.name = name
        } else {
          name = boards[manager.selected]?.name ?? ""
        }
        editing.toggle()
      } label: {
        Label(editing ? "Save Name" : "Edit Name", systemImage: editing ? "checkmark" : "pencil")
      }

      Button {
        let next = Board(number: boards.count+1)
        context.insert(next)
        try? context.save()
        manager.selected = next.id
        WidgetCenter.shared.reloadAllTimelines()
      } label: {
        Label("New Board", systemImage: "plus")
      }
    }
  }
}

struct DeleteBoardButton: View {
  @Environment(\.modelContext) var context
  @Environment(Manager.self) var manager

  @Query(sort: \Board.name, order: .forward) var boards: [Board]

  var body: some View {
    Button {
      if let selected = manager.selected {
        try? context.delete(model: Board.self, where: #Predicate { $0.id == selected })
        try? context.save()
        manager.selected = boards.first?.id
        WidgetCenter.shared.reloadAllTimelines()
      }
    } label: {
      Label("Delete", systemImage: "trash")
        .labelStyle(.iconOnly)
    }
  }
}

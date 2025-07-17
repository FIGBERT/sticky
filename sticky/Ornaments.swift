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

  var shouldShowDeleteButton: Bool {
    boards.count > 1
  }

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
          .fixedSize(horizontal: false, vertical: true)
      } else {
        TextField("Board", text: $name)
          .padding(.leading)
          .onSubmit {
            boards[manager.selected]?.name = name
            try? context.save()
            WidgetCenter.shared.reloadAllTimelines()
            editing = false
          }
      }

      Spacer()

      Button {
        if editing {
          boards[manager.selected]?.name = name
          try? context.save()
          WidgetCenter.shared.reloadAllTimelines()
        } else {
          name = boards[manager.selected]?.name ?? ""
        }
        editing.toggle()
      } label: {
        Label(editing ? "Save Name" : "Edit Name", systemImage: editing ? "checkmark" : "pencil")
      }

      if shouldShowDeleteButton {
        Button {
          if let selected = manager.selected {
            try? context.delete(model: Board.self, where: #Predicate { $0.id == selected })
            try? context.save()
            manager.selected = boards.first?.id
            WidgetCenter.shared.reloadAllTimelines()
          }
        } label: {
          Label("Delete Board", systemImage: "trash")
        }
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
      .animation(.smooth, value: shouldShowDeleteButton)
  }
}

struct BoardSizePicker: View {
  @Environment(\.modelContext) var context
  @Environment(Manager.self) var manager

  @Query(sort: \Board.name, order: .forward) var boards: [Board]

  var body: some View {
    VStack {
      ForEach(BoardSize.allCases, id: \.self) { size in
        // The lack of conditional buttonStyles is frankly apalling
        if boards[manager.selected]?.size == size {
          Button {
            boards[manager.selected]?.size = size
            try? context.save()
            WidgetCenter.shared.reloadAllTimelines()
          } label: {
            Label(size.name, systemImage: size.icon)
              .labelStyle(.iconOnly)
          }
            .buttonStyle(.bordered)
        } else {
          Button {
            boards[manager.selected]?.size = size
            try? context.save()
            WidgetCenter.shared.reloadAllTimelines()
          } label: {
            Label(size.name, systemImage: size.icon)
              .labelStyle(.iconOnly)
          }
            .buttonStyle(.borderless)
        }
      }
    }
  }
}

//
//  ContentView.swift
//  sticky
//
//  Created by figbert on 6/19/25.
//

import SwiftUI
import SwiftData
import WidgetKit

struct ContentView: View {
  @Environment(\.modelContext) var context
  @Environment(Manager.self) var manager

  @Query(sort: \Board.name, order: .forward) var boards: [Board]
  @Query var allNotes: [Note]

  var notes: [Note] {
    guard let selected = manager.selected else { return [] }
    return allNotes.filter { $0.board?.id == selected }
  }

  var body: some View {
    ZStack {
      ForEach(notes) { note in
        StickyEditor(note: note)
          .environment(manager)
          .modelContext(context)
      }
    }
      .frame(width: boards[manager.selected]?.size.width, height: boards[manager.selected]?.size.height)
      .padding()
      .ornament(attachmentAnchor: .scene(.top)) {
        BoardBar()
          .environment(manager)
          .modelContext(context)
          .frame(minWidth: 800)
          .padding()
          .glassBackgroundEffect()
      }
      .ornament(attachmentAnchor: .scene(.leading)) {
        StickyCreator()
          .environment(manager)
          .modelContext(context)
          .padding()
          .glassBackgroundEffect()
      }
      .ornament(attachmentAnchor: .scene(.trailing)) {
        BoardSizePicker()
          .environment(manager)
          .modelContext(context)
          .padding()
          .glassBackgroundEffect()
      }
      .onAppear {
        if manager.selected == nil {
          if boards.isEmpty {
            let next = Board(number: boards.count+1)
            context.insert(next)
            try? context.save()
            manager.selected = next.id
            WidgetCenter.shared.reloadAllTimelines()
          } else {
            manager.selected = boards.first?.id
          }
        }
      }
  }
}

#Preview(windowStyle: .automatic) {
  ContentView()
    .environment(Manager())
}

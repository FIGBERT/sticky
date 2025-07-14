//
//  stickyApp.swift
//  sticky
//
//  Created by figbert on 6/19/25.
//

import SwiftUI

@main
struct stickyApp: App {
  @State private var manager = Manager()

  var showDeleteBoard: Visibility {
    if manager.boards.count > 1 {
      return .visible
    }
    return .hidden
  }

  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(manager)
        .ornament(attachmentAnchor: .scene(.top)) {
          BoardBar()
            .environment(manager)
            .frame(minWidth: 800)
            .padding()
            .glassBackgroundEffect()
        }
        .ornament(visibility: showDeleteBoard, attachmentAnchor: .scene(.bottomTrailing)) {
          Button {
            manager.remove(.board)
          } label: {
            Label("Delete", systemImage: "trash")
              .labelStyle(.iconOnly)
          }
            .glassBackgroundEffect()
        }
    }
      .windowResizability(.contentMinSize)
  }
}

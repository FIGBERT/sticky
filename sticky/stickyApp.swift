//
//  stickyApp.swift
//  sticky
//
//  Created by figbert on 6/19/25.
//

import SwiftUI
import SwiftData

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
        .onAppear {
          if manager.selected == nil {
            manager.findBoardSelection()
          }
        }
        .ornament(attachmentAnchor: .scene(.top)) {
          BoardBar()
            .environment(manager)
            .frame(minWidth: 800)
            .padding()
            .glassBackgroundEffect()
        }
        .ornament(attachmentAnchor: .scene(.leading)) {
          StickyCreator()
            .environment(manager)
            .padding()
            .glassBackgroundEffect()
        }
        .ornament(visibility: showDeleteBoard, attachmentAnchor: .scene(.bottomTrailing)) {
          DeleteBoardButton()
            .environment(manager)
            .glassBackgroundEffect()
        }
    }
      .windowResizability(.contentMinSize)
  }
}

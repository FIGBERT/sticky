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

  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(manager)
    }
  }
}

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
      Text("Stickies!")
        .font(.title)
        .padding(.bottom)

      StickyCreator()
        .environment(manager)
        .padding(.bottom)

      ZStack {
        ForEach(manager.notes) { note in
          StickyEditor(note: note)
        }
      }
    }
      .padding()
  }
}

#Preview(windowStyle: .automatic) {
  ContentView()
    .environment(Manager())
}

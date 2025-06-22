//
//  ContentView.swift
//  sticky
//
//  Created by figbert on 6/19/25.
//

import SwiftUI

struct ContentView: View {
  @State private var notes: [Note] = []

  var body: some View {
    VStack {
      Text("Stickies!")
        .font(.title)
    }
      .padding()
  }
}

#Preview(windowStyle: .automatic) {
  ContentView()
}

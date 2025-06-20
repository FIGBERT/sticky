//
//  ContentView.swift
//  sticky
//
//  Created by figbert on 6/19/25.
//

import SwiftUI

struct ContentView: View {
  @State private var notes: [Note] = []
  @State private var noteBuilder = Note()

  var body: some View {
    VStack {
      Text("Stickies!")
        .font(.title)

      ForEach(notes) { note in
        Text(note.content)
          .foregroundStyle(note.color)
          .bold()
      }

      HStack {
        TextField("content", text: $noteBuilder.content)
          .frame(maxWidth: 80)
        ColorPicker("paper", selection: $noteBuilder.color)
          .labelsHidden()

        Button {
          notes.append(noteBuilder)
          noteBuilder = Note()
        } label: {
          Text("hi")
        }
      }
    }
      .padding()
  }
}

struct Note: Identifiable {
  let id: UUID = UUID()
  var content: String = ""
  var color: Color = .yellow
}

#Preview(windowStyle: .automatic) {
  ContentView()
}

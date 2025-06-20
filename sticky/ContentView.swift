//
//  ContentView.swift
//  sticky
//
//  Created by figbert on 6/19/25.
//

import SwiftUI

struct ContentView: View {
  @State private var notes: [Note] = []
  @State private var builder = Note()

  var body: some View {
    VStack {
      Text("Stickies!")
        .font(.title)

      ForEach(notes) { note in
        StickyView(note: note)
          .onTapGesture {
            builder = note
            notes.removeAll(where: { $0.id == note.id })
          }
      }

      HStack {
        TextField("Content", text: $builder.content)
          .frame(maxWidth: 80)
        ColorPicker("Paper", selection: $builder.color)
          .labelsHidden()

        Button {
          notes.append(builder)
          builder = Note()
        } label: {
          Text("Add")
        }
      }
    }
      .padding()
  }
}

#Preview(windowStyle: .automatic) {
  ContentView()
}

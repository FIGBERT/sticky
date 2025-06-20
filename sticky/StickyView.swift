//
//  StickyView.swift
//  sticky
//
//  Created by figbert on 6/19/25.
//

import SwiftUI

struct StickyView: View {
  let note: Note

  var body: some View {
    Rectangle()
      .aspectRatio(1, contentMode: .fit)
      .foregroundStyle(note.color)
      .overlay {
        Text(note.content)
          .foregroundStyle(.black)
          .fontWeight(.regular)
      }
      .frame(maxWidth: 180)
  }
}

#Preview {
  StickyView(note: Note(content: "Hello, world!", color: .yellow))
}

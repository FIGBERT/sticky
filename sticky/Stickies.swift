//
//  Stickies.swift
//  sticky
//
//  Created by figbert on 6/19/25.
//

import SwiftUI

@Observable
class Note: Identifiable {
  let id: UUID = UUID()
  var content: AttributedString = ""
  var color: Color = .yellow

  init(_ content: AttributedString, color: Color) {
    self.content = content
    self.color = color
  }

  init(_ content: AttributedString) {
    self.content = content
  }
}

struct StickyView: View {
  var note: Note

  var body: some View {
    Text(note.content)
      .padding()
      .frame(minWidth: 180, maxWidth: 180, minHeight: 180, alignment: .top)
      .background(note.color)
  }
}

struct StickyEditor: View {
  @Bindable var note: Note

  var body: some View {
    TextEditor(text: $note.content)
      .padding()
      .attributedTextFormattingDefinition(StickyFormattingDefintion())
      .frame(width: 180, height: 180)
      .background(note.color)
  }
}

struct StickyFormattingDefintion: AttributedTextFormattingDefinition {
  struct Scope: AttributeScope {
    let font: AttributeScopes.SwiftUIAttributes.FontAttribute
    let foregroundColor: AttributeScopes.SwiftUIAttributes.ForegroundColorAttribute
    let alignment: AttributeScopes.CoreTextAttributes.TextAlignmentAttribute
  }

  var body: some AttributedTextFormattingDefinition<Scope> {
    ValueConstraint(for: \.foregroundColor, values: [.black], default: .black)
    ValueConstraint(for: \.alignment, values: [.center], default: .center)
  }
}

#Preview {
  var str = AttributedString("Hello, world!")
  str.foregroundColor = .black
  str.alignment = .center

  return StickyView(note: Note(str, color: .teal))
}

#Preview {
  StickyEditor(note: Note(AttributedString("Hello, world!")))
}

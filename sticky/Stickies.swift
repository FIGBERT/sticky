//
//  Stickies.swift
//  sticky
//
//  Created by figbert on 6/19/25.
//

import SwiftUI
import SwiftData

struct StickyView: View {
  var note: Note

  var body: some View {
    Text(note.content)
      .padding()
      .frame(minWidth: 180, maxWidth: 180, minHeight: 180, alignment: .top)
      .background(note.color.value)
  }
}

struct StickyEditor: View {
  @Bindable var note: Note
  @GestureState private var offset: CGSize = .zero

  var body: some View {
    TextEditor(text: $note.content)
      .padding()
      .attributedTextFormattingDefinition(StickyFormattingDefintion())
      .frame(width: 180, height: 180)
      .background(note.color.value)
      .offset(CGSize(width: note.offset.width + offset.width, height: note.offset.height + offset.height))
      .gesture(
        DragGesture()
          .updating($offset) { value, state, _ in
            state = value.translation
          }
          .onEnded { value in
            note.offset.width += value.translation.width
            note.offset.height += value.translation.height
          }
      )
  }
}

struct StickyCreator: View {
  @Environment(Manager.self) var manager

  @State private var color: PadColor = .yellow

  var body: some View {
    VStack {
      Button {
        manager.addNote(color)
      } label: {
        Label("New Sticky", systemImage: "paintbrush.pointed.fill")
          .labelStyle(.iconOnly)
      }

      ForEach(PadColor.allCases, id: \.self) { pad in
        Rectangle()
          .foregroundStyle(pad.value)
          .frame(width: 45, height: 45)
          .border(pad == color ? Color.primary : Color.clear, width: 4)
          .onTapGesture {
            color = pad
          }
      }
    }
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
  StickyCreator()
    .environment(Manager())
}

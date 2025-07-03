//
//  Stickies.swift
//  sticky
//
//  Created by figbert on 6/19/25.
//

import SwiftUI

struct StickyView: View {
  var note: Note

  var body: some View {
    Text(note.content)
      .padding()
      .frame(minWidth: 180, maxWidth: 180, minHeight: 180, alignment: .top)
      .background(note.color)
  }
}

struct StickyCreator: View {
  @Environment(Manager.self) var manager

  var body: some View {
    HStack(alignment: .top) {
      VStack {
        StickyEditor(note: manager.note)

        Button {
          manager.append()
          manager.reset()
        } label: {
          Text("Create")
        }
      }

      ColorPicker(note: manager.note)
    }
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
      .background(note.color)
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

struct ColorPicker: View {
  @Bindable var note: Note

  var body: some View {
    VStack(spacing: 0) {
      ForEach(PadColor.allCases, id: \.self) { pad in
        Button {
          note.color = pad.color
        } label: {
          Rectangle()
            .foregroundStyle(pad.color)
            .frame(width: 45, height: 45)
            .border(pad.color == note.color ? Color.primary : Color.clear, width: 4)
        }
          .buttonStyle(.plain)
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
  var str = AttributedString("Hello, static!")
  str.foregroundColor = .black
  str.alignment = .center

  return StickyView(note: Note(str, color: .padBlue))
}

#Preview {
  StickyEditor(note: Note(AttributedString("Hello, editable!")))
    .environment(Manager())
}

#Preview {
  StickyCreator()
    .environment(Manager())
}

//
//  widget.swift
//  widget
//
//  Created by figbert on 7/17/25.
//

import SwiftUI
import SwiftData
import WidgetKit

struct BoardEntry: TimelineEntry {
  let date: Date
  let configuration: ConfigurationAppIntent
}

struct Provider: AppIntentTimelineProvider {
  func placeholder(in context: Context) -> BoardEntry {
    BoardEntry(date: Date(), configuration: ConfigurationAppIntent())
  }

  func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> BoardEntry {
    BoardEntry(date: Date(), configuration: configuration)
  }

  func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<BoardEntry> {
    return Timeline(entries: [BoardEntry(date: Date(), configuration: configuration)], policy: .never)
  }
}

struct widgetView : View {
  @Environment(\.levelOfDetail) var levelOfDetail: LevelOfDetail
  @Environment(\.widgetFamily) var family
  @Query var allNotes: [Note]

  var entry: Provider.Entry
  var notes: [Note] {
    allNotes.filter { $0.board?.name == entry.configuration.selected?.id }
  }

  var matching: Bool {
    switch entry.configuration.selected?.type.family {
    case family:
      return true
    // There is an issue presently where systemExtraLargePortrait
    // registers as systemLarge on device, but is not supported for
    // visionOS in code (this despite the documentation claiming that
    // all system sizes are supported on the platform).
    case .systemExtraLargePortrait:
      return true
    default:
      return false
    }
  }

  var body: some View {
    ZStack {
      if matching {
        ForEach(notes) { note in
          Rectangle()
            .fill(note.color.value)
            .frame(width: 45, height: 45)
            .overlay {
              switch levelOfDetail {
              case .default:
                Text(note.content)
                  .minimumScaleFactor(0.01)
                  .padding(8)
              default:
                Image(systemName: "scribble.variable")
              }
            }
            .offset(CGSize(width: note.offset.width/4, height: note.offset.height/4))
        }
      } else {
        Text("Try Again: Board Dimensions Don't Match Widget Type")
          .font(.caption)
          .opacity(0.3)
      }
    }
  }
}

@main
struct widget: Widget {
  let kind: String = "widget"

  var body: some WidgetConfiguration {
    AppIntentConfiguration(kind: kind,
                           intent: ConfigurationAppIntent.self,
                           provider: Provider()) { entry in
      widgetView(entry: entry)
        .modelContainer(for: [Board.self, Note.self])
    }
      .supportedFamilies([.systemSmall, .systemMedium, .systemExtraLargePortrait])
      .widgetTexture(.paper)
  }
}

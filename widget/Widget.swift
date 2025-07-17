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

  var body: some View {
    ZStack {
      Text(entry.configuration.selected?.id ?? "No Board, Oops")
        .font(.caption)
        .opacity(0.5)

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
//          .offset(CGSize(width: note.offset.width, height: note.offset.height))
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

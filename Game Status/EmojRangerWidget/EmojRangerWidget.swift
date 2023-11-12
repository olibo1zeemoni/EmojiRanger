//
//  EmojiRangerWidget.swift
//  EmojiRangerWidget
//
//  Created by Olibo moni on 10/11/2023.
//  Copyright © 2023 Apple. All rights reserved.
//

import WidgetKit
import SwiftUI

struct Provider: IntentTimelineProvider {
    typealias Entry = SimpleEntry
    
 
//    func character(for configuration: DynamicCharacterSelectionIntent) -> CharacterDetail {
//        switch configuration.hero {
//            
//        case .panda:
//            return .panda
//        case .egghead:
//            return .egghead
//        case .spouty:
//            return .spouty
//        default:
//           return .panda
//        }
//    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), character: .panda, relevance: nil)
    }

   public func getSnapshot(for configuration: DynamicCharacterSelectionIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), character: .panda, relevance: nil)
        completion(entry)
    }

     public func getTimeline(for configuration: DynamicCharacterSelectionIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
         let selectedCharacter = CharacterDetail.characterFromName(name: configuration.hero?.identifier)
         let endDate = selectedCharacter.fullHealthDate
         let oneMinute: TimeInterval = 60
         var currentDate = Date()
         
        var entries: [SimpleEntry] = []
         while currentDate < endDate {
             let relevance = TimelineEntryRelevance(score: Float(selectedCharacter.healthLevel))
             let entry = SimpleEntry(date: currentDate, character: selectedCharacter, relevance: relevance)
             currentDate += oneMinute
             entries.append(entry)
         }
         

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let character: CharacterDetail
    let relevance: TimelineEntryRelevance??
}

struct EmojiRangerWidgetEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var family
        @ViewBuilder
    var body: some View {
        switch family {
        case .systemSmall:
            ZStack {
                AvatarView(entry.character)
                    .foregroundStyle(.white)
            }
            .background(Color.gameBackground)
            .widgetURL(entry.character.url)
        default:
            ZStack {
                HStack(alignment: .top) {
                    AvatarView(entry.character)
                        .foregroundStyle(.white)
                    Text(entry.character.bio)
                        .padding()
                        .foregroundStyle(.white)
                }
                .padding()
                .widgetURL(entry.character.url)
            }
            .background(Color.gameBackground)
            .widgetURL(entry.character.url)
        }
    }
}

struct EmojiRangerWidget: Widget {
    let kind: String = "EmojiRangerWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: DynamicCharacterSelectionIntent.self, provider: Provider()) { entry in
//            if #available(iOS 17.0, *) {
                EmojiRangerWidgetEntryView(entry: entry)
                    .containerBackground(Color.gameBackground, for: .widget)
//            } else {
//                EmojiRangerWidgetEntryView(entry: entry)
//                    .padding()
//                    .background(Color.gameBackground)
//            }
        }
        .configurationDisplayName("Emoji Ranger Detail")
        .description("Keep track of your favorite emoji")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}


//MARK: - preview 

struct WidgetViewPreviews: PreviewProvider {

  static var previews: some View {
    Group {
        EmojiRangerWidgetEntryView(entry: SimpleEntry(date: Date(), character: .panda, relevance: nil))
            .containerBackground(Color.gameBackground, for: .widget)
    }
    .previewContext(WidgetPreviewContext(family: .systemSmall))
  }
}


extension View {
     func widgetBackground() -> some View {
         if #available(iOSApplicationExtension 17.0, *) {
             return containerBackground(for: .widget) {
                 Color.gameBackground
             }
         } else {
             return background {
                 Color.gameBackground
             }
         }
    }
}

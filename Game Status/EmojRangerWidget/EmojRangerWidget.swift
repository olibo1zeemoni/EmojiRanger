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
    
 
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), character: .panda, relevance: nil)
    }

   public func getSnapshot(for configuration: DynamicCharacterSelectionIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), character: .panda, relevance: nil)
        completion(entry)
    }

     public func getTimeline(for configuration: DynamicCharacterSelectionIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
         let selectedCharacter = CharacterDetail.characterFromName(name: configuration.hero?.identifier) ?? CharacterDetail.panda
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
        case .accessoryCircular:
            ProgressView(timerInterval: entry.character.injuryDate...entry.character.fullHealthDate,
                         countsDown: false,
                         label: { Text(entry.character.name) },
                         currentValueLabel: {
                Avatar(character: entry.character)
            })
            .progressViewStyle(.circular)
        case .accessoryInline:
            ViewThatFits {
                Text("\(entry.character.name) is healing, ready in \(entry.character.fullHealthDate, style: .relative)")
                Text("\(entry.character.name) ready in \(entry.character.fullHealthDate, style: .relative)")
                Text("\(entry.character.name) \(entry.character.fullHealthDate, style: .timer)")
            }
            .widgetURL(entry.character.url)
            .background(Color.gameBackground)
        case .systemSmall:
            ZStack {
                AvatarView(entry.character)
                    .foregroundStyle(.white)
                    .contentTransition(.numericText(value: entry.date.timeIntervalSince1970))
            }
            .background(Color.gameBackground)
            .widgetURL(entry.character.url)
        case . systemLarge:
            VStack {
                HStack(alignment: .top) {
                    AvatarView(entry.character)
                        .foregroundColor(.white)
                    Text(entry.character.bio)
                        .foregroundColor(.white)
                }
                .padding()
                if #available(iOSApplicationExtension 17.0, *) {
                    Button(intent: SuperCharge()) {
                        Text("⚡️")
                            .lineLimit(1)
                    }
                }
            }
            
        default:
            ZStack {
                HStack(alignment: .top) {
                    AvatarView(entry.character)
                        .foregroundStyle(.white)
                        .contentTransition(.numericText(countsDown: true))
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
    
    func rotateArray(someArray: [Int], times: Int) -> [Int] {
         guard !someArray.isEmpty else { return [] }
         guard times > 0 else { return someArray }
         var array = someArray
         for i in 0..<times {
             let element = array[i]
             array.remove(at: i)
             array.append(element)
         }
         return array
     }
    
}

struct EmojiRangerWidget: Widget {
    let kind: String = "EmojiRangerWidget"

    var body: some WidgetConfiguration {
        ///Dynamic configuration Widget.
        IntentConfiguration(kind: kind, intent: DynamicCharacterSelectionIntent.self, provider: Provider()) { entry in
                EmojiRangerWidgetEntryView(entry: entry)
                    .containerBackground(Color.gameBackground, for: .widget)
        }
        .configurationDisplayName("Emoji Ranger Detail")
        .description("Keep track of your favorite emoji")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge, .accessoryInline, .accessoryCircular])
        
    }
    
   
    
}


//MARK: - preview 

//struct WidgetViewPreviews: PreviewProvider {
//
//  static var previews: some View {
//    Group {
//        EmojiRangerWidgetEntryView(entry: SimpleEntry(date: Date(), character: .panda, relevance: nil))
//            .containerBackground(Color.gameBackground, for: .widget)
//    }
//    .previewContext(WidgetPreviewContext(family: .systemSmall))
//  }
//}


#Preview(as: WidgetFamily.accessoryCircular, widget: {
    EmojiRangerWidget()
}, timeline: {
    SimpleEntry(date: Date(), character: .panda, relevance: nil)
    SimpleEntry(date: Date(), character: .octo, relevance: nil)
})

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

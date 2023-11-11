//
//  LeaderBoardWidget.swift
//  EmojRangerWidgetExtension
//
//  Created by Olibo moni on 11/11/2023.
//  Copyright © 2023 Apple. All rights reserved.
//


import WidgetKit
import SwiftUI

struct LeaderboardProvider: TimelineProvider {
    
    public typealias Entry = LeaderboardEntry
    
    func placeholder(in context: Context) -> LeaderboardEntry {
        return LeaderboardEntry(date: Date(), heros: CharacterDetail.availableCharacters)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (LeaderboardEntry) -> Void) {
        let entry = LeaderboardEntry(date: Date(), heros: CharacterDetail.availableCharacters)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<LeaderboardEntry>) -> Void) {
        CharacterDetail.loadLeaderboardData { (heros, error) in
            guard let heros = heros else {
                let timeline = Timeline(entries: [LeaderboardEntry(date: Date(), heros: CharacterDetail.availableCharacters)], policy: .atEnd)
                
                completion(timeline)
                
                return
            }
            let timeline = Timeline(entries: [LeaderboardEntry(date: Date(), heros: heros)], policy: .atEnd)
            completion(timeline)
        }
    }
}

struct LeaderboardEntry: TimelineEntry {
    public let date: Date
    var heros: [CharacterDetail]?
}

struct LeaderboardPlaceholderView: View {
    var body: some View {
        LeaderboardWidgetEntryView(entry: LeaderboardEntry(date: Date(), heros: nil))
    }
}

struct LeaderboardWidgetEntryView: View {
    var entry: LeaderboardProvider.Entry
    
    var body: some View {
        AllCharactersView(characters: entry.heros)
            .padding()
            .widgetBackground()
    }
}

struct LeaderboardWidget: Widget {
    
    private static var supportedFamilies: [WidgetFamily] {
            return [.systemLarge, .systemExtraLarge]
        

    }
    
    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: CharacterDetail.LeaderboardWidgetKind, provider: LeaderboardProvider()) { entry in
            LeaderboardWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Ranger Leaderboard")
        .description("See all the rangers.")
        .supportedFamilies(LeaderboardWidget.supportedFamilies)
    }
}

struct LeaderboardWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LeaderboardWidgetEntryView(entry: LeaderboardEntry(date: Date(), heros: nil))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}


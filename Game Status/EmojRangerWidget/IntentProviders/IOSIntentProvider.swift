//
//  IOSIntentProvider.swift
//  EmojRangerWidgetExtension
//
//  Created by Olibo moni on 12/11/2023.
//  Copyright © 2023 Apple. All rights reserved.
//



import SwiftUI
import WidgetKit

struct SiriKitIntentProvider: IntentTimelineProvider {
    
    typealias Intent = DynamicCharacterSelectionIntent
    
    public typealias Entry = SimpleEntry
    
    func recommendations() -> [IntentRecommendation<DynamicCharacterSelectionIntent>] {
        return recommendedIntents()
            .map { intent in
                return IntentRecommendation(intent: intent, description: intent.intentDescription ?? "Spouty")
            }
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), character: .cake, relevance: nil)
    }
    
    func getSnapshot(for configuration: DynamicCharacterSelectionIntent, in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), character: .cake, relevance: nil)
        completion(entry)
    }
    
    func getTimeline(for configuration: DynamicCharacterSelectionIntent, in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        let selectedCharacter = hero(for: configuration)
        let endDate = selectedCharacter.fullHealthDate
        let oneMinute: TimeInterval = 60
        var currentDate = Date()
        var entries: [SimpleEntry] = []
        
        while currentDate < endDate {
            let relevance = TimelineEntryRelevance(score: Float(selectedCharacter.healthLevel))
            let entry = SimpleEntry(date: Date(), character: .cake, relevance: relevance)
            
            currentDate += oneMinute
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        
        completion(timeline)
    }
    
    func hero(for configuration: DynamicCharacterSelectionIntent) -> CharacterDetail {
        if let name = configuration.identifier {
            // Save the most recently selected hero to the app group.
            CharacterDetail.setLastSelectedCharacter(heroName: name)
            return CharacterDetail.characterFromName(name: name) ?? CharacterDetail.panda
        }
        return .spouty
    }
    
    private func recommendedIntents() -> [DynamicCharacterSelectionIntent] {
        return CharacterDetail.availableCharacters
            .map { hero in
                let intent = DynamicCharacterSelectionIntent()
                return intent
                
            }
    }
}



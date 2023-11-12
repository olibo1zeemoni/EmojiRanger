//
//  IntentHandler.swift
//  EmojiRangerIntentsHandler
//
//  Created by Olibo moni on 12/11/2023.
//  Copyright © 2023 Apple. All rights reserved.
//

import Intents

class IntentHandler: INExtension, DynamicCharacterSelectionIntentHandling {
 
    
    
    func provideHeroOptionsCollection(for intent: DynamicCharacterSelectionIntent, with completion: @escaping (INObjectCollection<Hero>?, Error?) -> Void) {
        let characters: [Hero] = CharacterDetail.availableCharacters.map { character in
            let hero = Hero(identifier: character.name, display: character.name)
            return hero
        }
        
        let remoteCharacters: [Hero] = CharacterDetail.remoteCharacters.map { character in
            let hero = Hero(identifier: character.name, display: character.name)
            return hero
        }
        
        
        let collection = INObjectCollection(items: characters + remoteCharacters)
        completion(collection, nil)
    }
    
    
    
//    func provideHeroOptionsCollection(for intent: DynamicCharacterSelectionIntent) async throws -> INObjectCollection<Hero> {
//        <#code#>
//    }
    
    
    
    
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
    
}

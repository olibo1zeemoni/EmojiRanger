//
//  SuperCharge.swift
//  Emoji Rangers
//
//  Created by Olibo moni on 13/11/2023.
//  Copyright © 2023 Apple. All rights reserved.
//

import Foundation
import AppIntents
import WidgetKit

@available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
struct SuperCharge: AppIntent {
    
    static var title: LocalizedStringResource = "Emoji Ranger SuperCharger"
    static var description = IntentDescription("All heroes get instant 100% health.")
    
    func perform() async throws -> some IntentResult {
        CharacterDetail.superchargeHeros()
        return .result()
    }
}

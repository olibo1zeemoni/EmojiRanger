//
//  EmojRangerWidgetBundle.swift
//  EmojRangerWidget
//
//  Created by Olibo moni on 10/11/2023.
//  Copyright © 2023 Apple. All rights reserved.
//

import WidgetKit
import SwiftUI

@main
struct EmojiRangerWidgetBundle: WidgetBundle {
    var body: some Widget {
        EmojiRangerWidget()
        LeaderboardWidget()
    }
}

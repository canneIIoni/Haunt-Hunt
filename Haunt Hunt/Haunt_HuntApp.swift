//
//  Haunt_HuntApp.swift
//  Haunt Hunt
//
//  Created by Luca on 12/05/23.
//

import SwiftUI

@main
struct Haunt_HuntApp: App {
    var body: some Scene {
        WindowGroup {
            PreviousView(entityToggle: false, investigatorToggle: false)
                .preferredColorScheme(.dark)
        }
    }
}

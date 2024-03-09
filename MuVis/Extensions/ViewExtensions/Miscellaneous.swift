/*
 Miscellaneous.swift
 MuVis

 Created by Treata Norouzi on 3/5/24.
 
 Abstract:
 General purpose extensions used in Views.
*/

import SwiftUI

extension View {
#if DEBUG
    /**
     A `debugging` helper method which injects the `ViewModels` of the app to the containing view and
     provides some other enhancements, useful while `previewing`.
     */
    func enhancedPreview(width: CGFloat = 400, heigth: CGFloat = 300, colorScheme: ColorScheme = .dark) -> some View {
        ZStack {
            // Provide a grayish background only for debuggin purposes...
            colorScheme == .dark ? Color.midnightGray.opacity(0.7) : Color.slateGray.opacity(0.3)
            self
        }
        // Injecting the ViewModels of the app
        .environmentObject(AudioManager.manager)
        .environmentObject(Settings.settings)
        
        // MARK: - Modifying the looks
        #if os(macOS)
        .frame(width: width, height: heigth)
        #endif
        .preferredColorScheme(colorScheme)
    }
#endif
}

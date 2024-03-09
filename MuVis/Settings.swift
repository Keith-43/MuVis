///  Settings.swift
///  MuVis
///
///  This class contains variables that the app's user gets to adjust - using the buttons and sliders provided in the user interface within the ContentView struct.
///  It also contans constants and variables that the app's developer has selected for optimum performance.
///
///  Created by Keith Bromley on 16 Feb 20/21.


import Foundation
import SwiftUI

@Observable
class Settings {

    static let settings = Settings()  // This singleton instantiates the Settings class

    let optionCount: Int = 8
    
    var option: Int = 0              // 0 <= option < 8
                                                // allows user to view variations on each visualization
                                                // Changed in ContentView; Published to all visualizations

}

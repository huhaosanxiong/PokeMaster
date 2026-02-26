//
//  ContentView.swift
//  PokeMaster
//
//  Created by huhsx on 2020/7/30.
//  Copyright © 2020 huhsx. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store
    
    var body: some View {
        MainTab()
            .preferredColorScheme(store.appState.settings.appAppearance.colorScheme)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

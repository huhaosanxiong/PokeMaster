//
//  Store.swift
//  PokeMaster
//
//  Created by huhsx on 2020/7/31.
//  Copyright © 2020 huhsx. All rights reserved.
//

import Foundation
import Combine

class Store: ObservableObject {
    
    @Published var appState = AppState()
}

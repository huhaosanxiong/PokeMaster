//
//  AppState.swift
//  PokeMaster
//
//  Created by huhsx on 2020/7/31.
//  Copyright © 2020 huhsx. All rights reserved.
//

import Foundation
import SwiftUI

struct AppState {
    
    var settings = Settings()
    var pokemonList = PokemonList()
}

extension AppState {
    struct PokemonList {
        var pokemons: [PokemonViewModel] = PokemonViewModel.all
        var searchText: String = ""
        var selectionState: SelectionState = .init()
    }
}

extension AppState.PokemonList {
    struct SelectionState {
        var expandingIndex: Int?
        var panelPresented = false
        var panelIndex: Int?
    }
    
    var displayPokemons: [PokemonViewModel] {
        func isFavorite(_ pokemon: PokemonViewModel) -> Bool {
            guard let appState = Store.shared?.appState else { return false }
            guard let user = appState.settings.loginUser else { return false }
            return user.isFavoritePokemon(id: pokemon.id)
        }
        
        var result = pokemons
        
        if !searchText.isEmpty {
            result = result.filter { pokemon in
                pokemon.name.contains(searchText) ||
                pokemon.nameEN.lowercased().contains(searchText.lowercased()) ||
                "\(pokemon.id)".contains(searchText)
            }
        }
        
        return result
    }
    
    func filteredAndSorted(
        showFavoriteOnly: Bool,
        sorting: AppState.Settings.Sorting,
        loginUser: User?
    ) -> [PokemonViewModel] {
        var result = displayPokemons
        
        if showFavoriteOnly {
            result = result.filter { pokemon in
                loginUser?.isFavoritePokemon(id: pokemon.id) ?? false
            }
        }
        
        switch sorting {
        case .id:
            result.sort { $0.id < $1.id }
        case .name:
            result.sort { $0.name < $1.name }
        case .color:
            result.sort { $0.color.description < $1.color.description }
        case .favorite:
            result.sort { pokemon1, pokemon2 in
                let isFav1 = loginUser?.isFavoritePokemon(id: pokemon1.id) ?? false
                let isFav2 = loginUser?.isFavoritePokemon(id: pokemon2.id) ?? false
                if isFav1 != isFav2 {
                    return isFav1
                }
                return pokemon1.id < pokemon2.id
            }
        }
        
        return result
    }
}

extension AppState {
    
    struct Settings {
        
        enum Sorting: CaseIterable {
            case id, name, color, favorite
        }
        
        enum AccountBehavior: CaseIterable {
            case register, login
        }
        
        enum AppAppearance: String, CaseIterable {
            case automatic = "跟随系统"
            case light = "浅色模式"
            case dark = "暗黑模式"
            
            var colorScheme: ColorScheme? {
                switch self {
                case .automatic: return nil
                case .light: return .light
                case .dark: return .dark
                }
            }
        }
        
        class AccountChecker {
            @Published var accountBehavior = AccountBehavior.login
            @Published var email = ""
            @Published var password = ""
            @Published var verifyPassword = ""
        }
        
        var checker = AccountChecker()
        
        @UserDefaultStorage(key: "showEnglishName")
        var showEnglishName: Bool
        
        @UserDefaultStorage(key: "appAppearance")
        var appAppearance: AppAppearance = .automatic
        
        var sorting = Sorting.id
        var showFavoriteOnly = false
        
        @FileStorage(directory: .documentDirectory, fileName: "user.json")
        var loginUser: User?
        
        var loginRequesting = false
        var loginError: AppError?
    }
    
    
}

//
//  PokemonList.swift
//  PokeMaster
//
//  Created by huhsx on 2020/7/30.
//  Copyright © 2020 huhsx. All rights reserved.
//

import SwiftUI

struct PokemonList: View {
    
    @EnvironmentObject var store: Store
    
    var pokemonListBinding: Binding<AppState.PokemonList> {
        $store.appState.pokemonList
    }
    
    var pokemonList: AppState.PokemonList {
        store.appState.pokemonList
    }
    
    var body: some View {
        
        ScrollView {
            TextField("搜索", text: pokemonListBinding.searchText)
                .frame(height: 40)
                .padding(.horizontal, 25)
            ForEach(
                pokemonList.filteredAndSorted(
                    showFavoriteOnly: store.appState.settings.showFavoriteOnly,
                    sorting: store.appState.settings.sorting,
                    loginUser: store.appState.settings.loginUser
                )
            ) { pokemon in
                PokemonInfoRow(
                    model: pokemon,
                    expanded: self.pokemonList.selectionState.expandingIndex == pokemon.id
                )
                .onTapGesture {
                    withAnimation(
                        .spring(response: 0.55, dampingFraction: 0.425, blendDuration: 0)
                    ){
                        self.store.dispatch(.toggleListSelection(index: pokemon.id))
                    }
                }
            }
        }
        .overlay(
            VStack {
                Spacer()
                if pokemonList.selectionState.panelPresented {
                    if let panelIndex = pokemonList.selectionState.panelIndex,
                       let pokemon = pokemonList.pokemons.first(where: { $0.id == panelIndex }) {
                        PokemonInfoPanel(model: pokemon)
                            .transition(.move(edge: .bottom))
                    }
                }
            }
            .edgesIgnoringSafeArea(.bottom)
        )
    }
}

struct PokemonList_Previews: PreviewProvider {
    static var previews: some View {
        PokemonList()
    }
}

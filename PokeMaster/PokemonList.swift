//
//  PokemonList.swift
//  PokeMaster
//
//  Created by huhsx on 2020/7/30.
//  Copyright © 2020 huhsx. All rights reserved.
//

import SwiftUI

struct PokemonList: View {
    
    @State var expandingIndex: Int?
    
    var body: some View {
        
        ScrollView {
            ForEach(PokemonViewModel.all) { pokemon in
                PokemonInfoRow(model: pokemon, expanded: self.expandingIndex == pokemon.id)
                    .onTapGesture {
                        withAnimation(
                            .spring(response: 0.55, dampingFraction: 0.425, blendDuration: 0)
                        ){
                            self.expandingIndex = self.expandingIndex == pokemon.id ? nil : pokemon.id
                        }
                }
            }
        }
    .overlay(
        VStack{
            Spacer()
            PokemonInfoPanel(model: .sample(id: 1))
        }.edgesIgnoringSafeArea(.bottom)
        )
    }
}

struct PokemonList_Previews: PreviewProvider {
    static var previews: some View {
        PokemonList()
    }
}

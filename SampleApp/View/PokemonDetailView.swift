//
//  PokemonDetailView.swift
//  SampleApp
//
//  Created by 0v0 on 2024/10/16.
//
import SwiftUI

struct PokemonDetailView: View {
    let pokemon: Pokemon
    @State private var isImageLoaded = false
    
    var body: some View {
        ScrollView {
            VStack {
                // ポケモン画像
                AsyncImage(url: URL(string: pokemon.imageURL)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 200)
                            .onAppear { isImageLoaded = true }
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 200)
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(height: 200)
                
                // ポケモン説明
                Text(pokemon.description)
                    .font(.body)
                    .padding(.horizontal,32)
            }
            .navigationTitle(pokemon.name)
        }
    }
}

// プレビュー用
struct PokemonDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PokemonDetailView(pokemon: Pokemon(id: 25, name: "ピカチュウ", description: "尻尾を　立てて　周りの　様子を　探っていると　時々　雷が　尻尾に　落ちてくる。", imageURL: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png"))
        }
    }
}

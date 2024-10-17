//
//  PokemonListView.swift
//  SampleApp
//
//  Created by 0v0 on 2024/10/16.
//
import SwiftUI

struct PokemonListView: View {
    @StateObject private var viewModel: PokemonListViewModel
    
    init(viewModel: PokemonListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("読み込み中...")
                } else if let error = viewModel.errorMessage {
                    ErrorView(message: error, retryAction: viewModel.fetchPokemonList)
                } else {
                    PokemonList(pokemons: viewModel.pokemonList)
                }
            }
            .navigationTitle("ポケモン図鑑")
        }
        .onAppear(perform: viewModel.fetchPokemonList)
    }
}

struct PokemonList: View {
    let pokemons: [Pokemon]
    
    var body: some View {
        List(pokemons) { pokemon in
            NavigationLink(destination: PokemonDetailView(pokemon: pokemon)) {
                PokemonRow(pokemon: pokemon)
            }
        }
    }
}

struct PokemonRow: View {
    let pokemon: Pokemon
    
    var body: some View {
        HStack {
            PokemonImage(url: pokemon.imageURL)
            Text(pokemon.name.capitalized)
        }
    }
}

struct PokemonImage: View {
    let url: String
    
    var body: some View {
        AsyncImage(url: URL(string: url)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.secondary.opacity(0.3), lineWidth: 1))
        } placeholder: {
            ProgressView()
                .frame(width: 60, height: 60)
        }
    }
}

struct ErrorView: View {
    let message: String
    let retryAction: () -> Void
    
    var body: some View {
        VStack {
            Text(message)
                .multilineTextAlignment(.center)
                .padding()
            Button("再試行", action: retryAction)
        }
    }
}

// モックのポケモンデータ
let mockPokemons = [
    Pokemon(id: 1, name: "フシギダネ", description: "生まれた時から　背中に　不思議な　タネが　植えてあって　体と　共に　育つという。", imageURL: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png"),
    Pokemon(id: 2, name: "フシギソウ", description: "蕾が　背中に　ついていて　養分を　吸収していくと　大きな　花が　咲くという。", imageURL: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/2.png"),
    Pokemon(id: 3, name: "フシギバナ", description: "大きな花びらを広げ太陽の光を浴びていると体に元気がみなぎっていく。", imageURL: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/3.png")
]

// プレビュー用のモックリポジトリ
class MockPokemonRepository: PokemonRepository {
    func getPokemonList() async throws -> [Pokemon] {
        return mockPokemons
    }
}

#Preview {
    let mockRepository = MockPokemonRepository()
    let useCase = GetPokemonListUseCase(repository: mockRepository)
    let viewModel = PokemonListViewModel(getPokemonListUseCase: useCase)
    
    return PokemonListView(viewModel: viewModel)
}

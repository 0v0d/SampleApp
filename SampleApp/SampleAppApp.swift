//
//  SampleAppApp.swift
//  SampleApp
//
//  Created by 0v0 on 2024/10/16.
//
import SwiftUI

@main
struct PokemonApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @StateObject private var viewModel: PokemonListViewModel
    
    init() {
        let repository = PokemonRepositoryImpl()
        let useCase = GetPokemonListUseCase(repository: repository)
        _viewModel = StateObject(wrappedValue: PokemonListViewModel(getPokemonListUseCase: useCase))
    }
    
    var body: some View {
        PokemonListView(viewModel: viewModel)
    }
}

#Preview {
    ContentView()
}

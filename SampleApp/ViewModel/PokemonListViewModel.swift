//
//  PokemonListViewModel.swift
//  SampleApp
//
//  Created by 0v0 on 2024/10/16.
//
import Foundation

@MainActor
class PokemonListViewModel: ObservableObject {
    @Published private(set) var pokemonList: [Pokemon] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?
    
    private let getPokemonListUseCase: GetPokemonListUseCaseProtocol
    
    init(getPokemonListUseCase: GetPokemonListUseCaseProtocol) {
        self.getPokemonListUseCase = getPokemonListUseCase
    }
    
    func fetchPokemonList() {
        Task {
            await loadPokemonList()
        }
    }
    
    private func loadPokemonList() async {
        isLoading = true
        errorMessage = nil
        
        do {
            pokemonList = try await getPokemonListUseCase.execute()
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}

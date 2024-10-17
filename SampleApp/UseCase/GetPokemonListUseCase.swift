//
//  GetPokemonListUseCase.swift
//  SampleApp
//
//  Created by 0v0 on 2024/10/16.
//
import Foundation

protocol GetPokemonListUseCaseProtocol {
    func execute() async throws -> [Pokemon]
}

final class GetPokemonListUseCase: GetPokemonListUseCaseProtocol {
    private let repository: PokemonRepository
    
    init(repository: PokemonRepository) {
        self.repository = repository
    }
    
    func execute() async throws -> [Pokemon] {
        return try await repository.getPokemonList()
    }
}

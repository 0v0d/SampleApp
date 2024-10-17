//
//  PokemonRepository.swift
//  SampleApp
//
//  Created by 0v0 on 2024/10/16.
//
import Foundation

protocol PokemonRepository {
    func getPokemonList() async throws -> [Pokemon]
}

final class PokemonRepositoryImpl: PokemonRepository {
    private let baseURL = URL(string: "https://pokeapi.co/api/v2")!
    private let spriteBaseURL = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/")!
    private let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func getPokemonList() async throws -> [Pokemon] {
        let url = baseURL.appendingPathComponent("pokemon")
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = [URLQueryItem(name: "limit", value: "150")]
        
        guard let requestURL = components?.url else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await urlSession.data(from: requestURL)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let pokemonListResponse = try JSONDecoder().decode(APIResponse.self, from: data)
        
        return try await withThrowingTaskGroup(of: Pokemon.self) { group in
            for pokemonDTO in pokemonListResponse.results {
                group.addTask {
                    let id = Int(pokemonDTO.url.split(separator: "/").last!)!
                    let imageURL = self.spriteBaseURL.appendingPathComponent("\(id).png").absoluteString
                    
                    async let japaneseName = self.fetchPokemonJapaneseName(id: id)
                    async let description = self.fetchPokemonJapaneseDescription(id: id)
                    
                    return Pokemon(id: id, name: try await japaneseName, description: try await description, imageURL: imageURL)
                }
            }
            
            var pokemonList = [Pokemon]()
            for try await pokemon in group {
                pokemonList.append(pokemon)
            }
            
            return pokemonList.sorted { $0.id < $1.id }
        }
    }
    
    private func fetchPokemonJapaneseName(id: Int) async throws -> String {
        let speciesResponse = try await fetchSpeciesData(id: id)
        return speciesResponse.names.first { $0.language.name == "ja-Hrkt" }?.name ?? "Unknown"
    }
    
    private func fetchPokemonJapaneseDescription(id: Int) async throws -> String {
        let speciesResponse = try await fetchSpeciesData(id: id)
        return speciesResponse.flavorTextEntries
            .first { $0.language.name == "ja" }?
            .flavorText
            .replacingOccurrences(of: "\n", with: " ") ?? "説明が見つかりませんでした。"
    }
    
    private func fetchSpeciesData(id: Int) async throws -> PokemonSpeciesResponse {
        let url = baseURL.appendingPathComponent("pokemon-species/\(id)")
        let (data, response) = try await urlSession.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(PokemonSpeciesResponse.self, from: data)
    }
}

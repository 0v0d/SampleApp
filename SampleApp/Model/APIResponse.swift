//
//  APIResponse.swift
//  SampleApp
//
//  Created by 0v0 on 2024/10/16.
//
import Foundation

struct APIResponse: Codable {
    let results: [PokemonAPIResponse]
}

struct PokemonAPIResponse: Codable {
    let name: String
    let url: String
}

struct PokemonSpeciesResponse: Decodable {
    let flavorTextEntries: [FlavorTextEntry]
    let names: [Name]
    
    enum CodingKeys: String, CodingKey {
        case flavorTextEntries = "flavor_text_entries"
        case names
    }
    
    struct FlavorTextEntry: Decodable {
        let flavorText: String
        let language: Language
        
        enum CodingKeys: String, CodingKey {
            case flavorText = "flavor_text"
            case language
        }
    }
    
    struct Name: Decodable {
        let name: String
        let language: Language
    }
    
    struct Language: Decodable {
        let name: String
    }
}

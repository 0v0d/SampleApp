//
//  Poke.swift
//  SampleApp
//
//  Created by 0v0 on 2024/10/15.
//
import Foundation

struct Pokemon: Identifiable, Decodable, Hashable {
    let id: Int
    let name: String
    let description: String
    let imageURL: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case imageURL = "image_url"
    }
}

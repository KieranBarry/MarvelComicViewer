//
//  Comic.swift
//  MarvelComicViewer
//
//  Created by Kieran Barry on 8/13/21.
//

import Foundation

/**
 A struct containing the comic data specified in the Marvel API
 
 - Note:
    init(from decoder:) forwards decoder to fileprivate RawComicResponse struct and subsequently processes and flattens the nested object
 
 - Throws: `APIError.dataNotDecoded` if RawComicResponse fails to decode server response
 */
struct Comic: Codable {
    
    private let id: Int
    let title: String
    let description: String?
    let authors: [String]
    let issueNumber: Int
    let imagePath: MarvelImagePath
    
    // Initializes variables by processing and flattening raw JSON response
    init(from decoder: Decoder) throws {
        let rawResponse = try RawComicResponse(from: decoder)

        guard let rawComic = rawResponse.data.results.first else {
            throw APIError.dataNotDecoded
        }
        
        // Discards the year and variant information, only keeping the issue's title
        let initialTitle = rawComic.title.split(separator: "(").first?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        title = initialTitle.hasSuffix("TPB") ? String(initialTitle.dropLast(4)) : initialTitle
        
        id = rawComic.id
        description = rawComic.description
        authors = rawComic.creators.items.map { $0.name }
        issueNumber = rawComic.issueNumber
        imagePath = rawComic.thumbnail
    }
}


// MARK: RawComicResponse

/// Codable struct to hold nested response structure of Marvel API's comic query
fileprivate struct RawComicResponse: Codable {
    let data: Results

    fileprivate struct Results: Codable {
        let results: [RawComic]
    }

    fileprivate struct RawComic: Codable {
        let id: Int
        let title: String
        let description: String?
        let issueNumber: Int
        let thumbnail: MarvelImagePath
        let creators: RawCreators
    }
    
    fileprivate struct RawCreators: Codable {
        let items: [RawAuthors]
    }

    fileprivate struct RawAuthors: Codable {
        let name: String
    }
}

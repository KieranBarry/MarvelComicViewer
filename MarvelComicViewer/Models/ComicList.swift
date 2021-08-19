//
//  ComicList.swift
//  MarvelComicViewer
//
//  Created by Kieran Barry on 8/19/21.
//

import Foundation

/**
 A struct containing a list of comic data as specified in the Marvel API
 
 - Note:
    init(from decoder:) forwards decoder to fileprivate RawComicResponse struct and subsequently processes and flattens the nested object
  */
struct ComicList: Decodable {
    
    var comics: [Comic] = []
    
    // Initializes variables by processing and flattening raw JSON response
    init(from decoder: Decoder) throws {
        
        let rawResponse = try RawComicResponse(from: decoder)
        let rawComicList = rawResponse.data.results
        
        for rawComic in rawComicList {
            // Discards the year and variant information, only keeping the issue's title
            let initialTitle = rawComic.title.split(separator: "(").first?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let title = initialTitle.hasSuffix("TPB") ? String(initialTitle.dropLast(4)) : initialTitle

            let id = rawComic.id
            let description = rawComic.description
            let authors = rawComic.creators.items.map { $0.name }
            let issueNumber = rawComic.issueNumber
            let imagePath = rawComic.thumbnail
            
            let comic = Comic(id: id, title: title, description: description, authors: authors, issueNumber: issueNumber, imagePath: imagePath)
            comics.append(comic)
        }
        

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

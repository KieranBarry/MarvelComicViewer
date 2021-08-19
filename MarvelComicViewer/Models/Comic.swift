//
//  Comic.swift
//  MarvelComicViewer
//
//  Created by Kieran Barry on 8/13/21.
//

import Foundation

/// A struct containing the comic data specified in the Marvel API
struct Comic {
    let id: Int
    let title: String
    let description: String?
    let authors: [String]
    let issueNumber: Int
    let imagePath: MarvelImagePath
}


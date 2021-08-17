//
//  Constants.swift
//  MarvelComicViewer
//
//  Created by Kieran Barry on 8/13/21.
//

import Foundation

/// A class to store all constants associated with this project
final class Constants {
    static let comicId = 52646 // 52646 - normal, 15878 - long description, 96089 - no description, 5813 - no image
    static let networkErrorText = "Sorry, we are having trouble processing this request at this time."
    
    /// A class to store all constants for the Marvel API associated with this project
    final class MarvelAPI {
        static let baseEndpoint = "https://gateway.marvel.com:443/v1/public/"
        static let comicByIdEndpoint = baseEndpoint + "comics/"
        static let timeStamp = String(Date().timeIntervalSince1970)
        static let privateKey = MarvelAPIKeys.privateKey
        static let publicKey = MarvelAPIKeys.publicKey
        static var hash: String {
            "\(timeStamp)\(MarvelAPIKeys.privateKey)\(MarvelAPIKeys.publicKey)".MD5HashedString()
        }
        static let imageSize = "detail"
    }
    
    enum AccessibilityIdentifiers: String {
        case comicTitle = "Title of Comic"
        case comicIssueNumber = "Issue Number of Comic"
        case comicAuthors = "Creators of Comic"
        case comicDescriptionHeader = "Description"
        case comicDescription = "Description of Comic"
        case comicImage = "Cover Image of Comic"
    }
}

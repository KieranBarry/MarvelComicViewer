//
//  MarvelImagePath.swift
//  MarvelComicViewer
//
//  Created by Kieran Barry on 8/14/21.
//

import Foundation

/**
 A struct containing the data need to construct a URL to fetch an image from the Marvel API
 
 - Note:
    Uses custom coding key to map from property fileExtension to JSON response's "extension" key in order to avoid Swift keyword "extension"
 */
struct MarvelImagePath: Codable {
    let path: String
    let fileExtension: String
    
    private enum CodingKeys: String, CodingKey {
      case path, fileExtension = "extension"
    }
    
    init(path: String, fileExtension: String) {
        self.path = path
        self.fileExtension = fileExtension
    }
}

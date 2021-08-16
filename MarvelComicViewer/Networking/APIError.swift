//
//  APIError.swift
//  MarvelComicViewer
//
//  Created by Kieran Barry on 8/13/21.
//

import Foundation

/// A custom Error enum for Marvel API requests
enum APIError: String, Error {
    case invalidURL = "The supplied URL is invalid"
    case unableToComplete = "Unable to complete your request."
    case invalidResponse = "The response received from the server is invalid."
    case invalidData = "The data received from the server is invalid"
    case dataNotDecoded = "The data received from the server could not be decoded."
    case badImage = "The data image from the server was invalid."
}

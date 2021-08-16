//
//  MarvelAPIManager.swift
//  MarvelComicViewer
//
//  Created by Kieran Barry on 8/13/21.
//

import Foundation
import UIKit


/// Network manager for Marvel's Comic API built on URLSession
class MarvelAPIManager {
    
    /// shared singleton of MarvelAPIManager
    static let shared = MarvelAPIManager()
    
    var session = URLSession.shared
    
    
    // MARK: Public API
    
    /**
     Launches fetch request for an individual comic's data and forwards result to the completion handler
     - parameters:
        - comicId: the comic's ID in the Marvel API
        - completionHandler: The completion handler to call when the request is complete
        - result: The response from the server that holds the fetched Comic object on success or an APIError on failure
     */
    func fetchComic(matching comicId: Int, completionHandler: @escaping (_ result: Result<Comic, APIError>) -> Void) {
        guard let url = generateMarvelAuthenticatedURL(for: Constants.MarvelAPI.baseEndpoint + "comics/\(comicId)") else {
            completionHandler(.failure(.invalidURL))
            return
        }
        
        launchFetchRequest(from: url) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()

                    let comic = try decoder.decode(Comic.self, from: data)
                    completionHandler(.success(comic))
                } catch {
                    completionHandler(.failure(.dataNotDecoded))
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    /**
     Launches fetch request for an individual comic's thumbnail image and forwards result to the completion handler
     - parameters:
        - imagePath: a MarvelImagePath specifying the image's URL and file extension
        - completionHandler: The completion handler to call when the request is complete
        - result: The response from the server that holds the fetched UIImage object on success or an APIError on failure
     */
    func fetchImage(from imagePath: MarvelImagePath, completionHandler: @escaping (_ result: Result<UIImage, APIError>) -> Void) {
        guard let url = generateMarvelImageURL(from: imagePath) else {
            completionHandler(.failure(.invalidURL))
            return
        }
        
        launchFetchRequest(from: url) { result in
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else {
                    completionHandler(.failure(.badImage))
                    return
                }
                
                completionHandler(.success(image))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
  
    
    // MARK: Utility Methods

    /**
     Utility function abstracting out boilerplate code for URLSession dataTask call
     - parameters:
        - url: the url to make the request from
        - completionHandler: The completion handler to call when the  request is complete
        - result: The response from the server that holds the fetched Data object on success or an APIError on failure
     */
    private func launchFetchRequest(from url: URL, completionHandler: @escaping (_ result: Result<Data, APIError>) -> Void) {
        let dataTask = session.dataTask(with: url) { data, response, error in
            if let _ = error {
                completionHandler(.failure(.unableToComplete))
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completionHandler(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(.invalidData))
                return
            }
            
            completionHandler(.success(data))
        }
            
        dataTask.resume()
    }
    
    /**
     Adds Marvel API  key, timestamp, and md5 hash to end of passed in url endpoint
     - parameter endpoint: The url to append the authentication parameters to
     - Returns: A URL optional containing a value if generation was successful and nil otherwise
     */
    private func generateMarvelAuthenticatedURL(for endpoint: String) -> URL? {
        guard var urlComponents = URLComponents(string: endpoint) else { return nil }
            
        urlComponents.queryItems = [
            URLQueryItem(name: "apikey", value: Constants.MarvelAPI.publicKey),
            URLQueryItem(name: "ts", value: Constants.MarvelAPI.timeStamp),
            URLQueryItem(name: "hash", value: Constants.MarvelAPI.hash),
        ]
        
        return urlComponents.url
    }
    
    /**
     Generates url from MarvelImagePath and ensures https protocol
     - parameter imagePath: the MarvelImagePath object to generate the url from
     - Returns: A URL optional containing a value if generation was successful and nil otherwise
     */
    private func generateMarvelImageURL(from imagePath: MarvelImagePath) -> URL? {
        guard var urlComponents = URLComponents(string: imagePath.path + "/" + Constants.MarvelAPI.imageSize + "." + imagePath.fileExtension)
            else { return nil }
        urlComponents.scheme = "https"
        
        return urlComponents.url
    }
}

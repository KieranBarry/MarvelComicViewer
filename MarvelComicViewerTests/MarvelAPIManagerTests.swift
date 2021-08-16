//
//  MarvelComicViewerTests.swift
//  MarvelComicViewerTests
//
//  Created by Kieran Barry on 8/13/21.
//

import XCTest
@testable import MarvelComicViewer

/**
 Unit testing class for MarvelAPIManager
 */
class MarvelAPIManagerTests: XCTestCase {

    var sut: MarvelAPIManager!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = MarvelAPIManager.shared
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    /// Asserts that fetchComic successfully provides a Comic object upon 200 response with decodable data
    func testFetchComicSuccessReturnsComic() throws {
        let comicId = 1111
        let urlString = "\(Constants.MarvelAPI.baseEndpoint)comics/\(comicId)?apikey=\(Constants.MarvelAPI.publicKey)&ts=\(Constants.MarvelAPI.timeStamp)&hash=\(Constants.MarvelAPI.hash)"
        let url = URL(string: urlString)!
        
        let jsonString = "{ \"code\": 200, \"data\": { \"count\": 1, \"results\": [{ \"id\": 5813, \"title\": \"Marvel Milestones (2005) #22\", \"issueNumber\": 22, \"description\": null, \"thumbnail\": { \"path\": \"http://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available\", \"extension\": \"jpg\" }, \"creators\": { \"available\": 0, \"collectionURI\": \"http://gateway.marvel.com/v1/public/comics/5813/creators\", \"items\": [], \"returned\": 0 } }]}}"
        let data = Data(jsonString.utf8)
        
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        URLProtocolMock.mockURLs = [url: (nil, data, response)]

        let sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.protocolClasses = [URLProtocolMock.self]
        let mockSession = URLSession(configuration: sessionConfiguration)
        sut.session = mockSession
        
        let promise = expectation(description: "Received a comic")
        
        sut.fetchComic(matching: comicId) { result in
            switch result {
            case .success(let comic):
                XCTAssertNotNil(comic)
                promise.fulfill()
            case .failure(let error):
                XCTFail("Error: \(error.rawValue)")
            }
        }
        
        wait(for: [promise], timeout: 5)
    }
    
    /// Asserts that fetchComic fails with APIError.invalidResponse when provided invalid comicId
    func testFetchComicFailsWithInvalidComicId() throws {
        let comicId = -1
        
        let promise = expectation(description: "Failed with .invalidResponse")
        
        sut.fetchComic(matching: comicId) { result in
            switch result {
            case .success(_):
                XCTFail("Received Comic")
            case .failure(let error):
                XCTAssertEqual(error, APIError.invalidResponse)
                promise.fulfill()
            }
        }
        
        wait(for: [promise], timeout: 5)
    }
    
    /// Asserts that fetchComic fails with APIError.dataNotDecoded when data returned from server does not conform to expected schema
    func testFetchComicFailsWithNonDecodableData() throws {
        let comicId = 1111
        let urlString = "\(Constants.MarvelAPI.baseEndpoint)comics/\(comicId)?apikey=\(Constants.MarvelAPI.publicKey)&ts=\(Constants.MarvelAPI.timeStamp)&hash=\(Constants.MarvelAPI.hash)"
        let url = URL(string: urlString)!
        
        let data = Data("\"invalid\":\"data\"".utf8)
        
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        URLProtocolMock.mockURLs = [url: (nil, data, response)]

        runFailingTestExpecting(.dataNotDecoded, for: comicId)
    }
    
    /// Asserts that fetchComic fails with APIError.invalidResponse when status code is not 200
    func testFetchComicFailsWithNon200ServerResponse() throws {
        let comicId = 1111
        let urlString = "\(Constants.MarvelAPI.baseEndpoint)comics/\(comicId)?apikey=\(Constants.MarvelAPI.publicKey)&ts=\(Constants.MarvelAPI.timeStamp)&hash=\(Constants.MarvelAPI.hash)"
        let url = URL(string: urlString)!
        
        let response = HTTPURLResponse(url: url, statusCode: 404, httpVersion: nil, headerFields: nil)
        
        URLProtocolMock.mockURLs = [url: (nil, nil, response)]

        runFailingTestExpecting(.invalidResponse, for: comicId)
    }
    
    /**
     Utility function to set up and run a MarvelAPI networking test that is expected to fail
     - parameter error: the APIError that is expected
     - parameter comicId: the id of the comic to fetch
     */
    private func runFailingTestExpecting(_ error: APIError, for comicId: Int) {
        let sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.protocolClasses = [URLProtocolMock.self]
        let mockSession = URLSession(configuration: sessionConfiguration)
        sut.session = mockSession
        
        let promise = expectation(description: "Failed with \(error)")
        
        sut.fetchComic(matching: comicId) { result in
            switch result {
            case .success(_):
                XCTFail("Received Comic")
            case .failure(let error):
                XCTAssertEqual(error, error)
                promise.fulfill()
            }
        }
        
        wait(for: [promise], timeout: 5)
    }
}

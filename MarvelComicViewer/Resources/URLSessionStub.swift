//
//  URLSessionStub.swift
//  MarvelComicViewer
//
//  Created by Kieran Barry on 8/15/21.
//

import Foundation

/**
 Stubs for URLSession
 Source: www.raywenderlich.com
 */

typealias DataTaskCompletionHandler = (Data?, URLResponse?, Error?) -> Void

protocol URLSessionProtocol {
  func dataTask(
    with url: URL,
    completionHandler: @escaping DataTaskCompletionHandler
  ) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol { }

class URLSessionStub: URLSessionProtocol {
    private let stubbedData: Data?
    private let stubbedResponse: URLResponse?
    private let stubbedError: Error?

    init(data: Data? = nil, response: URLResponse? = nil, error: Error? = nil) {
        self.stubbedData = data
        self.stubbedResponse = response
        self.stubbedError = error
    }

    func dataTask(with url: URL, completionHandler: @escaping DataTaskCompletionHandler) -> URLSessionDataTask {
        URLSessionDataTaskStub(
            stubbedData: stubbedData,
            stubbedResponse: stubbedResponse,
            stubbedError: stubbedError,
            completionHandler: completionHandler
        )
    }
}

class URLSessionDataTaskStub: URLSessionDataTask {
    private let stubbedData: Data?
    private let stubbedResponse: URLResponse?
    private let stubbedError: Error?
    private let completionHandler: DataTaskCompletionHandler?

    init(stubbedData: Data? = nil, stubbedResponse: URLResponse? = nil, stubbedError: Error? = nil,
         completionHandler: DataTaskCompletionHandler? = nil
    ) {
        self.stubbedData = stubbedData
        self.stubbedResponse = stubbedResponse
        self.stubbedError = stubbedError
        self.completionHandler = completionHandler
    }

    override func resume() {
        completionHandler?(stubbedData, stubbedResponse, stubbedError)
    }
}

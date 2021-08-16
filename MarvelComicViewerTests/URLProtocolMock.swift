//
//  URLProtocolMock.swift
//  MarvelComicViewerTests
//
//  Created by Kieran Barry on 8/15/21.
//

import Foundation

/// Mock URLProtocol class  URLSession that intercepts requests and returns desired error, response, and data
class URLProtocolMock: URLProtocol {
    
    /// Dictionary maps URLs to tuples of desire error, data, and response
    static var mockURLs = [URL?: (error: Error?, data: Data?, response: HTTPURLResponse?)]()

    override class func canInit(with request: URLRequest) -> Bool {
        // Can handle all requests
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        // Required -- return what is passed
        return request
    }

    override func startLoading() {
        if let url = request.url {
            if let (error, data, response) = URLProtocolMock.mockURLs[url] {
                
                // Return specified mock response
                if let responseStrong = response {
                    self.client?.urlProtocol(self, didReceive: responseStrong, cacheStoragePolicy: .notAllowed)
                }
                
                // Return specified mock data
                if let dataStrong = data {
                    self.client?.urlProtocol(self, didLoad: dataStrong)
                }
                
                // Return specified mock error
                if let errorStrong = error {
                    self.client?.urlProtocol(self, didFailWithError: errorStrong)
                }
            }
        }

        self.client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {
        // Required -- return immediately
    }
}


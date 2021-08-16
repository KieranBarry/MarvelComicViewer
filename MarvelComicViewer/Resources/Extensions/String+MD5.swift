//
//  String+MD5.swift
//  MarvelComicViewer
//
//  Created by Kieran Barry on 8/13/21.
//

import Foundation
import CryptoKit

extension String {
    /**
     Creates an MD5 hash hex string of this string
     - Returns: an MD5 hash of this string in hex format
     */
    func MD5HashedString() -> String {
        let digest = Insecure.MD5.hash(data: self.data(using: .utf8) ?? Data())
        return digest.map { String(format: "%02hhx", $0) }.joined()
    }
}

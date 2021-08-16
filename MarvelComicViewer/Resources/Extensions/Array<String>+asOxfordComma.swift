//
//  Array<String>+asOxfordComma.swift
//  MarvelComicViewer
//
//  Created by Kieran Barry on 8/14/21.
//

import Foundation

extension Array where Element == String {
    
    /**
     Creates a comma separated list ending with ", and " of all elements in this array
     # Notes #
        - [] becomes ""
        - ["a"] becomes "a"
        - ["a", "b"] becomes "a and b"
        - ["a", "b", "c"] becomes "a, b, and c"
     - Returns: an oxford comma separated string representation of this array
     */
    func asOxfordCommaList() -> String {
        switch self.count {
        case 0:
            return ""
        case 1:
            return self[0]
        case 2:
            return self[0] + " and " + self[1]
        default:
            return self.dropLast(1).joined(separator: ", ") + ", and \(self[self.index(before: self.endIndex)])"
        }
    }
}

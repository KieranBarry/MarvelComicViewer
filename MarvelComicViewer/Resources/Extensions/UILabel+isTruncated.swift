//
//  UILabel+isTruncated.swift
//  MarvelComicViewer
//
//  Created by Kieran Barry on 8/16/21.
//

import Foundation
import UIKit

extension UILabel {

    /// Calculated boolean to represent if text inside UILabel is truncated
    var isTruncated: Bool {
        guard let labelText = text else { return false }
        guard let font = font else { return false }
        
        let labelTextSize = (labelText as NSString).boundingRect(
            with: CGSize(width: frame.size.width, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil).size

        return labelTextSize.height > bounds.size.height
    }
}

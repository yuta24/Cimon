//
//  StringAttributer.swift
//  Shared
//
//  Created by Yu Tawata on 2019/05/09.
//

import UIKit

public class StringAttributer {
    let string: String

    private var attributes = [NSRange: [NSAttributedString.Key: Any]]()

    public init(string: String) {
        self.string = string
    }

    public func build() -> NSAttributedString {
        let mutable = NSMutableAttributedString(string: string)

        attributes.forEach { (range, attributes) in
            mutable.addAttributes(attributes, range: range)
        }

        return mutable
    }
}

public extension StringAttributer {
    func font(_ font: UIFont, range: NSRange? = nil) -> StringAttributer {
        let range = range ?? NSRange(location: 0, length: string.utf16.count)

        if attributes[range] != nil {
            attributes[range] = [:]
        }
        attributes[range]?[.font] = font

        return self
    }

    func lineSpacing(_ lineSpacing: CGFloat, range: NSRange? = nil) -> StringAttributer {
        let range = range ?? NSRange(location: 0, length: string.utf16.count)

        if attributes[range] != nil {
            attributes[range] = [:]
        }
        let paragraphStyle = (attributes[range]?[.paragraphStyle] as? NSMutableParagraphStyle) ?? NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        attributes[range]?[.paragraphStyle] = paragraphStyle

        return self
    }

    func foregroundColor(_ color: UIColor, range: NSRange? = nil) -> StringAttributer {
        let range = range ?? NSRange(location: 0, length: string.utf16.count)

        if attributes[range] != nil {
            attributes[range] = [:]
        }
        attributes[range]?[.foregroundColor] = color

        return self
    }

    func backgroundColor(_ color: UIColor, range: NSRange? = nil) -> StringAttributer {
        let range = range ?? NSRange(location: 0, length: string.utf16.count)

        if attributes[range] != nil {
            attributes[range] = [:]
        }
        attributes[range]?[.backgroundColor] = color

        return self
    }
}

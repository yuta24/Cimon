//
//  String+Extension.swift
//  Litey
//
//  Created by Yu Tawata on 2020/08/16.
//

import Foundation

extension String {
    func quote(_ mark: Character = "\"") -> String {
        let escaped = reduce("") { string, character in
            string + (character == mark ? "\(mark)\(mark)" : "\(character)")
        }
        return "\(mark)\(escaped)\(mark)"
    }
}

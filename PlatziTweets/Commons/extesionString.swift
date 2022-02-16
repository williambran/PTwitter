//
//  extesionString.swift
//  PlatziTweets
//
//  Created by mac1 on 02/04/21.
//  Copyright © 2021 mac1. All rights reserved.
//

import Foundation



extension String{
    
    func removeCharacters(from forbiddenChars: CharacterSet) -> String {
        let passed = self.unicodeScalars.filter { !forbiddenChars.contains($0) }
        return String(String.UnicodeScalarView(passed))
    }
    
    func removeCharacters(from: String) -> String {
        return removeCharacters(from: CharacterSet(charactersIn: from))
    }
    
   
    
    func localizable() -> String {
        let tableName: String = "Localizable"
        return NSLocalizedString(self, tableName: tableName, bundle: .main, value: "", comment: "")
    }
    
}

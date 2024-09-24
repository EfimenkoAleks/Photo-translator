//
//  String+Extension.swift
//  Photo translator
//
//  Created by Aleksandr on 19.09.2024.
//

import Foundation

extension String {
  func removingCharacters(inCharacterSet forbiddenCharacters:CharacterSet) -> String
{
    var filteredString = self
    while true {
      if let forbiddenCharRange = filteredString.rangeOfCharacter(from: forbiddenCharacters)  {
        filteredString.removeSubrange(forbiddenCharRange)
      }
      else {
        break
      }
    }

    return filteredString
  }
}

//
//  String.swift
//  Syml
//
//  Created by Harry Jordan on 26/08/2015.
//  Copyright © 2015 Inquisitive Software. All rights reserved.
//

import Foundation

func NSRangeOfString(string: NSString!) -> NSRange {
    let range = NSRange(location: 0, length:string.length)
    return range
}

extension String {

    func isMatchedBy(_ pattern: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: .dotMatchesLineSeparators)
            let matches = regex.numberOfMatches(in: self, options: [], range: NSRangeOfString(string: self as NSString))
            return matches > 0
        } catch {}

        return false
    }
    
    var numberOfWords: UInt {
        var numberOfWords: UInt = 0
        let searchRange = self.startIndex..<self.endIndex
        
        self.enumerateSubstrings(in: searchRange, options: .byWords) { (_, _, _, _) in
            numberOfWords += 1
        }
        
        return numberOfWords
    }
    
    
    var numberOfSentences: UInt {
        var numberOfSentences: UInt = 0
        let searchRange = self.startIndex..<self.endIndex
        
        self.enumerateSubstrings(in: searchRange, options: [.bySentences, .substringNotRequired]) { (_, _, _, _) -> () in
            numberOfSentences += 1
        }
        
        return numberOfSentences
    }
    
    
    var numberOfParagraphs: UInt {
        var numberOfParagraphs: UInt = 0
        let searchRange = self.startIndex..<self.endIndex
        
        self.enumerateSubstrings(in: searchRange, options: [.byParagraphs, .substringNotRequired]) { (_, _, _, _) -> () in
            numberOfParagraphs += 1
        }
        
        return numberOfParagraphs
    }
    
    
    var numberOfCharacters: UInt {
        return UInt(count)
    }
    
    
    var numberOfDecimalCharacters: Int {
        return numberOfCharacters(in: .decimalDigits)
    }
    
    
    func numberOfCharacters(in characterSet: CharacterSet, minimumRun: Int = 0) -> Int {
        var numberOfMatchingCharacters = 0
        let scanner = Scanner(string: self)
        
        repeat {
            scanner.scanUpToCharacters(from: characterSet, into: nil)
            
            var matchingString: NSString? = nil
            
            if !scanner.isAtEnd && scanner.scanCharacters(from: characterSet, into: &matchingString), let matchingString = matchingString {
                numberOfMatchingCharacters += matchingString.length
            }
        } while (!scanner.isAtEnd)
        
        return numberOfMatchingCharacters
    }
    
    
    var looksLikeAnIdentifier: Bool {
        let knownPrefixes = ["text-"]
        var numberOfIdentifierCharacters = knownPrefixes.filter { self.hasPrefix($0) }.reduce(0) { $0 + $1.count }
        
        let identifierCharacterSets: [CharacterSet] = [
            CharacterSet.decimalDigits,
            CharacterSet(charactersIn: "–-_"),
            CharacterSet.uppercaseLetters
        ]
        
        var combinedIdentifierCharacterSet = CharacterSet()
        
        for characterSet in identifierCharacterSets {
            combinedIdentifierCharacterSet.formUnion(characterSet)
        }
        
        numberOfIdentifierCharacters += self.numberOfCharacters(in: combinedIdentifierCharacterSet, minimumRun: 5)
        let stringLength = self.count
        
        if (stringLength > 0) && (numberOfIdentifierCharacters > 0) && (Double(numberOfIdentifierCharacters) / Double(stringLength) > 0.55) {
            return true
        }
        
        return false
    }
    
    
    func firstLine(upToCharacter desiredNumberOfCharacters: Int) -> String {
        var numberOfCharacters = 0
        var desiredRange: Range = startIndex..<endIndex
        
        enumerateLines { (line, stop) -> () in
            if !line.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                line.enumerateSubstrings(in: line.startIndex..<line.endIndex, options: [.byWords]) { (substring, _, enclosingRange, stopInternal) -> () in
                    desiredRange = line.startIndex..<enclosingRange.upperBound
                    numberOfCharacters += substring?.count ?? 0
                    
                    if numberOfCharacters >= desiredNumberOfCharacters {
                        stopInternal = true
                    }
                }
                
                stop = true
            }
        }
        
        let resultingString = self.substring(with: desiredRange).trimmingCharacters(in: .whitespacesAndNewlines)
        return resultingString
    }

    
    func substringForUntestedRange(range: NSRange) -> String? {
        let text = self as NSString
        let textRange = NSRangeOfString(string: text)
        
        let validRange = NSIntersectionRange(textRange, range)
        
        if validRange.length > 0 {
            return text.substring(with: validRange)
        }
        
        return nil
    }
    
    
    // MARK: String localization
    
    var localized: String {
        get {
            return localized()
        }
    }
    
    
    func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
}

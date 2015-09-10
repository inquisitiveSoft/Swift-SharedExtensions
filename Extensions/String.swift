//
//  String.swift
//  Syml
//
//  Created by Harry Jordan on 26/08/2015.
//  Copyright © 2015 Inquisitive Software. All rights reserved.
//

import Foundation


infix operator =~ {}


internal func =~ (string: String, pattern: String) -> Bool {
	do {
		let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.DotMatchesLineSeparators)
		let matches = regex.numberOfMatchesInString(string, options: [], range:NSRangeOfString(string))
		return matches > 0
	} catch {}
	
	return false
}



func NSRangeOfString(string: NSString!) -> NSRange {
	let range = NSRange(location: 0, length:string.length)
	return range
}


extension String {
	
	func numberOfWords() -> UInt {
		var numberOfWords: UInt = 0
		let searchRange = self.startIndex..<self.endIndex
		
		self.enumerateSubstringsInRange(searchRange, options: [NSStringEnumerationOptions.ByWords, NSStringEnumerationOptions.SubstringNotRequired]) { (_, _, _, _) -> () in
			numberOfWords++
		}
		
		return numberOfWords
	}
	
	

	func numberOfDecimalCharacters() -> Int {
		return numberOfCharactersInCharacterSet(NSCharacterSet.decimalDigitCharacterSet())
	}

	
	func numberOfCharactersInCharacterSet(characterSet: NSCharacterSet, minimumRun: Int = 0) -> Int {
		var numberOfMatchingCharacters = 0
		let scanner = NSScanner(string: self)
		
		repeat {
			scanner.scanUpToCharactersFromSet(characterSet, intoString: nil)
			
			var matchingString: NSString? = nil
			
			if !scanner.atEnd && scanner.scanCharactersFromSet(characterSet, intoString: &matchingString), let matchingString = matchingString {
				numberOfMatchingCharacters += matchingString.length
			}
		} while (!scanner.atEnd)
		
		return numberOfMatchingCharacters
	}
	
	
	var looksLikeAnIdentifier: Bool {
		let knownPrefixes = ["text-"]
		var numberOfIdentifierCharacters = knownPrefixes.filter { self.hasPrefix($0) }.reduce(0) { $0 + $1.characters.count }
		
		let identifierCharacterSets = [
			NSCharacterSet.decimalDigitCharacterSet(),
			NSCharacterSet(charactersInString: "–-_"),
			NSCharacterSet.uppercaseLetterCharacterSet()
		]
		
		let combinedIdentifierCharacterSet = NSMutableCharacterSet()
		
		for characterSet in identifierCharacterSets {
			combinedIdentifierCharacterSet.formUnionWithCharacterSet(characterSet)
		}
		
		numberOfIdentifierCharacters += numberOfCharactersInCharacterSet(combinedIdentifierCharacterSet, minimumRun: 5)
		let stringLength = self.characters.count
		
		if (stringLength > 0) && (numberOfIdentifierCharacters > 0) && (Double(numberOfIdentifierCharacters) / Double(stringLength) > 0.55) {
			return true
		}
		
		return false
	}
	
	
	func firstLineUpToCharacterCount(desiredNumberOfCharacters: Int) -> String {
		var numberOfCharacters = 0
		var desiredRange: Range = startIndex..<endIndex
		let whitespaceCharacterSet = NSCharacterSet.whitespaceAndNewlineCharacterSet()
		
		enumerateLines { (line, stop) -> () in
			if !line.stringByTrimmingCharactersInSet(whitespaceCharacterSet).isEmpty {
				line.enumerateSubstringsInRange(line.startIndex..<line.endIndex, options: [NSStringEnumerationOptions.ByWords]) { (substring, _, enclosingRange, stopInternal) -> () in
					desiredRange = line.startIndex..<enclosingRange.endIndex
					numberOfCharacters += substring?.characters.count ?? 0
					
					if numberOfCharacters >= desiredNumberOfCharacters {
						stopInternal = true
					}
				}
				
				stop = true
			}
		}
		
		let resultingString = substringWithRange(desiredRange).stringByTrimmingCharactersInSet(whitespaceCharacterSet)
		return resultingString
	}
	
	
	
	func substringForUntestedRange(range: NSRange) -> String? {
		let text = self as NSString
		let textRange = NSRangeOfString(text)
		
		let validRange = NSIntersectionRange(textRange, range)
		
		if validRange.length > 0 {
			return text.substringWithRange(validRange)
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


	func stringByAppendingPathComponent(component: String) -> String {
		return (self as NSString).stringByAppendingPathComponent(component)
	}
	
	
	func stringByAppendingPathComponents(components: [String]) -> String {
		return components.reduce(self) { ($0 as NSString).stringByAppendingPathComponent($1) }
	}
}

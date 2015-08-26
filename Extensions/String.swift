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
		
		self.enumerateSubstringsInRange(searchRange, options: NSStringEnumerationOptions.ByWords) { (_, _, _, _) -> () in
			numberOfWords++
		}
		
		return numberOfWords
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
}

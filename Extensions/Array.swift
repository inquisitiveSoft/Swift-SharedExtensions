//
//  Array.swift
//  Syml
//
//  Created by Harry Jordan on 24/07/2015.
//  Copyright © 2015 Inquisitive Software. All rights reserved/
//  Released under the MIT License: http://www.opensource.org/licenses/MIT
//


import Foundation


extension Array {
	
	subscript (safe index: Int) -> Element? {
		// Cribbed from StackOverflow
		return indices ~= index ? self[index] : nil
	}
	
}


extension Sequence where Iterator.Element == String {
    
    func contains(_ inputString: String, options: String.CompareOptions, compareFileExtensions: Bool = true) -> Bool {
        let searchString = compareFileExtensions ? inputString : (inputString as NSString).deletingPathExtension
        
        for element in self {
            let stringForComparison = compareFileExtensions ? element : (element as NSString).deletingPathExtension
            
            if searchString.compare(stringForComparison, options: options) == .orderedSame {
                return true
            }
        }
        
        return false
    }
    
}

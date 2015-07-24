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

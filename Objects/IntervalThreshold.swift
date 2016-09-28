//
//  IntervalThreshold.swift
//
//  Created by Harry Jordan on 05/12/2015.
//  Copyright © 2015 Inquisitive Software. All rights reserved.
//

import UIKit


class IntervalThreshold {
	var intervalBetweenCalls: TimeInterval = 1.0 / 30.0
	var actionBlock: (() -> ())?
	var actionQueue: DispatchQueue = DispatchQueue.main
	
	var shouldPerformAction: Bool = false
	var withinThresholdInterval: Bool = false
	
	
	func perform() {
		// Convoluted logics
		if !withinThresholdInterval, let actionBlock = actionBlock {
			shouldPerformAction = false
			withinThresholdInterval = true
			
			actionBlock()
			
			let interval = DispatchTime.now() + Double(Int64(intervalBetweenCalls * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
			actionQueue.asyncAfter(deadline: interval) { [unowned self] in
				self.withinThresholdInterval = false
				
				if self.shouldPerformAction {
					self.perform()
				}
			}
		} else {
			shouldPerformAction = true
		}
	}

}

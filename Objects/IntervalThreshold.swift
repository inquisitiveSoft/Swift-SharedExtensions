//
//  IntervalThreshold.swift
//
//  Created by Harry Jordan on 05/12/2015.
//  Copyright © 2015 Inquisitive Software. All rights reserved.
//

import UIKit


class IntervalThreshold {
	var intervalBetweenCalls: NSTimeInterval = 1.0 / 30.0
	var actionBlock: (() -> ())?
	var actionQueue: dispatch_queue_t = dispatch_get_main_queue()
	
	var shouldPerformAction: Bool = false
	var withinThresholdInterval: Bool = false
	
	
	func perform() {
		if !withinThresholdInterval, let actionBlock = actionBlock {
			shouldPerformAction = false
			withinThresholdInterval = true
			
			actionBlock()
			
			let interval = dispatch_time(DISPATCH_TIME_NOW, Int64(intervalBetweenCalls * Double(NSEC_PER_SEC)))
			dispatch_after(interval, actionQueue) {
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

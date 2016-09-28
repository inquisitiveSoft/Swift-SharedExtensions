//
//  Exceptions.swift
//  Syml
//
//  Created by Harry Jordan on 05/10/2015.
//  Copyright © 2015 Inquisitive Software. All rights reserved.
//

import Foundation



func catchExceptions(_ block: @escaping () -> Void, error exceptionHandlingBlock: TryExceptionBlock?) {
	try_block(block, exceptionHandlingBlock)
}

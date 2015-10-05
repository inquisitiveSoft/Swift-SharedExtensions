//
//  ExceptionsObjC.m
//  Syml
//
//  Created by Harry Jordan on 05/10/2015.
//  Copyright © 2015 Inquisitive Software. All rights reserved.
//

#import "ExceptionsObjC.h"


void try_block(__nonnull TryVoidBlock tryBlock, __nullable TryExceptionBlock exceptionHandlingBlock) {
	@try {
		tryBlock();
	}
	@catch (NSException *exception) {
		if(exception && exceptionHandlingBlock) {
			exceptionHandlingBlock(exception);
		}
	}
}
//
//  ExceptionsObjC.m
//  Syml
//
//  Created by Harry Jordan on 05/10/2015.
//  Copyright © 2015 Inquisitive Software. All rights reserved.
//

#import "ExceptionsObjC.h"


typedef void (^TryVoidBlock)(void);
typedef void (^TryExceptionBlock)(NSException * _Nonnull);


void try_block(__nonnull TryVoidBlock block, __nullable TryExceptionBlock exceptionHandlingBlock);
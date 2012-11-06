//
//  NSArrayAddition.h
//  LetterPressSolver
//
//  Created by Seraph on 11/5/12.
//  Copyright (c) 2012 lldong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Functional)
- (NSArray *)map:(id (^)(id))block;
- (NSArray *)filter:(BOOL (^)(id))block;
@end
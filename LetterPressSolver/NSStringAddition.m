//
//  NSStringAddition.m
//  LetterPressSolver
//
//  Created by Seraph on 11/5/12.
//  Copyright (c) 2012 lldong. All rights reserved.
//

#import "NSStringAddition.h"

@implementation NSString (LetterPressSolver)

- (NSArray *)toArray
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.length];
    for (NSUInteger i = 0; i < self.length; i++) {
        [array addObject:[self substringWithRange:NSMakeRange(i, 1)]];
    }

    return array;
}

@end
//
//  NSArrayAddition.m
//  LetterPressSolver
//
//  Created by Seraph on 11/5/12.
//  Copyright (c) 2012 lldong. All rights reserved.
//

#import "NSArrayAddition.h"


@implementation NSArray (Functional)

- (NSArray *)map:(id (^)(id))block
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [result addObject:block(obj)];
    }];
    return result;
}

- (NSArray *)filter:(BOOL (^)(id))block
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (block(obj)) [result addObject:obj];
    }];
    
    return result;
}

@end


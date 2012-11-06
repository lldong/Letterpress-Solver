//
//  Solver.h
//  LetterPressSolver
//
//  Created by Seraph on 11/6/12.
//  Copyright (c) 2012 lldong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Solver : NSObject
@property (nonatomic, copy) NSArray *answers;
- (void)encodeDictionary;
- (void)processLetters:(NSString *)letters onComplete:(void (^)())block;
@end

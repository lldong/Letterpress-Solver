//
//  LPSLetterModel.m
//  LetterPressSolver
//
//  Created by Seraph on 10/29/12.
//  Copyright (c) 2012 lldong. All rights reserved.
//

#import "LetterModel.h"

@interface LetterModel ()
@end

@implementation LetterModel

- (id)initWithLetter:(NSString *)letter
{
    if ((self = [super init])) {
        self.letter = letter;
    }

    return self;
}

@end

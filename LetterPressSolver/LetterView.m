//
//  LetterView.m
//  LetterPressSolver
//
//  Created by Seraph on 11/6/12.
//  Copyright (c) 2012 lldong. All rights reserved.
//

#import "LetterView.h"

@interface LetterView ()
@property (nonatomic) BOOL selected;
@end

@implementation LetterView

- (void)mouseDown:(NSEvent *)theEvent
{
    self.selected = !self.selected;
    NSColor *textColor = self.selected ? [NSColor colorWithCalibratedRed:0.417 green:0.569 blue:1.000 alpha:1.000]
                                       : [NSColor colorWithCalibratedWhite:0.248 alpha:1.000];
    [(NSTextField *)self.subviews[0] setTextColor:textColor];
}

@end

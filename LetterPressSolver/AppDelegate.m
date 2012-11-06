//
//  LPSAppDelegate.m
//  LetterPressSolver
//
//  Created by Seraph on 10/29/12.
//  Copyright (c) 2012 lldong. All rights reserved.
//

#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

#import "Solver.h"
#import "LetterModel.h"
#import "NSArrayAddition.h"
#import "NSStringAddition.h"

@interface AppDelegate ()
@property (nonatomic, strong) CALayer *instructionLayer;
@property (nonatomic, strong) Solver *solver;
@property (nonatomic, copy) NSIndexSet *selectedIndexes;

// Used for accepting inputs from keyboard
@property (nonatomic, strong) NSTextField *hiddenTextField;
@end

@implementation AppDelegate

- (void)awakeFromNib
{
    self.solver = [[Solver alloc] init];
    self.hiddenTextField = [[NSTextField alloc] initWithFrame:NSZeroRect];
    self.hiddenTextField.delegate = self;
    [self.window.contentView addSubview:self.hiddenTextField];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.letterModelArray = [NSMutableArray array];
    [self showInstruction:NSLocalizedString(@"Please Enter 25 Letters", nil)];
    [self.window makeFirstResponder:self.hiddenTextField];
}

#pragma mark - NSTableViewDataSource & NSTableViewDelegate

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return self.solver.answers.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    return [self.solver.answers objectAtIndex:row];
}

// Highlight the selected answer in the collection view
- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
    if (self.solver.answers.count == 0) return;
    
    NSUInteger row = self.tableView.selectedRow;
    NSString *answer = [[self.solver.answers objectAtIndex:row] lowercaseString];
    NSArray *letters = [[self inputLetters] toArray];

    for (NSUInteger i = 0; i < letters.count; i++) {
        [[[[self.collectionView itemAtIndex:i] view] layer] setBackgroundColor:[[NSColor clearColor] CGColor]];
        if ([answer rangeOfString:letters[i]].location != NSNotFound) {
            CGColorRef color;
            color =[[NSColor colorWithCalibratedRed:1.000 green:0.409 blue:0.493 alpha:1.000] CGColor];
            [[[self.collectionView itemAtIndex:i].view layer] setBackgroundColor:color];
        }
    }
}

- (NSString *)inputLetters
{
    NSMutableString *letters = [NSMutableString string];
    [self.letterModelArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [letters appendString:[[obj letter] lowercaseString]];
    }];

    return [letters lowercaseString];
}

# pragma mark - NSTextFieldDelegate

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor
{
    return !(self.letterModelArray.count < 25);
}

- (void)controlTextDidChange:(NSNotification *)notification
{
    [self dismissInstruction];
    NSString *inputString = self.hiddenTextField.stringValue;

    if (inputString.length == 1) {
        NSCharacterSet *charSet = [NSCharacterSet letterCharacterSet];
        if ([charSet characterIsMember:[inputString characterAtIndex:0]]) {
            if (self.letterModelArray.count < 25) {
                [[NSSound soundNamed:@"Tink"] play];
                [self.arrayController addObject:
                 [[LetterModel alloc] initWithLetter:inputString.capitalizedString]];

                // only accept 25 letters
                if (self.letterModelArray.count == 25) {
                    [self.hiddenTextField resignFirstResponder];
                    [self.hiddenTextField removeFromSuperview];

                    [self.indicator setHidden:NO];
                    [self.indicator startAnimation:nil];
                    [self.solver processLetters:[self inputLetters] onComplete:^{
                        [self.indicator setHidden:YES];
                        [self.indicator stopAnimation:nil];
                        [self.tableView reloadData];
                    }];
                }
            }
        }
        self.hiddenTextField.stringValue = @"";
    }
}

#pragma mark - IBActions

- (IBAction)reset:(id)sender
{
    [self.arrayController removeObjects:self.letterModelArray];
    [self.letterModelArray removeAllObjects];
    self.solver.answers = [NSArray array];

    [self.tableView reloadData];

    [self.window.contentView addSubview:self.hiddenTextField];
    [self.hiddenTextField becomeFirstResponder];
    [self showInstruction:NSLocalizedString(@"Please Enter 25 Letters", nil)];
}

- (IBAction)undo:(id)sender
{
    if (self.letterModelArray.count > 0) {
        [self.arrayController removeObjectAtArrangedObjectIndex:(self.letterModelArray.count - 1)];

        [self.window.contentView addSubview:self.hiddenTextField];
        [self.hiddenTextField becomeFirstResponder];
    } else {
        [self showInstruction:NSLocalizedString(@"Please Enter 25 Letters", nil)];
    }
}

#pragma mark - KVO

- (void)insertObject:(LetterModel *)letter inLetterModelArrayAtIndex:(NSUInteger)index
{
    [_letterModelArray insertObject:letter atIndex:index];
}

- (void)removeObjectFromLetterModelArrayAtIndex:(NSUInteger)index
{
    [_letterModelArray removeObjectAtIndex:index];
}

#pragma mark - Instruction View

- (void)showInstruction:(NSString *)text
{
    if (self.instructionLayer == nil) {
        CALayer *instructionLayer = [CALayer layer];
        instructionLayer.backgroundColor = [[NSColor blackColor] CGColor];
        instructionLayer.frame = CGRectMake(40, 200, 420, 70);
        instructionLayer.cornerRadius = 8.0;

        CATextLayer *textLayer = [CATextLayer layer];
        textLayer.frame = NSInsetRect(instructionLayer.bounds, 10.0, 15.0);
        textLayer.string = text;
        textLayer.alignmentMode = kCAAlignmentCenter;
        textLayer.font = (__bridge CFTypeRef)([NSFont boldSystemFontOfSize:40.0]);
        textLayer.fontSize = 30;
        [instructionLayer addSublayer:textLayer];

        self.instructionLayer = instructionLayer;
    }

    [self.collectionView.layer addSublayer:self.instructionLayer];

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.beginTime = CACurrentMediaTime();
    animation.duration = 0.3;
    animation.fromValue = @(0.0);
    animation.toValue = @(0.8);
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeBoth;
    animation.additive = NO;
    [self.instructionLayer addAnimation:animation forKey:nil];
}

- (void)dismissInstruction
{
    if (self.instructionLayer && self.instructionLayer.superlayer != nil) {
        [self.instructionLayer removeFromSuperlayer];
    }
}
@end
//
//  Solver.m
//  LetterPressSolver
//
//  Created by Seraph on 11/6/12.
//  Copyright (c) 2012 lldong. All rights reserved.
//

#import "Solver.h"
#import "NSArrayAddition.h"
#import "NSStringAddition.h"

@interface Solver ()
@property (nonatomic, copy) NSDictionary *encodedDictionary;
@end

@implementation Solver

- (id)init
{
    if ((self = [super init])) {
        self.answers = [NSArray array];
        [self loadDictionary];
    }

    return self;
}

- (void)loadDictionary
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"dictionary-bin" ofType:@"plist"];
    self.encodedDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
}

- (NSArray *)possibleWords:(NSString *)letters

{
    NSMutableArray *words = [NSMutableArray array];
    NSDictionary *occurrences = [self occurrencesForLetters:letters];

    NSArray *keys = [occurrences allKeys];

    [self.encodedDictionary enumerateKeysAndObjectsUsingBlock:^(id chars, id obj, BOOL *stop) {
        __block BOOL matched = YES;
        [[chars toArray] enumerateObjectsUsingBlock:^(id c, NSUInteger idx, BOOL *stop) {
            if ([keys indexOfObject:c] == NSNotFound) {
                matched = NO;
                *stop = YES;
            }
        }];

        if (matched) [words addObjectsFromArray:obj];
    }];

    NSArray *answers = [words filter:^BOOL(id word) {
        NSDictionary *wordOccurrences = [self occurrencesForLetters:word];
        __block BOOL matched = YES;
        [wordOccurrences enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if ([occurrences[key] integerValue] < [obj integerValue]) {
                matched = NO;
                *stop = YES;
            }
        }];

        return matched;
    }];

    return [answers sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj2 length] - [obj1 length];
    }];
}

- (void)processLetters:(NSString *)letters onComplete:(void (^)())block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        self.answers = [self possibleWords:letters];
        dispatch_async(dispatch_get_main_queue(), ^{
            block();
        });
    });
}

- (NSDictionary *)occurrencesForLetters:(NSString *)word
{
    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    for (NSString *ch in [word toArray]) {
        // Use the fact that [nil integerValue] return 0;
        d[ch] = @([d[ch] integerValue] + 1);
    }

    return d;
}

- (void)encodeDictionary
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"words" ofType:@"txt"];
    NSString *words = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];

    NSMutableDictionary *dictionaryOccurrences = [NSMutableDictionary dictionary];
    NSCharacterSet *uppercaseLetterSet = [NSCharacterSet uppercaseLetterCharacterSet];

    [words enumerateSubstringsInRange:NSMakeRange(0, words.length)
                              options:NSStringEnumerationByLines
                           usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                               if ([substring rangeOfCharacterFromSet:uppercaseLetterSet].length == 0
                                   && substringRange.length > 2)
                               {
                                   NSArray *letters = [[substring toArray] sortedArrayUsingSelector:@selector(compare:)];
                                   NSMutableString *key = [NSMutableString string];
                                   [letters enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                       if (idx == 0 || (idx > 0 && ![letters[idx - 1] isEqualToString:obj])) {
                                           [key appendString:obj];
                                       }
                                   }];

                                   if (dictionaryOccurrences[key]) {
                                       [dictionaryOccurrences[key] addObject:substring];
                                   } else {
                                       dictionaryOccurrences[key] = [@[substring] mutableCopy];
                                   }
                               }
                           }];
    //    [dictionaryOccurrences writeToFile:@"/Users/seraph/Desktop/dictionary.plist" atomically:NO];
}

@end

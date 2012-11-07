//
//  LPSLetterModel.h
//  LetterPressSolver
//
//  Created by Seraph on 10/29/12.
//  Copyright (c) 2012 lldong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LetterModel : NSObject
@property (nonatomic, copy) NSString *letter;
- (id)initWithLetter:(NSString *)letter;
@end
//
//  LPSAppDelegate.h
//  LetterPressSolver
//
//  Created by Seraph on 10/29/12.
//  Copyright (c) 2012 lldong. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate, NSTextFieldDelegate, NSTableViewDataSource, NSTableViewDelegate>
@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSTableView *tableView;
@property (assign) IBOutlet NSCollectionView *collectionView;
@property (assign) IBOutlet NSArrayController *arrayController;
@property (assign) IBOutlet NSProgressIndicator *indicator;
@property (nonatomic, strong) NSMutableArray *letterModelArray;

- (IBAction)reset:(id)sender;
- (IBAction)undo:(id)sender;
@end

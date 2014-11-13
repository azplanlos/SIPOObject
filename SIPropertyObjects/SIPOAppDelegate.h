//
//  SIPOAppDelegate.h
//  SIPropertyObjects
//
//  Created by Andreas Zöllner on 26.10.14.
//  Copyright (c) 2014 Studio Istanbul Medya Hiz. Tic. Ltd. Sti. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SIPODataView.h"

@interface SIPOAppDelegate : NSObject <NSApplicationDelegate, SIPODataViewProtocol>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSTreeController* contentController;
@property (assign) IBOutlet NSBrowser* browser;
@property (assign) IBOutlet NSView* valueView;
@property (assign) IBOutlet NSView* stringValueView;
@property (assign) IBOutlet NSView* boolValueView;
@property (assign) IBOutlet NSView* numberValueView;
@property (assign) IBOutlet SIPODataView* dataValueView;
@property (assign) IBOutlet NSView* colorValueView;


@property (strong, nonatomic) NSMutableArray* editorContent;

-(IBAction)addObject:(id)sender;
-(IBAction)deleteObject:(id)sender;

-(IBAction)save:(id)sender;
-(IBAction)load:(id)sender;

-(IBAction)changeType:(id)sender;

@end

//
//  SIPOAppDelegate.m
//  SIPropertyObjects
//
//  Created by Andreas Zöllner on 26.10.14.
//  Copyright (c) 2014 Studio Istanbul Medya Hiz. Tic. Ltd. Sti. All rights reserved.
//

#import "SIPOAppDelegate.h"
#import "SIPOObject.h"

@implementation SIPOAppDelegate
@synthesize editorContent, contentController, browser, valueView, stringValueView, boolValueView, numberValueView, dataValueView;

-(SIPOAppDelegate*)init {
    self = [super init];
    editorContent = [[NSMutableArray alloc] init];
    SIPOObject* rootObject = [[SIPOObject alloc] init];
    rootObject.name = @"root object";
    SIPOObject* childObject = [[SIPOObject alloc] init];
    childObject.name = @"child 1";
    [rootObject addObject:childObject];
    [editorContent addObject:rootObject];
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    NSLog(@"starting init");
    SIPOObject* rootObject = [[SIPOObject alloc] init];
    rootObject.name = @"root object 2";
    [contentController addObject:rootObject];
    [contentController add:self];
    [contentController rearrangeObjects];
    [contentController addObserver:self forKeyPath:@"selectionIndexPaths" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
                           context:nil];
    [dataValueView bind:@"contentData" toObject:contentController withKeyPath:@"selection.dataValue" options:nil];
    dataValueView.delegate = self;
    NSLog(@"finished init");
}

-(void)updateDataValue {
    NSLog(@"update");
    ((SIPOObject*)contentController.selectedObjects.lastObject).value = dataValueView.contentData;
}

-(void)assignTypeSubview {
    for (NSView* view in valueView.subviews) {
        [view removeFromSuperview];
    }
    if ([contentController selectedObjects].lastObject) {
        if (((SIPOObject*)contentController.selectedObjects.lastObject).type == SIPOObjectStringValue) {
            [valueView addSubview:stringValueView];
        } else if (((SIPOObject*)contentController.selectedObjects.lastObject).type == SIPOObjectBOOLValue) {
            [valueView addSubview:self.boolValueView];
        } else if (((SIPOObject*)contentController.selectedObjects.lastObject).type == SIPOObjectNumberValue) {
            [valueView addSubview:self.numberValueView];
        } else if (((SIPOObject*)contentController.selectedObjects.lastObject).type == SIPOObjectDataValue) {
            [valueView addSubview:self.dataValueView];
        }
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == contentController && [keyPath isEqualToString:@"selectionIndexPaths"]) {
        [self assignTypeSubview];
    }
}

-(NSMutableArray*)editorContent {
    NSLog(@"refreshing content");
    return editorContent;
}

-(IBAction)addObject:(id)sender {
    if ([contentController selectedObjects].count == 0) {
        [contentController addObject:[[SIPOObject alloc] init]];
    } else {
        //NSIndexPath* parentIndex = [contentController selectionIndexPath];
        [[[contentController selectedObjects] objectAtIndex:0] addObject:[[SIPOObject alloc] init]];
        //[contentController setSelectionIndexPath:[NSIndexPath indexPathWithIndex:0]];
        //[contentController setSelectionIndexPath:parentIndex];
        [contentController rearrangeObjects];
    }
}

-(IBAction)deleteObject:(id)sender {
    if (contentController.selectionIndexPath != nil) {
        [contentController removeObjectAtArrangedObjectIndexPath:contentController.selectionIndexPath];
    }
}

-(IBAction)save:(id)sender {
    NSSavePanel* savePanel = [NSSavePanel savePanel];
    [savePanel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result){
        [SIPOObject saveArray:[contentController content] toURL:savePanel.URL];
    }];
}

-(IBAction)load:(id)sender {
    NSOpenPanel* openPanel = [NSOpenPanel openPanel];
    [openPanel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
        if (result == NSOKButton) {
            editorContent = [SIPOObject arrayOfObjectsWithContentsOfURL:openPanel.URL];
            [contentController setContent:editorContent];
            [contentController rearrangeObjects];
            [browser loadColumnZero];
        }
    }];
}

-(IBAction)changeType:(id)sender {
    [self assignTypeSubview];
}



@end

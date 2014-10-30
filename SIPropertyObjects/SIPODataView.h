//
//  SIPODataView.h
//  SIPropertyObjects
//
//  Created by Andreas Zöllner on 28.10.14.
//  Copyright (c) 2014 Studio Istanbul Medya Hiz. Tic. Ltd. Sti. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol SIPODataViewProtocol

-(void)updateDataValue;

@end

@interface SIPODataView : NSView
@property (strong) NSData* contentData;
@property (weak) id<SIPODataViewProtocol> delegate;

@end

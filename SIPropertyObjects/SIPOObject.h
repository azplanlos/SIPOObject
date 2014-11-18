//
//  SIPOObject.h
//  SIPropertyObjects
//
//  Created by Andreas Zöllner on 26.10.14.
//  Copyright (c) 2014 Studio Istanbul Medya Hiz. Tic. Ltd. Sti. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SIPOObject : NSObject

@property (strong) NSString* name;
@property (strong, nonatomic) id value;
@property (strong) NSMutableArray* childs;
@property (assign, readonly) NSUInteger count;
@property (weak) SIPOObject* parent;
@property (assign, nonatomic) NSUInteger type;
@property (assign) BOOL boolValue;
@property (assign, nonatomic) NSNumber* numberValue;
@property (assign, nonatomic) NSNumber* boolTagValue;
@property (assign, nonatomic) NSData* dataValue;
@property (assign, nonatomic) NSColor* colorValue;


#define SIPOObjectStringValue   0
#define SIPOObjectNumberValue   1
#define SIPOObjectBOOLValue 2
#define SIPOObjectDataValue 3
#define SIPOObjectColorValue    4

+(void)saveArray:(NSArray*)array toURL:(NSURL*)fileURL;
+(NSMutableArray*)arrayOfObjectsWithContentsOfURL:(NSURL *)fileURL;

-(void)saveContentsToURL:(NSURL*)fileURL;
-(SIPOObject*)childWithName:(NSString*)name;
-(void)addObject:(SIPOObject*)childObject;

+(SIPOObject*)lastObjectInArray:(NSArray*)array atLevel:(NSInteger)level;
+(id)valueForName:(NSString*)name inArray:(NSArray*)array;
+(SIPOObject*)objectForName:(NSString*)name inArray:(NSArray*)array;

+(SIPOObject*)objectWithIntegerValue:(NSInteger)integerValue inArray:(NSArray*)array;
+(SIPOObject*)objectWithIntegerValue:(NSInteger)integerValue inArray:(NSArray*)array maxLevel:(NSInteger)level;
+(SIPOObject*)objectWithValue:(id)value inArray:(NSArray*)array;
+(SIPOObject*)objectWithValue:(id)value inArray:(NSArray*)array maxLevel:(NSInteger)level;


@end

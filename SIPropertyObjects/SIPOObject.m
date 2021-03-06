//
//  SIPOObject.m
//  SIPropertyObjects
//
//  Created by Andreas Zöllner on 26.10.14.
//  Copyright (c) 2014 Studio Istanbul Medya Hiz. Tic. Ltd. Sti. All rights reserved.
//

#import "SIPOObject.h"
#import "../Base64/Base64/Base64.h"
#import "NSString+Base64Additions.h"

@implementation SIPOObject

@synthesize name, childs, value, parent, type;

-(SIPOObject*)init {
    self = [super init];
    childs = [NSMutableArray array];
    self.name = @"noname";
    self.type = SIPOObjectStringValue;
    [self setDefaultValue];
    return self;
}

+(NSMutableArray*)arrayOfObjectsWithContentsOfURL:(NSURL *)fileURL {
    NSString* repString = [NSString stringWithContentsOfURL:fileURL encoding:NSUTF8StringEncoding error:nil];
    NSArray* lines = [repString componentsSeparatedByString:@"\n"];
    NSMutableArray* contents = [[NSMutableArray alloc] init];
    NSRegularExpression* regexp = [NSRegularExpression regularExpressionWithPattern:@" {4}" options:NSRegularExpressionCaseInsensitive error:nil];
    for (NSString* xline in lines) {
        NSString* line = xline;
        line = [regexp stringByReplacingMatchesInString:line options:0 range:NSMakeRange(0, line.length) withTemplate:@"\t"];
        if ([line rangeOfString:@"\t"].location != NSNotFound) {
            NSArray* components = [line componentsSeparatedByString:@"\t"];
            NSInteger level = 0;
            while (((NSString*)[components objectAtIndex:level]).length == 0) {
                level++;
            }
            SIPOObject* myRootObject = [[SIPOObject alloc] init];
            
            myRootObject.type = [[components objectAtIndex:level+1] intValue];
            
            myRootObject.name = [components objectAtIndex:level];
            
            NSString* valueString = [components objectAtIndex:level+2];
            if ([valueString rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location != NSNotFound) {
                valueString = [valueString substringToIndex:[valueString rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location-1];
            }
            
            if (myRootObject.type == SIPOObjectStringValue) {
                if ([valueString isBase64Data]) {
                    valueString = [valueString base64DecodedString];
                }
                myRootObject.value = valueString;
            } else if (myRootObject.type == SIPOObjectBOOLValue) {
                myRootObject.boolValue = [valueString isEqualToString:@"<@YES>"] ? YES : NO;
            } else if (myRootObject.type == SIPOObjectNumberValue) {
                myRootObject.numberValue = [NSDecimalNumber decimalNumberWithString:valueString locale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
            } else if (myRootObject.type == SIPOObjectDataValue) {
                myRootObject.dataValue = [valueString base64DecodedData];
            } else if (myRootObject.type == SIPOObjectColorValue) {
                NSArray* colorComps = [valueString componentsSeparatedByString:@"/"];
                NSColor* col = [NSColor colorWithCalibratedRed:[[colorComps objectAtIndex:0] doubleValue] green:[[colorComps objectAtIndex:1] doubleValue] blue:[[colorComps objectAtIndex:2] doubleValue] alpha:[[colorComps objectAtIndex:3] doubleValue]];
                myRootObject.colorValue = col;
            }
            
            id parent = contents;
            if (level > 0) parent = [self lastObjectInArray:contents atLevel:level-1];
            [parent addObject:myRootObject];
        }
    }
    return contents;
}

-(NSUInteger)count {
    return childs.count;
}

+(void)saveArray:(NSArray*)array toURL:(NSURL *)fileURL {
    NSString* content = [NSString string];
    for (SIPOObject* object in array) {
        content = [content stringByAppendingFormat:@"%@\n", [object stringRepresentationAtLevel:0]];
    }
    [content writeToURL:fileURL atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

-(void)saveContentsToURL:(NSURL *)fileURL {
    [SIPOObject saveArray:[NSArray arrayWithObject:self] toURL:fileURL];
}

-(NSString*)stringRepresentationAtLevel:(int)level {
    NSString* levelString = @"";
    for (int i = 0; i <= level; i++) levelString = [levelString stringByAppendingFormat:@"\t"];
    id xvalue = value;
    
    NSMutableCharacterSet* charSet = [NSCharacterSet alphanumericCharacterSet];
    [charSet addCharactersInString:@" "];
    [charSet invert];
    
    if (self.type == SIPOObjectStringValue && [value rangeOfCharacterFromSet:charSet].location != NSNotFound) {
        xvalue = [value base64EncodedString];
    } else if (self.type == SIPOObjectNumberValue) {
        xvalue = [value descriptionWithLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    } else if (self.type == SIPOObjectBOOLValue) {
        xvalue = self.boolValue ? @"<@YES>" : @"<@NO>";
    } else if (self.type == SIPOObjectDataValue) {
        xvalue = [self.dataValue base64EncodedString];
    } else if (self.type == SIPOObjectColorValue) {
        CGFloat red, green, blue, alpha;
        [self.colorValue getRed:&red green:&green blue:&blue alpha:&alpha];
        xvalue = [NSString stringWithFormat:@"%0.3f/%0.3f/%0.3f/%0.3f", red, green, blue, alpha];
    }
    NSString* repString = [NSString stringWithFormat:@"%@\t%li\t%@\n", name, type, xvalue];
    for (SIPOObject* child in childs) {
        repString = [repString stringByAppendingFormat:@"%@%@",levelString, [child stringRepresentationAtLevel:level+1] ];
    }
    return repString;
}

+(SIPOObject*)lastObjectInArray:(NSArray*)array atLevel:(NSInteger)level {
    if (level != 0) {
        SIPOObject* root = array.lastObject;
        for (int i = 1; i<=level; i++) {
            root = root.childs.lastObject;
        }
        return root;
    } else {
        return array.lastObject;
    }
}

-(void)addObject:(SIPOObject*)childObject {
    childObject.parent = self;
    [self.childs addObject:childObject];
}

-(void)setValue:(id)xvalue {
    if (self.type == SIPOObjectBOOLValue) {
        value = ([xvalue intValue] == 0) ? [NSNumber numberWithBool:YES] : [NSNumber numberWithBool:NO];
    } else {
        value = xvalue;
    }
}

-(id)value {
    if (self.type == SIPOObjectBOOLValue) {
        return ([value boolValue] == YES) ? [NSNumber numberWithInt:0] : [NSNumber numberWithInt:1];
    } else {
        return value;
    }
}

-(BOOL)boolValue {
    if (self.type == SIPOObjectBOOLValue) {
        return [value boolValue];
    } else {
        return YES;
    }
}

-(void)setBoolValue:(BOOL)boolValue {
    value = [NSNumber numberWithBool:boolValue];
}

-(void)setDefaultValue {
    if (type == SIPOObjectNumberValue)
        value = @(0);
    else if (type == SIPOObjectBOOLValue)
        value = @(YES);
    else if (type == SIPOObjectDataValue)
        value = [NSData data];
    else
        value = @"not defined";
}

-(void)setType:(NSUInteger)newType {
    type = newType;
    [self setDefaultValue];
}

-(NSNumber*)numberValue {
    if ([value isKindOfClass:[NSNumber class]]) {
        return value;
    } else {
        return [NSNumber numberWithInt:0];
    }
}

-(void)setNumberValue:(NSNumber *)numberValue {
    value = numberValue;
}

-(NSNumber*)boolTagValue {
    if (self.type == SIPOObjectBOOLValue && [value isKindOfClass:[NSNumber class]]) {
        return ([value boolValue] == YES) ? [NSNumber numberWithInt:0] : [NSNumber numberWithInt:1];
    } else {
        return [NSNumber numberWithInt:0];
    }
}

-(void)setBoolTagValue:(NSNumber *)boolTagValue {
    value = ([boolTagValue intValue] == 0) ? [NSNumber numberWithBool:YES] : [NSNumber numberWithBool:NO];
}

-(NSData*)dataValue {
    if (self.type == SIPOObjectDataValue) return value;
    return nil;
}

-(void)setDataValue:(NSData *)dataValue {
    self.value = dataValue;
}

-(NSColor*)colorValue {
    if (self.type == SIPOObjectColorValue) return value;
    return nil;
}

-(void)setColorValue:(NSColor *)colorValue {
    self.value = colorValue;
}

-(SIPOObject*)childWithName:(NSString *)sname {
    for (SIPOObject* child in self.childs) {
        if ([child.name isEqualToString:sname]) {
            return child;
        }
    }
    return nil;
}

+(id)valueForName:(NSString*)name inArray:(NSArray*)array {
    return [SIPOObject objectForName:name inArray:array].value;
}

+(SIPOObject*)objectForName:(NSString *)name inArray:(NSArray *)array {
    SIPOObject* obj = nil;
    for (SIPOObject* sobj in array) {
        if ([sobj.name isEqualToString:name]) {
            obj = sobj;
        } else {
            obj = [sobj childWithName:name];
        }
        if (obj) break;
    }
    if (!obj) NSLog(@"object with name %@ not found", name);
    return obj;
}

+(SIPOObject*)objectWithValue:(id)svalue inArray:(NSArray *)array maxLevel:(NSInteger)level {
    SIPOObject* obj = nil;
    for (SIPOObject* sobj in array) {
        if (sobj.type != SIPOObjectBOOLValue) {
            if ([sobj.value isEqualTo:svalue]) {
                obj = sobj;
                break;
            }
        }
        if (sobj.childs.count > 0 && level > 0 && !obj) {
            obj = [SIPOObject objectWithValue:svalue inArray:sobj.childs maxLevel:level-1];
            if (obj) break;
        }
    }
    return obj;
}

+(SIPOObject*)objectWithIntegerValue:(NSInteger)integerValue inArray:(NSArray *)array {
    return [SIPOObject objectWithValue:[NSNumber numberWithInteger:integerValue] inArray:array maxLevel:NSIntegerMax];
}

+(SIPOObject*)objectWithIntegerValue:(NSInteger)integerValue inArray:(NSArray *)array maxLevel:(NSInteger)level {
    return [SIPOObject objectWithValue:[NSNumber numberWithInteger:integerValue] inArray:array maxLevel:level];
}


+(SIPOObject*)objectWithValue:(id)value inArray:(NSArray *)array {
    return [SIPOObject objectWithValue:value inArray:array maxLevel:NSIntegerMax];
}

@end

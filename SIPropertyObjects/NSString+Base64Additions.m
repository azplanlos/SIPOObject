//
//  NSString+Base64Additions.m
//  SIPropertyObjects
//


#import "NSString+Base64Additions.h"

@implementation NSString (MDBase64Additions)

- (BOOL)isBase64Data {
    if ([self length] % 4 == 0) {
        static NSCharacterSet *invertedBase64CharacterSet = nil;
        if (invertedBase64CharacterSet == nil) {
            invertedBase64CharacterSet = [[NSCharacterSet
                                            characterSetWithCharactersInString:
                                            @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="]
                                           invertedSet];
        }
        return [self rangeOfCharacterFromSet:invertedBase64CharacterSet
                                     options:NSLiteralSearch].location == NSNotFound;
    }
    return NO;
}

@end

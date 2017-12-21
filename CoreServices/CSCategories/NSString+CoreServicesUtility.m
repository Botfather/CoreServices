//
//  NSString+CoreServicesUtility.m
//  CoreServices
//
//  Created by Tushar Mohan on 24/11/17.
//  Copyright © 2017 io.github.botfather. All rights reserved.
//

#import "NSString+CoreServicesUtility.h"

#define kESCAPED_CHARACTERS @" \"#%/:<>?@[\\]^`={|}"

@implementation NSString (CoreServicesUtility)

+ (NSString*)createEncodedURLFrom:(NSString*)stringToEncode {
    NSCharacterSet* URLCombinedCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:kESCAPED_CHARACTERS] invertedSet];
    NSString *escapedString = [stringToEncode stringByAddingPercentEncodingWithAllowedCharacters:URLCombinedCharacterSet];
    
    return escapedString;
}

-(BOOL)isNilEmptyOrWhiteSpace {
    return [NSString isNilEmptyOrWhiteSpace:self];
}

+(BOOL)isNilEmptyOrWhiteSpace:(NSString*)value {
    BOOL isNilOrEmpty = NO;
    if (value == nil) {
        isNilOrEmpty = YES;
    }else if (value.length == 0){
        isNilOrEmpty = YES;
    }else if ([value stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0){
        isNilOrEmpty = YES;
    }
    
    return isNilOrEmpty;
}

- (NSString*)fullURIFromParameters:(NSMutableDictionary*)parameters {
    
    if (!parameters)
        return self;
    
    if(([self rangeOfString:@":"].location == NSNotFound))
        return [self appendGETRequestFields:parameters inString:self];
    
    __block NSMutableArray *keysToRemove = [NSMutableArray array];
    __block NSString       *fullURI = [NSMutableString stringWithString:self];
    
    [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        NSString* updatedKey   = [NSString stringWithFormat:@":%@", key];
        NSString* updatedVal = [NSString stringWithFormat:@"%@", obj];
        
        if ([fullURI rangeOfString:updatedKey options:NSCaseInsensitiveSearch].location != NSNotFound) {
            fullURI = [fullURI stringByReplacingOccurrencesOfString:updatedKey withString:updatedVal options:NSCaseInsensitiveSearch range:NSMakeRange(0, [fullURI length])];
            [keysToRemove addObject:key];
        }
    }];
    
    [keysToRemove enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [parameters removeObjectForKey:obj];
    }];
    
    return [self appendGETRequestFields:parameters inString:fullURI];
}

- (NSString*)appendGETRequestFields:(NSMutableDictionary*)parameters inString:(NSString*)string {
    
    __block NSMutableString* finalURI = [NSMutableString stringWithString:string];

    [finalURI appendString:@"?"];
    
    [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [finalURI appendString:[NSString stringWithFormat:@"%@=%@&",key,obj]];
    }];
    
    [finalURI deleteCharactersInRange:NSMakeRange([finalURI length]-1, 1)];

    return finalURI;
}

@end

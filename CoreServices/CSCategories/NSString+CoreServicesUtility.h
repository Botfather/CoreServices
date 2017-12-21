//
//  NSString+CoreServicesUtility.h
//  CoreServices
//
//  Created by Tushar Mohan on 24/11/17.
//  Copyright © 2017 io.github.botfather. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface NSString (CoreServicesUtility)

+ (NSString*)createEncodedURLFrom:(NSString*)stringToEncode;

- (BOOL)isNilEmptyOrWhiteSpace;
- (NSString*)fullURIFromParameters:(NSMutableDictionary*)parameters;

@end

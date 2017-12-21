//
//  NSDictionary+CoreServicesUtility.m
//  CoreServices
//
//  Created by Tushar Mohan on 24/11/17.
//  Copyright © 2017 io.github.botfather. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (CoreServicesUtility)

/**
 Inits from a file of the specified name and type from the main bundle.

 @param name file name
 @param type extension of the file
 @return NSDictionary from the file's contents or nil in case something goes wrong
 */
+ (instancetype)initFromFile:(NSString*)name ofType:(NSString*)type;

/**
 String object for the corresponding key

 @param key target object's key
 @return value corresponding to the  key provided
 */
-(NSString*)stringForKey:(NSString *)key;

@end

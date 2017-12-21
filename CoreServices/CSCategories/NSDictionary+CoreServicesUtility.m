//
//  NSDictionary+CoreServicesUtility.m
//  CoreServices
//
//  Created by Tushar Mohan on 24/11/17.
//  Copyright © 2017 io.github.botfather. All rights reserved.
//

#import "NSDictionary+CoreServicesUtility.h"

@implementation NSDictionary (CoreServicesUtility)

+ (instancetype)initFromFile:(NSString*)name ofType:(NSString*)type {
    NSString* connectionsPath = [[NSBundle mainBundle] pathForResource:name ofType:type];
    NSData* jsonFileData = [NSData dataWithContentsOfFile:connectionsPath];
    NSError* error;
    NSDictionary* endPoints = [NSJSONSerialization JSONObjectWithData:jsonFileData
                                                         options:kNilOptions
                                                                error:&error];
    return endPoints;
   
}

- (NSString*)stringForKey:(NSString*)key {
    return [self objectForKey:key expectedClass:[NSString class]];
}

#pragma mark - Private Helpers

/**
 The following method will check for a key's presence inside a dictionary and then validate it against the
 expected class that we provide. In case the object does not correspond to the desired type of class, the
 method then alloc-inits the class from the expected type we provide. This will guard against
 the crashes at run time due to "nil" or object incompatibility.

 @param key key to look for in Dictionary
 @param expClass the type of object (Class) that is expected from the returned object
 @return value corresponding to the key provided
 */
- (id)objectForKey:(NSString*)key expectedClass:(Class)expClass {
    id object = self[key];
    if ( [object isKindOfClass:expClass]) {
        return object;
    }
    NSLog(@"CoreServices_Parsing Error <NSDictionary>: Failed to load value for %@",key);
    return [[expClass alloc] init];
}

@end

//
//  Services.m
//
//  Created by Tushar Mohan on 24/11/17.
//  Copyright © 2017 io.github.botfather. All rights reserved.
//

#import "WSMServices.h"
#import "WSMEndpoints.h"
#import "WSMHeaders.h"

NSString *const kServicesBaseUrl = @"base_url";
NSString *const kServicesEndpoints = @"endpoints";
NSString *const kServicesActiveStatus = @"active_status";
NSString *const kServicesHeaders = @"headers";

@implementation WSMServices

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.baseUrl = [self objectOrNilForKey:kServicesBaseUrl fromDictionary:dict];
    NSObject *receivedEndpoints = [dict objectForKey:kServicesEndpoints];
    NSMutableArray *parsedEndpoints = [NSMutableArray array];
    
    if ([receivedEndpoints isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedEndpoints) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedEndpoints addObject:[WSMEndpoints modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedEndpoints isKindOfClass:[NSDictionary class]]) {
       [parsedEndpoints addObject:[WSMEndpoints modelObjectWithDictionary:(NSDictionary *)receivedEndpoints]];
    }

    self.endpoints = [NSArray arrayWithArray:parsedEndpoints];
            self.activeStatus = [[self objectOrNilForKey:kServicesActiveStatus fromDictionary:dict] boolValue];
            self.headers = [WSMHeaders modelObjectWithDictionary:[dict objectForKey:kServicesHeaders]];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.baseUrl forKey:kServicesBaseUrl];
    NSMutableArray *tempArrayForEndpoints = [NSMutableArray array];
    
    for (NSObject *subArrayObject in self.endpoints) {
        if ([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForEndpoints addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForEndpoints addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForEndpoints] forKey:kServicesEndpoints];
    [mutableDict setValue:[NSNumber numberWithBool:self.activeStatus] forKey:kServicesActiveStatus];
    [mutableDict setValue:[self.headers dictionaryRepresentation] forKey:kServicesHeaders];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description  {
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict {
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}

@end

//
//  Config.m
//
//  Created by Tushar Mohan on 24/11/17.
//  Copyright © 2017 io.github.botfather. All rights reserved.
//

#import "WSMConfig.h"
#import "WSMServices.h"

NSString *const kConfigApiSecret = @"api_secret";
NSString *const kConfigServices = @"services";
NSString *const kConfigName = @"name";
NSString *const kConfigApiKey = @"api_key";

@implementation WSMConfig

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.apiSecret = [self objectOrNilForKey:kConfigApiSecret fromDictionary:dict];
    NSObject *receivedServices = [dict objectForKey:kConfigServices];
    NSMutableArray *parsedServices = [NSMutableArray array];
    
    if ([receivedServices isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedServices) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedServices addObject:[WSMServices modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedServices isKindOfClass:[NSDictionary class]]) {
       [parsedServices addObject:[WSMServices modelObjectWithDictionary:(NSDictionary *)receivedServices]];
    }

    self.services = [NSArray arrayWithArray:parsedServices];
            self.name = [self objectOrNilForKey:kConfigName fromDictionary:dict];
            self.apiKey = [self objectOrNilForKey:kConfigApiKey fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.apiSecret forKey:kConfigApiSecret];
    NSMutableArray *tempArrayForServices = [NSMutableArray array];
    
    for (NSObject *subArrayObject in self.services) {
        if ([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForServices addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForServices addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForServices] forKey:kConfigServices];
    [mutableDict setValue:self.name forKey:kConfigName];
    [mutableDict setValue:self.apiKey forKey:kConfigApiKey];

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

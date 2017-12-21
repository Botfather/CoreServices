//
//  Endpoints.m
//
//  Created by Tushar Mohan on 24/11/17.
//  Copyright © 2017 io.github.botfather. All rights reserved.
//

#import "WSMEndpoints.h"


NSString *const kEndpointsStatus = @"status";
NSString *const kEndpointsMethod = @"method";
NSString *const kEndpointsName = @"name";
NSString *const kEndpointsUri = @"uri";

@implementation WSMEndpoints

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.status = [[self objectOrNilForKey:kEndpointsStatus fromDictionary:dict] boolValue];
            self.method = [self objectOrNilForKey:kEndpointsMethod fromDictionary:dict];
            self.name = [self objectOrNilForKey:kEndpointsName fromDictionary:dict];
            self.uri = [self objectOrNilForKey:kEndpointsUri fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithBool:self.status] forKey:kEndpointsStatus];
    [mutableDict setValue:self.method forKey:kEndpointsMethod];
    [mutableDict setValue:self.name forKey:kEndpointsName];
    [mutableDict setValue:self.uri forKey:kEndpointsUri];

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

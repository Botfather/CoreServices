//
//  BaseClass.m
//
//  Created by Tushar Mohan on 24/11/17.
//  Copyright © 2017 io.github.botfather. All rights reserved.
//

#import "WSMBaseClass.h"
#import "WSMConfig.h"

NSString *const kBaseClassConfig = @"Config";


@implementation WSMBaseClass

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
    NSObject *receivedConfig = [dict objectForKey:kBaseClassConfig];
    NSMutableArray *parsedConfig = [NSMutableArray array];
    
    if ([receivedConfig isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedConfig) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedConfig addObject:[WSMConfig modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedConfig isKindOfClass:[NSDictionary class]]) {
       [parsedConfig addObject:[WSMConfig modelObjectWithDictionary:(NSDictionary *)receivedConfig]];
    }

    self.config = [NSArray arrayWithArray:parsedConfig];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForConfig = [NSMutableArray array];
    
    for (NSObject *subArrayObject in self.config) {
        if ([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForConfig addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForConfig addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForConfig] forKey:kBaseClassConfig];

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

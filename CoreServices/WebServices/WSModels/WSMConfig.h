//
//  Config.h
//
//  Created by Tushar Mohan on 24/11/17.
//  Copyright © 2017 io.github.botfather. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSMConfig : NSObject

@property (nonatomic, strong) NSString *apiSecret;
@property (nonatomic, strong) NSArray *services;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *apiKey;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end

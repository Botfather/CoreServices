//
//  Services.h
//
//  Created by Tushar Mohan on 24/11/17.
//  Copyright © 2017 io.github.botfather. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WSMHeaders;

@interface WSMServices : NSObject

@property (nonatomic, strong) NSString *baseUrl;
@property (nonatomic, strong) NSArray *endpoints;
@property (nonatomic, assign) BOOL activeStatus;
@property (nonatomic, strong) WSMHeaders *headers;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end

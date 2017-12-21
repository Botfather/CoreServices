//
//  Headers.h
//
//  Created by Tushar Mohan on 24/11/17.
//  Copyright © 2017 io.github.botfather. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSMHeaders : NSObject

@property (nonatomic, strong) NSString *contentType;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end

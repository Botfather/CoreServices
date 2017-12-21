//
//  Endpoints.h
//
//  Created by Tushar Mohan on 24/11/17.
//  Copyright © 2017 io.github.botfather. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSMEndpoints : NSObject

@property (nonatomic, assign) BOOL status;
@property (nonatomic, strong) NSString *method;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *uri;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end

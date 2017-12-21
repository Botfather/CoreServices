//
//  WebServiceRequestBuilder.h
//  WebServicesManager
//
//  Created by Tushar Mohan on 24/11/17.
//  Copyright © 2017 io.github.botfather. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WSMConfig;

typedef NS_ENUM(NSUInteger,EWSMServiceType) {
    EWSMServiceTypeProduction = 0,
    EWSMServiceTypeDevelopment
};

@interface WebServiceRequestBuilder : NSObject

+ (NSMutableURLRequest*)makeRequestForService:(NSString*)service
                                 fromProvider:(WSMConfig*)provider
                                         mode:(EWSMServiceType)mode
                                       header:(NSDictionary*)headerDict
                                         body:(NSDictionary*)bodyDict
                                   parameters:(NSDictionary*)parameter;

@end

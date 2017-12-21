//
//  WebServicesManager.h
//  WebServicesManager
//
//  Created by Tushar Mohan on 24/11/17.
//  Copyright © 2017 io.github.botfather. All rights reserved.
//

#import "WebServiceRequestBuilder.h"
#import <Foundation/Foundation.h>

typedef void (^WebserviceCompletionHandler)(NSData* _Nullable data,NSError* _Nullable error );

typedef NS_ENUM(NSUInteger,EWSMServiceProviderType) {
    EWSMServiceProviderTypeNative = 0,
    //EWSMServiceProviderTypeGoogle,
    //... varies from app to app. Add in plist under "config", Eg: Item[0] = native,Item[1] = Google,etc..
    //EWSMServiceProviderTypeZomato...
};

@interface WebServicesManager : NSObject

+ (void)initFor:(EWSMServiceType)serviceType;

+ (NSMutableURLRequest*_Nullable)makeRequestForService:(NSString*_Nonnull)service
                                          fromProvider:(EWSMServiceProviderType)provider
                                                header:(NSDictionary*_Nullable)headerDict
                                                  body:(NSDictionary* _Nullable)bodyDict
                                            parameters:(NSDictionary*_Nullable)parameters;

+ (NSURLSessionDataTask*_Nullable)sendRequest:(NSMutableURLRequest*_Nonnull)request
                             completionHandler:(WebserviceCompletionHandler _Nullable)completionBlock;

@end

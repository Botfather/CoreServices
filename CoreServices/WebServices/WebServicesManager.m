//
//  WebServicesManager.m
//  WebServicesManager
//
//  Created by Tushar Mohan on 24/11/17.
//  Copyright © 2017 io.github.botfather. All rights reserved.
//

#import "WSMBaseClass.h"
#import "NSString+CoreServicesUtility.h"
#import "NSDictionary+CoreServicesUtility.h"
#import "NSMutableURLRequest+WebServicesUtility.h"
#import "WebServicesManager.h"
#import <UIKit/UIKit.h>

#define kHTTP_SUCCESS_CODES statusCode == 200 || statusCode == 201 || statusCode == 202 || statusCode == 203
#define kHTTP_CLIENT_ERRORS statusCode == 400 || statusCode == 401 || statusCode == 403 || statusCode == 404

@interface WebServicesManager ()

@property EWSMServiceType serviceMode;
@property WSMBaseClass* connections;

@end

@implementation WebServicesManager

#pragma mark - Public

+ (void)initFor:(EWSMServiceType)serviceType {
    
    [WebServicesManager sharedInstance].serviceMode = serviceType;
}

+ (NSMutableURLRequest*)makeRequestForService:(NSString *)service
                                 fromProvider:(EWSMServiceProviderType)provider
                                       header:(NSDictionary *)headerDict
                                         body:(NSDictionary *)bodyDict
                                   parameters:(NSDictionary *)parameters {
    
    if([service isNilEmptyOrWhiteSpace])
        return nil;
    
    EWSMServiceType mode = [self getMode];

    return [WebServiceRequestBuilder makeRequestForService:service fromProvider:[WebServicesManager sharedInstance].connections.config[provider] mode:mode header:headerDict body:bodyDict parameters:parameters];
}

+ (NSURLSessionDataTask*)sendRequest:(NSMutableURLRequest*)request
                   completionHandler:(WebserviceCompletionHandler)completionBlock {
    
    [request printRequest];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSURLSessionDataTask* dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                     completionHandler:^(NSData* responseData,NSURLResponse* response, NSError* error) {
                                                                         
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        NSUInteger statusCode = [httpResponse statusCode];
       
    dispatch_async(dispatch_get_main_queue(), ^ {
       [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if (kHTTP_SUCCESS_CODES) {
            
                completionBlock(responseData, error);
            
        }
        else {
            
                NSDictionary* errorDict = nil;
                
                if (responseData) {
                    errorDict = [NSJSONSerialization
                                 JSONObjectWithData:responseData options:kNilOptions error:nil];
                }
                
                NSString* errorString = (errorDict) ? [errorDict objectForKey:@"message"] : @"Service Error";
                NSError* errorInfo = [NSError errorWithDomain:@"Server error" code:statusCode userInfo:[NSDictionary dictionaryWithObjectsAndKeys:errorString,NSLocalizedDescriptionKey, nil]];
                
                completionBlock(nil,errorInfo);
            
        }
        });
    }];
    
    [dataTask resume];
    
    return dataTask;
}

#pragma mark - Private

+ (EWSMServiceType)getMode {
    return [WebServicesManager sharedInstance].serviceMode;
}

#pragma mark - Internal

+ (instancetype _Nullable)sharedInstance {
    
    static WebServicesManager*_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[WebServicesManager alloc] initForSingleton];
    });
    
    return _sharedInstance;
}

- (instancetype)initForSingleton {
    
    self = [super init];
    
    if(self) {
        self.connections = [WSMBaseClass modelObjectWithDictionary:[NSDictionary initFromFile:@"EndPoints" ofType:@"json"]];
    }
    
    return self;
}

@end

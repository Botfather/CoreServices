//
//  WebServiceRequestBuilder.m
//  WebServicesManager
//
//  Created by Tushar Mohan on 24/11/17.
//  Copyright © 2017 io.github.botfather. All rights reserved.
//

#import "WSMBaseClass.h"
#import "WSMConfig.h"
#import "WSMServices.h"
#import "WSMHeaders.h"
#import "WSMEndpoints.h"
#import "NSString+CoreServicesUtility.h"
#import "WebServiceRequestBuilder.h"

@implementation WebServiceRequestBuilder

+ (NSMutableURLRequest*)makeRequestForService:(NSString*)service
                                 fromProvider:(WSMConfig*)provider
                                         mode:(EWSMServiceType)mode
                                       header:(NSDictionary*)headerDict
                                         body:(NSDictionary*)bodyDict
                                   parameters:(NSDictionary*)parameter {
    
    WSMServices* serviceData = provider.services[mode];
    
    if(!serviceData.activeStatus)
        return nil; //because its not active from plist
    
    WSMEndpoints* endPoint = [self getEndpointFor:service from:serviceData];
    
    NSString* requestedURLString = [NSString stringWithFormat:@"%@%@",serviceData.baseUrl,[self getExpandedURIFor:endPoint.uri parameters:parameter]];
    
    NSURL* requestURL = [NSURL URLWithString:requestedURLString];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:requestURL];
    
    [request setHTTPMethod:[[endPoint.method uppercaseString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    
    [self setUpHeaders:headerDict to:request service:serviceData];
    
    if(bodyDict)
        [self setUpBody:bodyDict to:request];
    
    return request;
}

+ (NSString*)getExpandedURIFor:(NSString*)endPointURL
                     parameters:(NSDictionary*)parameters {
    
    return (endPointURL == nil)? @"" : [endPointURL fullURIFromParameters:[NSMutableDictionary dictionaryWithDictionary:parameters]];
}

+ (void)setUpHeaders:(NSDictionary*)headers to:(NSMutableURLRequest*)request service:(WSMServices*)serviceData {
    
    NSMutableDictionary* finalisedHeaders = [NSMutableDictionary dictionaryWithDictionary:headers];
    [finalisedHeaders addEntriesFromDictionary:[serviceData.headers dictionaryRepresentation]];
    
    for(NSString* key in finalisedHeaders.allKeys)
    {
        [request setValue:finalisedHeaders[key] forHTTPHeaderField:key];
    }
    
}

+ (void)setUpBody:(NSDictionary*)body to:(NSMutableURLRequest*)request {
    
    NSError* error;
    NSData *postBody = [NSJSONSerialization dataWithJSONObject:body options:0 error:&error];
    
    [request setHTTPBody:postBody];
    [request setValue:[NSString stringWithFormat:@"%lu",(unsigned long)[postBody length]] forHTTPHeaderField:@"Content-Length"];
}

#pragma mark - Helper

+ (WSMEndpoints*)getEndpointFor:(NSString*)serviceName from:(WSMServices*)serviceData {
    
    WSMEndpoints* targetEndpoint;
    
    for (WSMEndpoints* endPoint in serviceData.endpoints) {
        if(([endPoint.name isEqualToString:serviceName])&&(endPoint.status == YES)) {
            targetEndpoint = endPoint;
        }
    }
    
    return targetEndpoint;
}

@end

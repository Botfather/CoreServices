//
//  NSMutableURLRequest+WebServicesUtility.m
//  CoreServices
//
//  Created by Tushar Mohan on 24/11/17.
//  Copyright © 2017 io.github.botfather. All rights reserved.
//

#import "NSMutableURLRequest+WebServicesUtility.h"

@implementation NSMutableURLRequest (WebServicesUtility)

- (void)printRequest {
    
    NSMutableString* debugString = [NSMutableString stringWithFormat:@"\n-----REQUEST-----\n-URL: %@", self.URL.absoluteString];
    
    [debugString appendString:[NSString stringWithFormat:@"\n-METHOD: %@",self.HTTPMethod]];
    
    for (NSString *key in self.allHTTPHeaderFields.allKeys) {
        NSString *value = [self.allHTTPHeaderFields objectForKey:key];
        [debugString appendFormat:@"\n-H '%@: %@'", key, value];
    }
    
    NSString *bodyDataString = [[NSString alloc] initWithData:self.HTTPBody encoding:NSUTF8StringEncoding];
    if (bodyDataString.length) {
        
        [debugString appendFormat:@"\n-B '%@'", bodyDataString];
    }
    
    NSLog(@"%@",debugString);
}


@end

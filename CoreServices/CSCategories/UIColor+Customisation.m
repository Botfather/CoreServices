//
//  UIColor+Customisation.m
//  CoreServices
//
//  Created by Tushar Mohan on 28/11/17.
//  Copyright © 2017 io.github.botfather. All rights reserved.
//

#import "UIColor+Customisation.h"
#import "NSDictionary+CoreServicesUtility.h"
#import "NSString+CoreServicesUtility.h"

@implementation UIColor (Customisation)

+ (instancetype)loadColorFromKey:(NSString *)colorName {
    NSDictionary* colorKeys  = [NSDictionary initFromFile:@"colorTheme" ofType:@"json"];
    if(colorKeys.count<1) {
        //we have some error because t he dict failed to load. or no keys were found
    }
    NSString* colorHexCode  = [colorKeys stringForKey:colorName];
    
    //check in case the hexCode is not available in the dictionary and then use defaultOrMissing key color
    if ([colorHexCode isNilEmptyOrWhiteSpace]) {
        NSLog(@"CoreServices_Parsing Error <UIColor>: Missing color '%@' in colorTheme.json. Attempting to load \"defaultOrMissing\" color", colorName);
        colorHexCode = [colorKeys stringForKey:@"defaultOrMissing"];
    }
    
    //if the object corresponding to defaultOrMissing is nil, we check again and set the default color
    if ([colorHexCode isNilEmptyOrWhiteSpace]) {
        NSLog(@"CoreServices_Parsing Error <UIColor>:  Missing \"defaultOrMissing\" color in colorTheme.json");
        colorHexCode = @"#00FF00";
    }
    
    return [self colorFromString:colorHexCode];
}

+(UIColor*)colorFromString:(NSString*)colorString{
    //check if the color is hex code
    if([colorString rangeOfString:@"#"].location != NSNotFound) {
        int red, green, blue;
        sscanf([colorString UTF8String], "#%02X%02X%02X", &red, &green, &blue);
        UIColor * color = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
        return color;
    }
    //check if the color is of the form RGB/RGBA
    else if([colorString rangeOfString:@"rgb("].location != NSNotFound) {
        colorString = [colorString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        colorString = [colorString stringByReplacingOccurrencesOfString:@"rgb(" withString:@""];
        colorString = [colorString stringByReplacingOccurrencesOfString:@")" withString:@""];
        NSArray * matches  = [colorString componentsSeparatedByString:@","];
        
        int r = [matches[0] intValue];
        int g = [matches[1] intValue];
        int b = [matches[2] intValue];
        float a = matches.count > 3 ? [matches[3] floatValue] : 1;
        return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a];
    }
    
    return nil;
}

@end

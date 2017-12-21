//
//  UIColor+Customisation.h
//  CoreServices
//
//  Created by Tushar Mohan on 28/11/17.
//  Copyright © 2017 io.github.botfather. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Customisation)

/**
 Returns a UIColor object corresponding to the key color key provided. This will prepare the color from
 hex or rgb/rgba string present in the colorTheme.json file. In case the color for the provided key is
 not present in the file, it will then load the defaultOrMissing color. The end fallback will be the
 default color being returned if the defaultOrMissing is not found still.
 
 @param colorName key to fetch hex code from file
 @return color object corresponding to key else default color
 */
+ (instancetype)loadColorFromKey:(NSString*)colorName;

@end

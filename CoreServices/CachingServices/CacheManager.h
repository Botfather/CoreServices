//
//  CacheManager.h
//  TestDrivers
//
//  Created by Tushar Mohan on 30/11/17.
//  Copyright © 2017 io.github.botfather. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    CMDestinationCache,
    CMDestinationDocs,
} CMDestination;

typedef enum : NSUInteger {
    CMFileTypeDictionary,
    CMFileTypeGeneric,
} CMFileType;

typedef void (^FileLoadClosure)(id loadedData);

@interface CacheManager : NSObject

/**
 Save contents to the desired destination with the specified values.

 @param data Data to save
 @param type Type of data
 @param dest Destination of file to be saved (Cache/Documents)
 @param name Name of file to save
 @param canOverride if the File can override file with the same name
 */
+ (void)save:(id)data ofType:(CMFileType)type to:(CMDestination)dest fName:(NSString*)name override:(BOOL)canOverride;

/**
 Fetch content stored on disk.

 @param type Type of target content
 @param dest Destination where the file was stored
 @param name Name of file
 @param handler completion block that needs to be executed
 */
+ (void)loadContentofType:(CMFileType)type from:(CMDestination)dest fName:(NSString*)name completion:(FileLoadClosure)handler;

/**
 Returns the path of file after verifying if the file exists on disk storage or not.
 
 @param name Name of File
 @param dest Destination to Save File
 @param type Type of File that is being queried
 @return Full path of file
 */
+ (NSString*)fetchPathOf:(NSString*)name from:(CMDestination)dest ofType:(CMFileType)type;

/**
 Deletes all the resources within a destination.

 @param dest Destination where files are stored
 @return YES if deletion succeeds else NO
 */
+ (BOOL)removeAllItemsFrom:(CMDestination)dest;

/**
 Deletes a particular resource.

 @param name Name of File
 @param dest Destination to Save File
 @param type Type of File that is being queried
 @return YES if deletion succeeds else NO
 */
+ (BOOL)removeResource:(NSString*)name from:(CMDestination)dest ofType:(CMFileType)type;

@end

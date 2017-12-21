//
//  CacheManager.m
//  TestDrivers
//
//  Created by Tushar Mohan on 30/11/17.
//  Copyright © 2017 io.github.botfather. All rights reserved.
//

#import "CacheManager.h"
#import <CoreServices/NSString+CoreServicesUtility.h>

@implementation CacheManager

+ (void)save:(id)data ofType:(CMFileType)type to:(CMDestination)dest fName:(NSString*)name override:(BOOL)canOverride {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSData* dictData;
        
        //check if the type of data to be stored corresponds to the actual type of object
        if([data isKindOfClass:[NSDictionary class]]) {
            dictData = [NSKeyedArchiver archivedDataWithRootObject:data];
        } else if([data isKindOfClass:[NSData class]]) {
            dictData = data;
        } else {
            NSLog(@"CoreServices_Directory Write Error<Cache Manager>: Unsupported File Type for Writing.");
            //since data is not of supported type, we returned the control
            return;
        }
        
        NSString* targetPath = [self createFilePathWith:name dest:dest fileType:type];
        
        if(!targetPath) {
            NSLog(@"CoreServices_Directory Write Error<Cache Manager>: Could not write to the file");
            return;
        }
        
        BOOL ifFileExistAlready = ([self fetchPathOf:name from:dest ofType:type] != nil);
        
        if([self permitWriteToDiskWith:canOverride and:ifFileExistAlready]) {
            [self save:dictData to:targetPath];
        }
    });
}

+ (void)loadContentofType:(CMFileType)type from:(CMDestination)dest fName:(NSString*)name completion:(FileLoadClosure)handler {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSString* retrievedFileName = [self fetchPathOf:name from:dest ofType:type];
        if(!retrievedFileName) {
            handler(nil);
            return;
        }
        id loadedData;
        
        switch (type) {
            case CMFileTypeDictionary: {
                loadedData = [NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:retrievedFileName]];
                break;
            }
            case CMFileTypeGeneric: {
                loadedData = [NSData dataWithContentsOfFile:retrievedFileName];
                break;
            }
        }
        
        handler(loadedData);
    });
}


#pragma mark - Utilities

+ (NSString*)fetchPathOf:(NSString*)name from:(CMDestination)dest ofType:(CMFileType)type {
    NSString* filePath = [self createFilePathWith:name dest:dest fileType:type];
    BOOL isFileExisting = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    NSString* path = isFileExisting? filePath : nil;
    return path;
}

+ (BOOL)removeAllItemsFrom:(CMDestination)dest {
    NSString* filePath = [self storageDirectoryWithSubPath:@"Data" dest:dest];
    NSError* err;
    BOOL isDataDeleted = [[NSFileManager defaultManager] removeItemAtPath:filePath error:&err];
    
    if(err)
        NSLog(@"CoreServices_Directory Deletion Error<Cache Manager>: %@",err.localizedDescription);
    
    return isDataDeleted;
}

+ (BOOL)removeResource:(NSString*)name from:(CMDestination)dest ofType:(CMFileType)type {
    NSString* path = [self fetchPathOf:name from:dest ofType:type];
    
    if(!path)
        NSLog(@"CoreServices_Directory Deletion Error<Cache Manager>: Could not remove intended resource");
    
    NSError* err;
    BOOL isDataDeleted = [[NSFileManager defaultManager] removeItemAtPath:path error:&err];
    
    if(err)
        NSLog(@"CoreServices_Directory Deletion Error<Cache Manager>: %@",err.localizedDescription);
    
    return isDataDeleted;
}

#pragma mark - Private Helpers

/**
 Generates a boolean logic based on the file's existence on disk and if the overriding of file is permitted

 @param canOverride Flag for override condition
 @param isFileOnDisk Flag for file on disk condition
 @return YES if writing to file is permitted else No
 */
+ (BOOL)permitWriteToDiskWith:(BOOL)canOverride and:(BOOL)isFileOnDisk {
    BOOL permitOverwriting = (!canOverride && isFileOnDisk)? NO : YES;
    
    return permitOverwriting;
}

/**
 Generates the complete file path from the provided name and destination by appending the different
 components involved.

 @param name File name to be stored
 @param dest Location of the file to be saved (Cache or Documents)
 @param fileType Type of the file that is being written
 @return Complete file path from the passed arguments, nil if invalid
 */
+ (NSString*)createFilePathWith:(NSString*)name dest:(CMDestination)dest fileType:(CMFileType)fileType {
    
    if(name.isNilEmptyOrWhiteSpace) {
        return nil;
    }
    
    NSString* moddedFileName = [name stringByReplacingOccurrencesOfString:@"/" withString:@""];
    NSString* filePath = [self storageDirectoryWithSubPath:@"Data" dest:dest];
    
    if(!filePath) {
        NSLog(@"CoreServices_Directory Creation Error<Cache Manager>: Could not generate file path");
        return nil;
    }
    
    NSString* subDirectory = [filePath stringByAppendingPathComponent:[self getFolderName:fileType]];
    
    return [subDirectory stringByAppendingPathComponent:moddedFileName];
}


/**
 Use to change the folders that are root of similar file types.Example: All JSON(Dictionary) type gets
 stored under "Dictionary" folder. This returns the name of the file type root folder.

 @param type Type of file that is being written/read
 @return Name of the file root folder
 */
+ (NSString*)getFolderName:(CMFileType)type {
    NSString* folderName;
    
    switch (type) {
        case CMFileTypeDictionary: {
            folderName = @"Dictionary";
            break;
        }
        case CMFileTypeGeneric: {
            folderName = @"Generics";
            break;
        }
    }
    
    return folderName;
}

/**
 This method generates the path for the target destination and appends the name of the root storage folder
 to it before returning to the calling method.

 @param subPath Name of root folder which contains the content inside CachesDirectory & DocumentDirectory
 @param dest Either of CachesDirectory or DocumentDirectory
 @return Generated path name other wise nil
 */
+ (NSString*)storageDirectoryWithSubPath:(NSString*)subPath dest:(CMDestination)dest {
    NSArray<NSString*>* pathArray;
    
    switch (dest) {
        case CMDestinationCache: {
            pathArray = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
                break;
            }
        case CMDestinationDocs: {
            pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            break;
        }
    }
    
    if(pathArray.count < 1) {
        NSLog(@"CoreServices_Directory Access Error<Cache Manager>: Could not fetch path array contents.");
        return nil;
    }
    
    NSString* dirPath = pathArray[0];
    dirPath = [dirPath stringByAppendingPathComponent:subPath];
    
    return dirPath;
}

/**
 Write data to disk

 @return YES if successful else NO
 */
+ (BOOL)save:(NSData*)data to:(NSString*)path {
    NSString* dirPath = [path stringByDeletingLastPathComponent];
    NSFileManager* defManager = [NSFileManager defaultManager];
    NSError* err;
    
    if(![defManager fileExistsAtPath:dirPath]) {
        [defManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:&err];
        
        if(err)
            NSLog(@"CoreServices_Directory Write Error<Cache Manager>: %@",err.localizedDescription);
    }
    
    BOOL isWriteSuccessful = [data writeToFile:path atomically:YES];
    
    return isWriteSuccessful;
    
}

@end

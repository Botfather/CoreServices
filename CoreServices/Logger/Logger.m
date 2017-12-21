//
//  Logger.m
//  CoreServices
//
//  Created by Tushar Mohan on 27/11/17.
//  Copyright © 2017 io.github.botfather. All rights reserved.
//

#import "Logger.h"

@implementation Logger

+ (void)log:(Class)theClass level:(LogLevel)logLevel str:(NSString*)str {
    //Background Thread
    dispatch_sync(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
    LogStream streamMode = LOG_STREAM;
    
    if((streamMode == LogStreamNone) || (LOG_LEVEL < logLevel))
        return;
    
    NSString* logIdentifierString;
    
    switch (logLevel)
    {
        case LogLevelInfo:
        {
            logIdentifierString = @"[INFO]";
            break;
        }
        case LogLevelWarning:
        {
            logIdentifierString = @"[WARN_]";
            break;
        }
        case LogLevelError:
        {
            logIdentifierString = @"[ERROR]";
            break;
        }
        default:
        {
            logIdentifierString = @"[WARNING]";
            break;
        }
    }
    
    NSString* log = [NSString stringWithFormat:@"%@: %@ - %@",logIdentifierString,theClass,str];
    
    switch (streamMode)
    {
        case LogStreamConsole:
            NSLog(@"%@",log);
            break;
            
        case LogStreamFile:
            [self logToFile:log];
            break;
            
        default:
        {
            NSLog(@"%@",log);
            [self logToFile:log];
            
            break;
        }
    }
        });
}

+ (void)getLogFile:(LogFileAccessBlock)handler {
    
    if(!handler)
        return;
    
    NSString* filePath = [self getLogFilePath];
    
    BOOL isOperationComplete = handler(filePath);
    
    if(isOperationComplete && filePath)
    {
        NSFileManager* fileMgr = [NSFileManager defaultManager];
        [fileMgr removeItemAtPath:filePath error:nil];
    }
}

#pragma mark - Private

+ (void)logToFile:(NSString*)log {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = LOG_DATE_FORMAT;
    
    NSTimeZone *gmtZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmtZone];
    
    NSString* timeStamp = [dateFormatter stringFromDate:[NSDate date]];
    
    log = [NSString stringWithFormat:@"%@:%@\n",timeStamp,log];
    
    NSString* logFilePath = [self getLogFilePath];
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:logFilePath];
    
    if (fileHandle) {
        
        [fileHandle seekToEndOfFile];
        [fileHandle writeData:[log dataUsingEncoding:NSUTF8StringEncoding]];
        [fileHandle closeFile];
    }
    else {
        
        [log writeToFile:logFilePath atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
    }
}

+ (NSString*)getLogFilePath {
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    if (paths.count <= 0)
        return nil;
    
    NSString* dirPath = paths[0];
    
    NSString* filePath = dirPath;
    
    return [filePath stringByAppendingPathComponent:LOG_FILE_NAME];
}

@end

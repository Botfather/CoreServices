//
//  Logger.h
//  CoreServices
//
//  Created by Tushar Mohan on 27/11/17.
//  Copyright © 2017 io.github.botfather. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LOG_STREAM LogStreamBoth
#define LOG_LEVEL LogLevelAll
#define LOG_DATE_FORMAT @"[dd-MM-yyyy HH:mm:ss]"
#define LOG_FILE_NAME @"application.log"

typedef BOOL (^LogFileAccessBlock)(NSString* filePath);

typedef NS_ENUM(NSInteger, LogStream)
{
    LogStreamNone = 0,
    LogStreamConsole,
    LogStreamFile,
    LogStreamBoth
};

typedef NS_ENUM(NSInteger, LogLevel)
{
    LogLevelNone = 0,
    LogLevelInfo,
    LogLevelWarning,
    LogLevelError,
    LogLevelAll
};

#define LogInfo(arg, ... ) [Logger log: [self class] level: LogLevelInfo str: [NSString stringWithFormat:(arg), ##__VA_ARGS__]]
#define LogWarning( arg, ... ) [Logger log: [self class] level: LogLevelWarning str: [NSString stringWithFormat:(arg), ##__VA_ARGS__]]
#define LogError( arg, ... ) [Logger log: [self class] level: LogLevelError str: [NSString stringWithFormat:(arg), ##__VA_ARGS__]]

@interface Logger : NSObject

+ (void)getLogFile:(LogFileAccessBlock)handler;
+ (void)log:(Class)theClass level:(LogLevel)logLevel str:(NSString*)str;

@end

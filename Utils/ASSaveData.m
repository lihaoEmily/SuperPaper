//
//  ASSaveData.m
//  SuperPaper
//
//  Created by 瞿飞 on 16/1/18.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "ASSaveData.h"

#define FILE_NAME @"SuperPapers"

@interface ASSaveData()

@property (nonatomic, strong) NSString *homeDirString;
@property (nonatomic, strong) NSString *documentDirString;
@property (nonatomic, strong) NSString *cachesDirString;

@end

@implementation ASSaveData

+ (void)initialize {
    [self initialize];
//    NSString *homeDirStr = NSHomeDirectory();
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _homeDirString = NSHomeDirectory();
        NSArray *homePaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        _documentDirString = [homePaths objectAtIndex:0];
        
        NSArray *cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        _cachesDirString = [cachePaths objectAtIndex:0];
        
        NSString *savePath = [_documentDirString stringByAppendingPathComponent:CACHE_DIR];
        if(![[NSFileManager defaultManager] fileExistsAtPath:savePath]){
            [[NSFileManager defaultManager] createDirectoryAtPath:savePath
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:nil];
        }
    }
    
    return self;
}

- (BOOL)saveToSandBoxWithData:(NSData *)cacheData withTitle:(NSString *)title {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    NSString* datePrefix = [formatter stringFromDate:[NSDate date]];
    NSLog(@"----> DataPrefix:%@",datePrefix);
    
    NSString * fileName = [NSString stringWithFormat:@"%@_%@.txt",FILE_NAME, datePrefix];
    NSString * fullPath = [_documentDirString stringByAppendingString:fileName];
    NSLog(@"----> fullPath:%@",fullPath);
    NSError *error = nil;
//    [cacheData writeToFile:fullPath atomically:YES];
    [cacheData writeToFile:fullPath options:NSDataWritingAtomic error:&error];
    if (error == nil) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)saveToLocationWithData:(NSData *)cacheData withTitle:(NSString *)title {
    if (cacheData == nil || [cacheData length] == 0) {
        return NO;
    }
    NSData *data = [NSData dataWithData:cacheData];
    return [self saveToSandBoxWithData:data withTitle:title];
}

- (BOOL)saveToLocationwithStrings:(NSString *)cacheStrings withTitle:(NSString *)title{
    if (cacheStrings == nil || cacheStrings.length == 0) {
        return NO;
    }
    
    NSString * string = [NSString stringWithString:cacheStrings];
    NSData *cacheData = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    return [self saveToLocationWithData:cacheData withTitle:title];
}

- (BOOL)deleteCustomPathWithName:(NSString *)directoyName {
    NSString *savePath = [_documentDirString stringByAppendingPathComponent:directoyName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:savePath]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:savePath error:&error];
        if (error) {
            return NO;
        } else {
            return YES;
        }
    } else {
        return NO;
    }
}

@end

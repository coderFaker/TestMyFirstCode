//
//  FileManagerTool.m
//  Mogo
//
//  Created by seehoo on 2017/5/31.
//  Copyright © 2017年 zpc. All rights reserved.
//

#import "FileManagerTool.h"

@implementation FileManagerTool

+ (NSString *)getReportFolderName {
    return [NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),@"Report"];
}


+ (NSString *)getCurrentTime {
    NSDate *date = [NSDate date];
    NSDateFormatter *fomater =[[NSDateFormatter alloc] init];
    
    [fomater setDateFormat:@"yyyy-MM-dd"];
    //NSString * dateString = [fomater stringFromDate:date];
    
    //    [fomater setDateFormat:@""];
    
    NSString * timeString = [fomater stringFromDate:date];
    
    return timeString;
}

+ (NSString *)getCurrentDetailTime {
    NSDate *date = [NSDate date];
    NSDateFormatter *fomater =[[NSDateFormatter alloc] init];
    
    [fomater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //NSString * dateString = [fomater stringFromDate:date];
    
    //    [fomater setDateFormat:@""];
    
    NSString * timeString = [fomater stringFromDate:date];
    
    return timeString;

}


/**
 创建文件夹

 @param name 文件夹路径
 */
+ (void)createFolderWithName:(NSString *)name {

    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:name isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) ) {
        [fileManager createDirectoryAtPath:name withIntermediateDirectories:YES attributes:nil error:nil];
        
    }else{
        NSLog(@"创建失败");
    }
    
}

/**
 判断文件是否存在

 @param path 文件路径
 @return 是否存在
 */
+ (BOOL)fileExistsAtPath:(NSString *)path {
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    return existed;
}

+ (void)deleteFolderWithName:(NSString *)path {
    BOOL isDir;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    isDir = [fileManager removeItemAtPath:path error:nil];
    if (isDir) {
        //删除成功
    }else{
        //删除失败
    }
}


@end

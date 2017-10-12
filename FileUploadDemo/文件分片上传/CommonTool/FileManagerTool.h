//
//  FileManagerTool.h
//  Mogo
//
//  Created by seehoo on 2017/5/31.
//  Copyright © 2017年 zpc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileManagerTool : NSObject
//获取进件文件夹
+ (NSString *)getReportFolderName;
//获取当前时间 时分秒
+ (NSString *)getCurrentDetailTime;

+ (NSString *)getCurrentTime;
//创建文件夹
+ (void)createFolderWithName:(NSString *)name;

//删除文件   路径
+ (void)deleteFolderWithName:(NSString *)path;

//判断是否存在文件
+(BOOL)fileExistsAtPath:(NSString *)path;



@end

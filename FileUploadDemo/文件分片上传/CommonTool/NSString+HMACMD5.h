//
//  NSString+HMACMD5.h
//  文件分片上传
//
//  Created by seehoo on 2017/9/19.
//  Copyright © 2017年 seehoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HMACMD5)
+ (NSString *)stringWithHMACMD5:(NSString *)data key:(NSString *)key;
+ (NSString *)stringWithSHA1WithData:(NSData *)inputData;

+ (NSString *)stringWithSHA256WithData:(NSData *)inputData;

@end

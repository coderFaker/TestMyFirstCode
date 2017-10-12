//
//  FileModel.m
//  文件分片上传
//
//  Created by seehoo on 2017/9/19.
//  Copyright © 2017年 seehoo. All rights reserved.
//

#import "FileModel.h"

@implementation FileModel


+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"hashMessage" : @"hash"};
}

@end

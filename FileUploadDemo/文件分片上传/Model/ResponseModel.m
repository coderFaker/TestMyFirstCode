//
//  ResponseModel.m
//  文件分片上传
//
//  Created by seehoo on 2017/9/19.
//  Copyright © 2017年 seehoo. All rights reserved.
//

#import "ResponseModel.h"

@implementation ResponseModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"categories" : @"CategoryModel"
             };
}

@end

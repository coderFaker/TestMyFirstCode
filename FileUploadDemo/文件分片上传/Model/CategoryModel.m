//
//  CategoryModel.m
//  文件分片上传
//
//  Created by seehoo on 2017/9/19.
//  Copyright © 2017年 seehoo. All rights reserved.
//

#import "CategoryModel.h"

@implementation CategoryModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"items" : @"ItemsModel"
             };
}

@end

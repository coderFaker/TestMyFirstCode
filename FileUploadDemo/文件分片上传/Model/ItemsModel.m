//
//  ItemsModel.m
//  文件分片上传
//
//  Created by seehoo on 2017/9/19.
//  Copyright © 2017年 seehoo. All rights reserved.
//

#import "ItemsModel.h"
#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height
@implementation ItemsModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"files" : @"FileModel",
             @"exts":@"NSString"
             };
}

-(CGSize)itemSize {
    CGSize   itemSize ;
    if ([self.multiple isEqualToString:@"0"]) {
        itemSize = CGSizeMake((kScreenW-40)/4,(kScreenW-40)/4*0.85+20);
    }else{
        if (self.files.count<=0) {
            itemSize = CGSizeMake((kScreenW-40)/4,(kScreenW-40)/4*0.85+20);
        }else if(self.files.count<=3){
            itemSize = CGSizeMake((self.files.count+1)*(kScreenW-40)/4+20, (kScreenW-40)/4*0.85+20);
        }else{
            itemSize = CGSizeMake(4*(kScreenW-40)/4+20, (self.files.count/4+1)*(kScreenW-40)/4*0.85+20);
        }
    }
    return itemSize;
}
@end

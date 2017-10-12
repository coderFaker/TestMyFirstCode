//
//  ItemsModel.h
//  文件分片上传
//
//  Created by seehoo on 2017/9/19.
//  Copyright © 2017年 seehoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ItemsModel : NSObject

@property (nonatomic, copy) NSString *itemID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *multiple;
@property (nonatomic, copy) NSMutableArray *files;
@property (nonatomic, copy) NSMutableArray *exts;
@property (nonatomic, copy) NSString *permissions;
@property (nonatomic, copy) NSString *minNum;

@property (nonatomic, copy) NSString *maxNum;
@property (nonatomic, copy) NSString *totalSize;
@property (nonatomic, copy) NSString *maxSize;
@property (nonatomic, copy) NSString *guide;
@property (nonatomic, copy) NSString *background;
@property (nonatomic, copy) NSString *alt;
@property (nonatomic, copy) NSString *accept;
@property (nonatomic, copy) NSString *capture;


/*** 添加的属性   */
@property (nonatomic,assign) CGSize   itemSize;

@end

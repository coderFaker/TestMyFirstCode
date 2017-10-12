//
//  ResponseModel.h
//  文件分片上传
//
//  Created by seehoo on 2017/9/19.
//  Copyright © 2017年 seehoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResponseModel : NSObject

@property (nonatomic, copy) NSString *respCode;
@property (nonatomic, copy) NSString *respMsg;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *now;
@property (nonatomic, copy) NSString *tokenCreate;
@property (nonatomic, copy) NSString *tokenTouch;
@property (nonatomic, copy) NSString *loginTimeOut;
@property (nonatomic, copy) NSString *tokenTimeOut;
@property (nonatomic, copy) NSString *audit;
@property (nonatomic, copy) NSString *viewID;
@property (nonatomic, strong) NSMutableArray *categories;
@end

//
//  FileModel.h
//  文件分片上传
//
//  Created by seehoo on 2017/9/19.
//  Copyright © 2017年 seehoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileModel : NSObject

@property (nonatomic, copy) NSString *hashMessage;
@property (nonatomic, copy) NSString *size;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *permissions;
@property (nonatomic, copy) NSString *rotate;
@property (nonatomic, copy) NSString *auditStatus;
@property (nonatomic, copy) NSString *auditMarks;
@property (nonatomic, copy) NSString *auditUserName;
@property (nonatomic, copy) NSString *auditUserID;

@end

//
//  FileUploadManager.h
//  文件分片上传
//
//  Created by seehoo on 2017/9/19.
//  Copyright © 2017年 seehoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CNFile.h"
@interface FileUploadManager : NSObject
- (void)uploadWithFile:(CNFile *)file VC:(UIViewController *)vc;
@end

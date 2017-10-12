//
//  FileUploadManager.m
//  文件分片上传
//
//  Created by seehoo on 2017/9/19.
//  Copyright © 2017年 seehoo. All rights reserved.
//

#import "FileUploadManager.h"
#import "NetworkTool.h"
#import "FileStreamOperation.h"
#import "FileUploadCachedManager.h"

//@interface FileUploadManager()
//@property (nonatomic, strong) UIViewController *holdVC:
//@end

@implementation FileUploadManager

- (NSString *)getFilePath:(NSString *)path {
    return @"";
}
- (NSArray *)getNotUploadedFragments:(CNFile *)file {
    return @[];
}
- (void)uploadWithFile:(CNFile *)file VC:(UIViewController *)vc {
//    self. = vc;
    //获取文件分片数组
    FileStreamOperation *fileStreamer;
    fileStreamer = [[FileStreamOperation alloc] initFileOperationAtPath:[self getFilePath:file.fileName] forReadOperation:YES];
    if (fileStreamer.fileFragments.count)
    {
        [self uploadWithFragment:fileStreamer.fileFragments file:file ];
    }
}

//上传文件分片
- (void)uploadWithFragment:(NSArray *)fragments file:(CNFile *)file
{
    FileStreamOperation *fileStreamer;
    dispatch_group_t group = dispatch_group_create ();
    __block float uploadCount = 0.0;
    //创建上传缓存路径
    [[FileUploadCachedManager sharedInstance] createUploadDirectoryPath];
    
    //创建上传的文件路径 md5Str+fileName
    [[FileUploadCachedManager sharedInstance] createUploadFilePath:file.filePath];
    
    //检查该文件是否在本地沙河中存在，文件名格式为文件md5Str+fileName
    NSString *filePath = [[FileUploadCachedManager sharedInstance] getFilePath:file.filePath];
    
    NSArray *tempFragments;
    
    if ([[FileUploadCachedManager sharedInstance] fileIsExist:filePath]) {
        //存在,说明是断点续传，只需要上传本地之外的文件分片
        //获取还没上传的文件分片数组
        tempFragments = [self getNotUploadedFragments:file];
    }else
    {
        //不存在，整个文件分片都下载;
        //所有分片写入到沙盒
        
        for (int i=0; i<fragments.count;i++)
        {
            NSString *fragPath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d",i+1]];
            NSData *data = [fileStreamer readDateOfFragment:fragments[i]];
            [[FileUploadCachedManager sharedInstance] writeFileWithData:data toPath:fragPath];
        }
        tempFragments = fragments;
    }
    
    dispatch_queue_t queue = dispatch_queue_create("fragment.queue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        //上传请求
        NSURLSessionDataTask *task = [NetworkTool uploadFileWithFragment:tempFragments file:file fileStream:fileStreamer progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            
           // [self combineWith:fgts file:fd message:message];
            
        } fail:^(NSURLSessionDataTask *task, NSError *error) {
            
        }] ;
    });
}




@end

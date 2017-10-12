//
//  NetworkTool.h
//  Mogo
//
//  Created by 张鹏程 on 17/3/31.
//  Copyright © 2017年 zpc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileStreamOperation.h"
#import "CNFile.h"
#import "AFNetworking.h"
/**
 *  宏定义请求成功的block
 *
 *  @param responseObject 请求成功返回的数据
 */
typedef void(^XJYResponseSuccess)(NSURLSessionDataTask *task, id responseObject);

/**
 *  宏定义请求失败的block
 *
 *  @param error 报错信息
 */
typedef void(^XJYResponseFail)(NSURLSessionDataTask *task, NSError *error);

/**
 *  上传或者下载的进度
 *
 *  @param progress 进度
 */
typedef void(^XJYProgress)(NSProgress *progress);


@interface NetworkTool : AFHTTPSessionManager



//单例
+ (NetworkTool *)shareInstance;


/**
 *  普通get方法请求网络数据
 *
 *  @param url     请求网址路径
 *  @param params  请求参数
 *  @param success 成功回调
 *  @param fail    失败回调
 */
+ (void)GET:(NSString *)url params:(NSDictionary *)params success:(XJYResponseSuccess)success fail:(XJYResponseFail)fail;


//判断网络状态
+ (NetworkTool *)haveNetWork;


/**
 *  普通post方法请求网络数据
 *
 *  @param url     请求网址路径
 *  @param params  请求参数
 *  @param success 成功回调
 *  @param fail    失败回调
 */
+ (void)POST:(NSString *)url params:(NSDictionary *)params success:(XJYResponseSuccess)success fail:(XJYResponseFail)fail;

/**
 *  普通路径上传文件
 *
 *  @param url      请求网址路径
 *  @param params   请求参数
 *  @param filedata 文件
 *  @param name     指定参数名
 *  @param fileName 文件名（要有后缀名）
 *  @param mimeType 文件类型
 *  @param progress 上传进度
 *  @param success  成功回调
 *  @param fail     失败回调
 */

+ (void)uploadWithURL:(NSString *)url
               params:(NSDictionary *)params
             fileData:(NSData *)filedata
                 name:(NSString *)name
             fileName:(NSString *)fileName
             mimeType:(NSString *)mimeType
             progress:(XJYProgress)progress
              success:(XJYResponseSuccess)success
                 fail:(XJYResponseFail)fail;


/**
 上传多个文件

 @param url 请求地址
 @param params 请求参数
 @param filesArray 文件内容
 @param mineType 文件类型
 @param progress 上传进度
 @param success 成功回调
 @param fail 失败回调
 */
+ (void)uploadFilesWithURL:(NSString *)url
                    params:(NSDictionary *)params
                 filesList:(NSArray *)filesArray
                  mineType:(NSString *)mineType
                  progress:(XJYProgress)progress
                   success:(XJYResponseSuccess)success
                      fail:(XJYResponseFail)fail;

/**
 *  下载文件
 *
 *  @param url      请求网络路径
 *  @param fileURL  保存文件url
 *  @param progress 下载进度
 *  @param success  成功回调
 *  @param fail     失败回调
 *
 *  @return 返回NSURLSessionDownloadTask实例，可用于暂停继续，暂停调用suspend方法，重新开启下载调用resume方法
 */

/**
 上传图片接口

 @param url 上传地址
 @param params 参数
 @param filesArray 文件集合  二进制
 @param mineType 文件类型
 @param progress 进度
 @param success 成功回调
 @param fail 失败回调
 */
+ (void)uploadPicMessageWithURL:(NSString *)url params:(NSDictionary *)params filesList:(NSArray *)filesArray mineType:(NSString *)mineType progress:(XJYProgress)progress success:(XJYResponseSuccess)success fail:(XJYResponseFail)fail ;
+ (NSURLSessionDownloadTask *)downloadWithURL:(NSString *)url savePathURL:(NSURL *)fileURL progress:(XJYProgress)progress success:(void (^)(NSURLResponse *, NSURL *))success fail:(void (^)(NSError *))fail;


+ ( NSURLSessionDataTask * )uploadFileWithFragment:(NSArray *)fragments
                          file:(CNFile *)file
                    fileStream:(FileStreamOperation *)fileStream
                       progress:(XJYProgress)progress
                        success:(XJYResponseSuccess)success
                           fail:(XJYResponseFail)fail;


@end

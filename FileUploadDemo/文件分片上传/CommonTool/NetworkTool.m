//
//  NetworkTool.m
//  Mogo
//
//  Created by 张鹏程 on 17/3/31.
//  Copyright © 2017年 zpc. All rights reserved.
//

#import "NetworkTool.h"


static int const DEFAULT_REQUEST_TIME_OUT = 20;
@implementation NetworkTool
#pragma mark - 实例化Manager
static  NetworkTool*shareInstance = nil;
+ (NetworkTool *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    if (shareInstance == nil) {
        shareInstance = [super allocWithZone:zone];
    }
    return shareInstance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return shareInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //初始化一些参数
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", @"text/json", @"text/javascript",@"application/x-javascript",@"text/plain",@"image/gif",nil];
        self.reachabilityManager = [AFNetworkReachabilityManager sharedManager];
        [[self requestSerializer] setTimeoutInterval:DEFAULT_REQUEST_TIME_OUT];
    }
    return self;
}

#pragma mark - 判断使用什么网络
+ (NetworkTool *)haveNetWork
{
    static NSString *const stringURL = @"https://www.baidu.com/";
    NSURL *baseURL = [NSURL URLWithString:stringURL];
    NetworkTool *manager = [[NetworkTool alloc] initWithBaseURL:baseURL];
    NSOperationQueue *operationQueue = manager.operationQueue;
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"WWAN");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                NSLog(@"WiFi");
                [operationQueue setSuspended:NO];
            }
                break;
            case AFNetworkReachabilityStatusNotReachable:
            {
                NSLog(@"无网络");
                
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"亲，您没网啦" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:alertAction];
                    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
                    
                
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"亲，您没网啦" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    //[alertView show];
                
                
            }
            default:
                [operationQueue setSuspended:YES];
                break;
        }
    }];
    //开始监控
    [manager.reachabilityManager startMonitoring];
    return manager;
}



#pragma mark - 解析数据
+ (id)responseConfiguration:(id)responseObject
{
    NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    return dic;
}


#pragma mark - GET
+ (void)GET:(NSString *)url params:(NSDictionary *)params success:(XJYResponseSuccess)success fail:(XJYResponseFail)fail
{
    AFHTTPSessionManager *manager = [NetworkTool shareInstance];
    [manager.requestSerializer setHTTPShouldHandleCookies:YES];//默认是yes
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       // id dic = [NetworkTool responseConfiguration:responseObject];
        //success(task, dic);
        success(task,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(task, error);
    }];
}


#pragma mark - POST
+ (void)POST:(NSString *)url params:(NSDictionary *)params success:(XJYResponseSuccess)success fail:(XJYResponseFail)fail
{
    AFHTTPSessionManager *manager = [NetworkTool shareInstance];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 15.f;
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setHTTPShouldHandleCookies:YES];//默认是yes
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       // id dic = [NetworkTool responseConfiguration:responseObject];
//        NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)task.response;
//        NSDictionary *dic = [HTTPResponse allHeaderFields];
//        
//        //1.
//        NSArray *cookieArray = [NSHTTPCookie cookiesWithResponseHeaderFields:dic forURL:url];
//        //2.
//        NSString *cookieString = [HTTPResponse valueForKey:@"Set-Cookie"];
        
        success(task,responseObject);
       // success(task, dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(task, error);
    }];
}


#pragma mark - 上传单个文件
+ (void)uploadWithURL:(NSString *)url params:(NSDictionary *)params fileData:(NSData *)filedata name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType progress:(XJYProgress)progress success:(XJYResponseSuccess)success fail:(XJYResponseFail)fail
{
    AFHTTPSessionManager *manager = [NetworkTool shareInstance];
    [manager.requestSerializer setHTTPShouldHandleCookies:YES];//默认是yes
//    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];


    [manager POST:url parameters:params constructingBodyWithBlock:^(id  _Nonnull formData) {
        [formData appendPartWithFileData:filedata name:name fileName:fileName mimeType:mimeType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        progress(uploadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(task,responseObject);
//        id dic = [NetworkTool responseConfiguration:responseObject];
//        success(task, dic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(task, error);
    }];
}

+ (void)uploadFilesWithURL:(NSString *)url params:(NSDictionary *)params filesList:(NSArray *)filesArray mineType:(NSString *)mineType progress:(XJYProgress)progress success:(XJYResponseSuccess)success fail:(XJYResponseFail)fail {
    AFHTTPSessionManager *manager = [NetworkTool shareInstance];
    [manager.requestSerializer setHTTPShouldHandleCookies:YES];//默认是yes
    manager.requestSerializer.timeoutInterval = 60.f;

    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];

        for (int i=0; i<filesArray.count; i++)
        {
            // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
            // 要解决此问题，
            // 可以在上传时使用当前的系统事件作为文件名
            //NSData *data = [filesArray objectAtIndex:i];
            if ([filesArray[i] containsString:@"png"]) {//图片
                NSString *path = [NSString stringWithFormat:@"%@/%@",NSHomeDirectory(),filesArray[i]];
                NSData *data = [NSData dataWithContentsOfFile:path];
                NSString *fileName = [NSString stringWithFormat:@"%@%d.png", str,i];
                [formData appendPartWithFileData:data name:fileName fileName:fileName mimeType:mineType];
            }else{
                NSString *SHA1 = [NSString stringWithFormat:@"%@/%@",NSHomeDirectory(),filesArray[i]];
                NSData *data = [NSData dataWithContentsOfFile:SHA1];;
                NSString *fileName = [NSString stringWithFormat:@"%@.mp4",str];
                [formData appendPartWithFileData:data name:fileName fileName:fileName mimeType:@"video/mp4"];
            }
                //上传
                /*
                 此方法参数
                 1. 要上传的[二进制数据]
                 2. 对应网站上[upload.php中]处理文件的[字段"file"]
                 3. 要保存在服务器上的[文件名]
                 4. 上传文件的[mimeType]
                 */
        }
//        NSData *data = [filesArray lastObject];
//        NSString *fileName = [NSString stringWithFormat:@"%@.mp4",str];
//        [formData appendPartWithFileData:data name:fileName fileName:fileName mimeType:@"video/mp4"];
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        progress(uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(task,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         fail(task, error);
    }];
}

+ (void)uploadPicMessageWithURL:(NSString *)url params:(NSDictionary *)params filesList:(NSArray *)filesArray mineType:(NSString *)mineType progress:(XJYProgress)progress success:(XJYResponseSuccess)success fail:(XJYResponseFail)fail  {
    AFHTTPSessionManager *manager = [NetworkTool shareInstance];
    [manager.requestSerializer setHTTPShouldHandleCookies:YES];//默认是yes

    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        
        for (int i=0; i<filesArray.count; i++)
        {
            // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
            // 要解决此问题，
            // 可以在上传时使用当前的系统事件作为文件名
            //NSData *data = [filesArray objectAtIndex:i];
            
            NSString *fileName = [NSString stringWithFormat:@"%@%d.png", str,i];
            //上传
            /*
             此方法参数
             1. 要上传的[二进制数据]
             2. 对应网站上[upload.php中]处理文件的[字段"file"]
             3. 要保存在服务器上的[文件名]
             4. 上传文件的[mimeType]
             */
            [formData appendPartWithFileData:[filesArray objectAtIndex:i] name:fileName fileName:fileName mimeType:mineType];
            
        }
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        progress(uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(task,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(task, error);
    }];

}

#pragma mark - 下载
+ (NSURLSessionDownloadTask *)downloadWithURL:(NSString *)url savePathURL:(NSURL *)fileURL progress:(XJYProgress)progress success:(void (^)(NSURLResponse *, NSURL *))success fail:(void (^)(NSError *))fail
{
    AFHTTPSessionManager *manager = [NetworkTool shareInstance];
    [manager.requestSerializer setHTTPShouldHandleCookies:YES];//默认是yes
    NSURL *urlPath = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:urlPath];
    NSURLSessionDownloadTask *downLoadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        progress(downloadProgress);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //下载后保存的路径
        return [fileURL URLByAppendingPathComponent:[response suggestedFilename]];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (error) {
            fail(error);
        } else {
            success(response, filePath);
        }
        
    }];
    
    [downLoadTask resume];
    return downLoadTask;
    
}

+ (NSURLSessionDataTask * )uploadFileWithFragment:(NSArray *)fragments
                          file:(CNFile *)file
                    fileStream:(FileStreamOperation *)fileStream
                       progress:(XJYProgress)progress
                        success:(XJYResponseSuccess)success
                           fail:(XJYResponseFail)fail{
    AFHTTPSessionManager *manager = [NetworkTool shareInstance];
    [manager.requestSerializer setHTTPShouldHandleCookies:YES];//默认是yes
    manager.requestSerializer.timeoutInterval = 60.f;
    __block float uploadCount = 0.0;
    
    NSInteger fileFragmentCount = fragments.count;

  NSURLSessionDataTask *task =  [manager POST:@"" parameters:@{} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        progress(uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"----dic--%@",dic);
        if ([dic[@"respCode"] isEqualToString:@"0000"]) {
            
            uploadCount++;
            //分片上传成功从沙盒对应路径删除
            //                    [[CKGFileUploadCachedManager sharedInstance] removeFileByName:file.fileName fragment:i+1];
            
            //更新进度条（这里通过block或者通知传到需要更新进度条进度的地方）
            NSLog(@"%@ progress>>>>>>>>>>>%f",file.fileName,(float)(uploadCount/file.trunks));
            
            
            if(uploadCount == file.trunks)
            {
                //所有分片上传完毕删除对应文件
                //                        [[CKGFileUploadCachedManager sharedInstance] deleteDirctoryAtPath:[NSString stringWithFormat:@"%@%@",file.md5Str,file.fileName]];
                success(task,responseObject);

                uploadCount = 0.0;
            }
        }

            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(task, error);
    }];
    [task resume];
    return task;
    
    
}
@end

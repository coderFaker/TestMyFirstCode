//
//  FirstViewController.m
//  文件分片上传
//
//  Created by seehoo on 2017/9/18.
//  Copyright © 2017年 seehoo. All rights reserved.
//


//1.待总部电核   待风控审批

#import "FirstViewController.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "SRActionSheet.h"
#import "SRAlertView.h"
#import "NetworkTool.h"
#import "FileStreamOperation.h"
#import "NSString+HMACMD5.h"
#import "FileManagerTool.h"

#define iOS7Later ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)
#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)
#define iOS9Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)
#define iOS9_1Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.1f)
@interface FirstViewController ()<SRActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,SRAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) UIImagePickerController *pickerView;
@property (nonatomic, copy) NSString *token;
@property (weak, nonatomic) IBOutlet UILabel *tokenLabel;
@property (nonatomic, strong) FileStreamOperation *streamOperation;
@end
static  NSString *getTokenURL = @"http://192.168.88.48:8080/mcloud/getToken.jjs";
static  NSString *getfragMergeURL = @"http://192.168.88.48:8081/mcloud/fragMerge.jjs";
static  NSString *uploadStreamURL = @"http://192.168.88.48:8081/mcloud/fragStream.jjs";
static  NSString *uploadStructURL = @"http://192.168.88.48:8081/mcloud/";
//static const NSString *

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"文件上传";
    
    self.streamOperation = [[FileStreamOperation alloc] initFileOperationAtPath:[NSString stringWithFormat:@"%@/%@/%@/1.png",NSHomeDirectory(),@"Library",@"upload"] forReadOperation:YES];
    

}
//上传按钮TestWord.docx
- (IBAction)uploadButtonClick:(id)sender {
    NSLog(@"------%@",self.streamOperation.fileFragments);
    for (FileFragment *fragment in self.streamOperation.fileFragments) {
        
        
        NSLog(@"-fragment---%@",fragment);
    }
    [self requestMergeFileMessageWith];
    /*
    NSData *imageData = UIImageJPEGRepresentation(self.imageView.image, 0.1);
    [NetworkTool uploadWithURL:@"http://117.78.35.224/fom/upload.jjs" params:@{} fileData:imageData name:@"Test" fileName:@"Test.png" mimeType:@"image/png" progress:^(NSProgress *progress) {
        NSLog(@"-progress--上传进度--%@",progress);
        NSLog(@"---上传进度--%f",progress.fractionCompleted);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.progressView.progress = progress.fractionCompleted;
        });
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
     */
    
}
//暂停
- (IBAction)pauseButtonClick:(id)sender {
    
//    BOOL has = [self compareFirstDate:[self dateFromString:@""] lastDate:[self dateFromString:@"2015-9-9"]];
//    if (!has) {
//        NSLog(@"-----注册时间不能大于出厂日期");
//    }
//    NSLog(@"------%d",has);
//    NSArray *vinList = @[@"LFMARE2C7A0259288",@"LJDLAA296E0361086",@"LGBH1AE09AY137657",@"KL1CC53FX9B546640",@"JF1SH52F4AG132886",@"LSGGF53XXAH282271",@"LBELMBKC6BY124151",@"LBEHDAEB4EY194951",@"3GYFNDEY6AS617490",@"LJDLAI296EO361086"];
//    for (NSString *string in vinList) {
//        BOOL isVIN = [self validateVIN:string];
//        NSLog(@"------vin----%d",isVIN);
//    }
    
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确定上传吗?" message:@"一旦上传,只有驳回才可修改" delegate:self cancelButtonTitle:@"不上传" otherButtonTitles:@"确定上传", nil];
    [alertView show];
    SRAlertView *alert = [SRAlertView sr_alertViewWithTitle:@"确定上传吗?" icon:nil
                                                    message:@"一旦上传,只有驳回才可修改" leftActionTitle:@"不上传" rightActionTitle:@"确定上传" animationStyle:SRAlertViewAnimationZoomSpring delegate:self];
    //[alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0) {
    NSLog(@"--------%ld",buttonIndex);
}
- (void)alertViewDidSelectAction:(SRAlertViewActionType)actionType{
    
}


- (BOOL)validateVIN:(NSString *)VIN {
    NSString *regexR = @"^[A-HJ-NPR-Z0-9]{9}[A-HJ-NPRSTV-Y1-9][A-HJ-NPR-Z0-9]{7}$";
    //NSString *regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{17}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexR];
    BOOL isValid = [predicate evaluateWithObject:VIN];
    return isValid;
}


- (NSDate *)dateFromString:(NSString *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date1 = [formatter dateFromString:date];
    return date1;
}
- (BOOL )compareFirstDate:(NSDate*)firstDate lastDate:(NSDate*)lastDate {
    BOOL   fistDateIsOld = NO;
    NSComparisonResult result = [firstDate compare:lastDate];
    if (result == NSOrderedAscending) {
        //NSLog(@"Date1  is in the future");
        fistDateIsOld = YES;
    }
    else {
        //NSLog(@"Date1 is in the past");
        fistDateIsOld = NO;
    }
    //NSLog(@"Both dates are the same");
    return fistDateIsOld;
}

- (IBAction)takePhoto:(id)sender {
    SRActionSheet *sheet = [SRActionSheet sr_actionSheetViewWithTitle:@"文件来源" cancelTitle:@"取消" destructiveTitle:nil otherTitles:@[@"图库",@"相机"] otherImages:nil delegate:self];
    sheet.otherActionItemAlignment = SROtherActionItemAlignmentCenter;
    [sheet show];
    
}
- (IBAction)getTokenButtonClick:(id)sender {
    
    
    NSString *timeString = [self getCurrentTimeInterval];
    NSString *resource = [NSString stringWithFormat:@"%@%@%@%@",@"godsuy",timeString,@"apply",@"110110110"];
    
    NSLog(@"----resource--%@",resource);
    NSString *sign = [NSString stringWithHMACMD5:resource key:@"godsuy.key"];
    
    //                            @"schema":@"fintech",@"fintech"

    NSLog(@"----sign--%@",sign);
    NSDictionary *param = @{@"tenant":@"godsuy",
                            @"time":[self getCurrentTimeInterval],
                            @"view":@"apply",
                            @"struct":@"110110110",
                            @"sign":sign};
    NSString *url = [NSString stringWithFormat:@"http://192.168.88.48:8080/mcloud/getToken.jjs?tenant=godsuy&time=%@&view=apply&struct=110110110&sign=%@",timeString,sign];
    [NetworkTool GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//        NSLog(@"---dic-----%@",dic);
        NSLog(@"--------%@",responseObject);
        self.token = responseObject[@"token"];
        
        self.tokenLabel.text = self.token;

    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"----error--%@",error);

    }];
//    [NetworkTool POST:@"http://192.168.88.48:8080/mcloud/getToken.jjs" params:param success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"--------%@",dic);
//        self.token = dic[@"token"];
//        
//        self.tokenLabel.text = self.token;
//    } fail:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"----error--%@",error);
//    }];
}
- (IBAction)singerUploadButtonClick:(id)sender {
    
    [NetworkTool uploadWithURL:uploadStreamURL params:@{@"token":self.token} fileData:self.streamOperation.fileData name:@"file" fileName:[NSString stringWithFormat:@"%@.png",self.streamOperation.fileSHA1] mimeType:@"image/png" progress:^(NSProgress *progress) {
        NSLog(@"----%@------progress--%lf",self.streamOperation.fileSHA1,progress.fractionCompleted);
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"-------%@--file--%@",self.streamOperation.fileSHA1,responseObject);
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"----error--%@",error);
    }];

}

#pragma mark - request
- (void)requestMergeFileMessageWith {
    
    NSDictionary *dic = @{@"token":self.token,
                          @"sha256":self.streamOperation.fileSHA1,
                          @"fragments":self.streamOperation.fileFragmentsSHA256};
    
    [NetworkTool POST:getfragMergeURL params:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"----dic--%@",dic);
        NSDictionary *lessDic = dic[@"less"];

        NSArray *valuesArray = lessDic.allValues;
        for (int i=0; i<valuesArray.count; i++) {
            NSString * valuseString = lessDic.allValues[i];
            if (valuseString.boolValue == YES) {
                NSString *key = self.streamOperation.fileFragmentsSHA256[i];
                NSLog(@"----未上传的分片--%@",key);
                for (FileFragment *file  in self.streamOperation.fileFragments) {
                    if ([file.fragmentSHA1 isEqualToString:key]) {
                        file.fragmentStatus = NO;
                        [NetworkTool uploadWithURL:uploadStreamURL params:@{@"token":self.token} fileData:file.fragmentData name:@"file" fileName:@"1.png" mimeType:@"application/octet-stream" progress:^(NSProgress *progress) {
                            NSLog(@"----%@------progress--%lf",file.fragmentSHA1,progress.fractionCompleted);
                            
                        } success:^(NSURLSessionDataTask *task, id responseObject) {
                            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                            NSLog(@"-------%@--file--%@",file,dic);
                        } fail:^(NSURLSessionDataTask *task, NSError *error) {
                             NSLog(@"----error--%@",error);
                        }];
                    }
                }
            }
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"----error--%@",error);
    }];
}



#pragma mark - SRActionSheetDelegate
- (void)actionSheet:(SRActionSheet *)actionSheet didSelectSheet:(NSInteger)index{
    
    if (index ==0) {
        [self selectedPicMethod];
    }else if (index ==1) {
        [self takePhotoMethod];
    }else {
        
    }
}

- (void)selectedPicMethod {
    /* 相册单选 */
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        
        
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.allowsEditing = YES;        //相册里的图片可被编辑
        
        [self presentViewController:imagePicker animated:YES
                         completion:^{
                             
        }];
    }else{
        
    }

}
- (void)takePhotoMethod {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    //picker.allowsEditing = YES;
    picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;

    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        
        UIImage *image = nil;
        if ([picker allowsEditing]) {
            image =  [info objectForKey:UIImagePickerControllerEditedImage];
        }else{
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        
        __block NSString *imageName;
        NSURL *refURL = [info valueForKey:UIImagePickerControllerReferenceURL];
        //    拿到图片名字  亲测只对图片有效
        PHFetchResult*result = [PHAsset fetchAssetsWithALAssetURLs:@[refURL] options:nil];
        
        
        //获取图片的名字信息
        PHAsset *asset = [result firstObject];
        NSString *fileName = [self printAssetsName:@[asset]];
        
        
        NSData *imageData = UIImageJPEGRepresentation(image, 0.01);
        NSString *nameString = [NSString stringWithFormat:@"%@/%@/%@/%@",NSHomeDirectory(),@"Library",@"upload",fileName];
        [imageData writeToFile:nameString atomically:YES];
        self.imageView.image = image;
        
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}
/// 打印图片名字
- (NSString *)printAssetsName:(NSArray *)assets {
    NSString *fileName = @"";
    for (id asset in assets) {
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = (PHAsset *)asset;
            fileName = [phAsset valueForKey:@"filename"];
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = (ALAsset *)asset;
            fileName = alAsset.defaultRepresentation.filename;;
        }
         NSLog(@"图片名字:%@",fileName);
    }
    return  fileName;
}

- (NSString *)getCurrentTime {
    NSDate *date = [NSDate date];
    NSDateFormatter *fomater =[[NSDateFormatter alloc] init];
    
    [fomater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //NSString * dateString = [fomater stringFromDate:date];
    
    //    [fomater setDateFormat:@""];
    
    NSString * timeString = [fomater stringFromDate:date];
    
    return timeString;
}

- (NSString *)getCurrentTimeInterval{
    NSDate *currentData = [NSDate date];
    NSTimeInterval timeInterval = currentData.timeIntervalSince1970;
    NSInteger time = (NSInteger)timeInterval*1000;
    NSString *timeString = [NSString stringWithFormat:@"%ld",time];
    return timeString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

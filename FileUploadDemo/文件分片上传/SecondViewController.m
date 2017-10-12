//
//  SecondViewController.m
//  文件分片上传
//
//  Created by seehoo on 2017/9/19.
//  Copyright © 2017年 seehoo. All rights reserved.
//

#import "SecondViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

#import "NetworkTool.h"
#import "NSString+HMACMD5.h"
#import "MJExtension.h"
#import "ResponseModel.h"
#import "CategoryModel.h"
#import "ItemsModel.h"
#import "FileModel.h"
#import "HandHeaderView.h"
#import "HandphotoCell.h"
#import "HandPhotoMutleCell.h"

#import "SRActionSheet.h"

#import "JHCustomFlow.h"
#import "RHCollectionViewFlowLayout.h"
#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height
#define kScale [UIScreen mainScreen].bounds.size.width/375.0
@interface SecondViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SRActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,HandPhotoMutleCellDelegate>
@property (weak, nonatomic) IBOutlet UILabel *tokenLabel;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) ResponseModel    *responseModel;


@property (nonatomic, assign) NSInteger   currentSection;
@property (nonatomic, assign) NSInteger   currentIndex;
@property (nonatomic, assign) NSInteger   currentItem;
@end

static CGFloat itemMargen = 5;
static CGFloat sectionViewH = 65;
static NSString *cellIdentifier = @"HandphotoCell";
static NSString *cellIdentifier2 = @"HandPhotoMutleCell";
static NSString *headIdentifier = @"HandHeaderView";
@implementation SecondViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //从plist文件中找到responseModel，刷新页面
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3/*延迟执行时间*/ * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSData *dataPath = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/Documents/%@/%@/1.plist",NSHomeDirectory(),self.bussFolderName,self.bussID]];
        ResponseModel *testModel = [NSKeyedUnarchiver unarchiveObjectWithData:dataPath];
        if (testModel.categories.count>0) {
            
            self.responseModel = testModel;
            [self.collectionView reloadData];
        }
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.responseModel = [[ResponseModel alloc] init];
    [self setupUI];
}

- (void)setupUI {
    [self setupNav];
    [self setupCollectionView];
    [self.view addSubview:self.collectionView];
    [self.view sendSubviewToBack:self.collectionView];
}

- (void)setupNav {
    self.navigationItem.title = @"附件";
}
- (void)setupCollectionView {
    self.collectionView.backgroundColor = [UIColor greenColor];
}

#pragma mark - lazy load
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        RHCollectionViewFlowLayout *layout = [[RHCollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(itemMargen, 10, itemMargen, 10);
//        layout.minimumLineSpacing = itemMargen;
//        layout.minimumInteritemSpacing = 0;
 //       layout.headerReferenceSize = CGSizeMake(kScreenW, sectionViewH);
//        layout.itemSize = CGSizeMake((kScreenW-40)/3, (kScreenW-40)/3*0.85);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 200, kScreenW, kScreenH-200) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:cellIdentifier bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
        [_collectionView registerNib:[UINib nibWithNibName:cellIdentifier2 bundle:nil] forCellWithReuseIdentifier:cellIdentifier2];
        [_collectionView registerNib:[UINib nibWithNibName:headIdentifier bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headIdentifier];
    }
    return _collectionView;
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CategoryModel *categoryModel = self.responseModel.categories[indexPath.section];
    ItemsModel *item = categoryModel.items[indexPath.row];

    return item.itemSize;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(kScreenW, sectionViewH);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    
    return CGSizeMake(kScreenW, 1);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.responseModel.categories.count;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    CategoryModel *categoryModel = self.responseModel.categories[indexPath.section];
    HandHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headIdentifier forIndexPath:indexPath];
    headerView.backgroundColor = [UIColor redColor];
    headerView.titleLabel.text = categoryModel.title;
    if (indexPath.section == 2) {
        headerView.tipLabel.hidden = YES;
    }else{
        headerView.tipLabel.hidden = NO;
    }
    return headerView;
}




- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    CategoryModel *categoryModel = self.responseModel.categories[section];
    NSLog(@"-categoryModel----%ld",categoryModel.items.count);
    return categoryModel.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CategoryModel *categoryModel = self.responseModel.categories[indexPath.section];
    ItemsModel *item = categoryModel.items[indexPath.row];
    if ([item.multiple isEqualToString:@"0"]) {
        HandphotoCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        cell.itemModel = item;
        cell.titleLabel.text = item.title;
        return cell;
    }else{
        HandPhotoMutleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier2 forIndexPath:indexPath];
        cell.itemModel = item;
        cell.delegate = self;
        [cell pickerImageWithCurrentSection:indexPath.section withCurrentIndex:indexPath.row withItemModel:item];
        cell.titleLabel.text = item.title;
        return cell;
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"---当前点击的是第%ld区----第%ld个",indexPath.section,indexPath.row);
    self.currentSection = indexPath.section;
    self.currentIndex = indexPath.row;

    CategoryModel *categoryModel = self.responseModel.categories[indexPath.section];
    ItemsModel *itemModel = categoryModel.items[indexPath.row];
    
}
#pragma mark - HandPhotoMutleCellDelegate
- (void)onClickItemAtSection:(NSInteger)section
                     AtIndex:(NSInteger)index
                      atItem:(NSInteger)item{
    self.currentSection = section;
    self.currentIndex = index;
    self.currentItem = item;
    CategoryModel *categoryModel = self.responseModel.categories[section];
    ItemsModel *itemModel = categoryModel.items[index];
    if (itemModel.files>0) {
        FileModel *fileModel = itemModel.files[item];
        if (fileModel.hashMessage.length>0) {
            //查看
        }else{
            //拍照
        }
    }
}


- (void)showAlertView {
    SRActionSheet *sheet = [SRActionSheet sr_actionSheetViewWithTitle:@"选择文件" cancelTitle:@"取消" destructiveTitle:nil otherTitles:@[@"图库",@"相机"] otherImages:nil delegate:self];
    [sheet show];
}
#pragma mark - SRActionSheetDelegate
- (void)actionSheet:(SRActionSheet *)actionSheet didSelectSheet:(NSInteger)index {
    switch (index) {
        case 0:{
            [self selectedPicMethod];
        }
            break;
        case 1:{
            [self takePhotoMethod];
        }
            break;
        case -1:{
            
        }
            break;
        default:
            break;
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
    ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
    if (authStatus == ALAuthorizationStatusDenied) {
        return;
    }
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
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    CategoryModel *categoryModel = self.responseModel.categories[self.currentSection];
    ItemsModel *itemModel = categoryModel.items[self.currentIndex];
    
    NSLog(@"--相册内容--------%@",info);
    UIImage *image = nil;
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        image = info[UIImagePickerControllerOriginalImage];
        
//        //需不需要创建文件夹
//        if (![FileManagerTool fileExistsAtPath:[NSString stringWithFormat:@"%@/Documents/%@/%@",NSHomeDirectory(),self.bussFolderName,self.bussID]]) {
//            [self createFolderNameWithName:self.bussID];
//            [self saveTemplateModelToLocalWithPath:[NSString stringWithFormat:@"%@/%@/1.plist",self.bussFolderName,self.bussID]];
//        }
            //    拿到图片名字  亲测只对图片有效
            NSURL *refURL = [info valueForKey:UIImagePickerControllerReferenceURL];
        
            /*
            //复制对象
            if ([itemModel.multiple isEqualToString:@"1"]) {
                FileModel *fileModle = [[FileModel alloc] init];
                
            }
            
            NSData *imageData = UIImageJPEGRepresentation(image, 0.001);
            //把图片写入本地
            NSString *filePath = [NSString stringWithFormat:@"Documents/%@/%@/%ld%ld.png",self.bussFolderName,self.bussID,self.currentSection,self.currentIndex];
            [imageData writeToFile:[NSString stringWithFormat:@"%@/%@",NSHomeDirectory(),filePath] atomically:YES];
            
            //把Model写入本地
            [self saveTemplateModelToLocalWithPath:[NSString stringWithFormat:@"%@/%@/1.plist",self.bussFolderName,self.bussID]];
             */
        
        
    }
    [picker dismissViewControllerAnimated:YES completion:^{
    }];

}
/**
 把模型存入本地
 
 @param path 路径
 */
- (BOOL)saveTemplateModelToLocalWithPath:(NSString *)path {
    NSString *dataPath = [NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),path];
    
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:self.responseModel];
    
    BOOL issuccess =  [data writeToFile:dataPath atomically:YES];
    
    return issuccess;
}


- (IBAction)getTokenButtonClick:(id)sender {
    NSString *timeString = [self getCurrentTime];
    NSString *resource = [NSString stringWithFormat:@"%@%@%@%@",@"godsuy",timeString,@"apply",@"170600035"];
    
    NSLog(@"----resource--%@",resource);
    NSString *sign = [NSString stringWithHMACMD5:resource key:@"godsuy.key"];
    
    //                            @"schema":@"fintech",@"fintech"
    
    NSLog(@"----sign--%@",sign);
    NSDictionary *param = @{@"tenant":@"godsuy",
                            @"time":[self getCurrentTime],
                            @"view":@"apply",
                            @"struct":@"170600035",
                            @"sign":sign};
    NSString *url = [NSString stringWithFormat:@"http://192.168.88.48:8081/mcloud/getToken.jjs?tenant=godsuy&time=%@&view=apply&struct=170600035&sign=%@",timeString,sign];
    [NetworkTool GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        //        NSLog(@"---dic-----%@",dic);
        NSLog(@"--------%@",responseObject);
        self.token = responseObject[@"token"];
        
        self.tokenLabel.text = self.token;
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"----error--%@",error);
        
    }];
    
}
- (IBAction)fujianMessageButtonClick:(id)sender {
    //[self requestPicMessageWithHash:@""];
    
    [NetworkTool POST:@"http://192.168.88.48:8081/mcloud/struct.jjs" params:@{@"token":self.token} success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"----------dic---%@",dic);
        ResponseModel *responseModel = [ResponseModel mj_objectWithKeyValues:dic];
        self.responseModel = responseModel;
        [self.collectionView reloadData];
        /***
        for (int i=0; i<responseModel.categories.count; i++) {
            CategoryModel *categoryModel = responseModel.categories[i];
            NSLog(@"----CategoryModel---title---%@",categoryModel.title);
            for (int j=0; j<categoryModel.items.count; j++) {
                ItemsModel *itemModel = categoryModel.items[j];
                NSLog(@"----itemModel---title---%@",itemModel.title);
                for (int k=0; k<itemModel.files.count; k++) {
                    FileModel *fileModel = itemModel.files[k];
                    NSLog(@"----fileModel---name---%@",fileModel.name);
                   // [self requestPicMessageWithHash:fileModel.hashMessage];
                    //break;
                }
                
            }
        }
         */
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
         NSLog(@"----error--%@",error);
    }];
     
    
}
- (IBAction)getDetailFileMessageButtonClick:(UIButton *)sender {
    
    [self showAlertView];
//    [NetworkTool POST:@"http://192.168.88.48:8081/mcloud/file.jjs" params:@{@"hash":@"a1fa49ba9ef2214a98ed5405d1faba12fe116069d388def7ac883c2c40081726.jpg",@"token":self.token} success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"----dic--%@",dic);
//    } fail:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"----error--%@",error.description);
//    }];

}

- (void)requestPicMessageWithHash:(NSString *)hash {
}


- (NSString *)getCurrentTime{
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

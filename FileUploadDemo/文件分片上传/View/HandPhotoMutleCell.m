//
//  HandPhotoMutleCell.m
//  文件分片上传
//
//  Created by seehoo on 2017/9/25.
//  Copyright © 2017年 seehoo. All rights reserved.
//

#import "HandPhotoMutleCell.h"
#import "FileModel.h"

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

@interface HandPhotoMutleCell()
@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, assign)NSInteger currentSection;
@property (nonatomic, assign)NSInteger currentIndex;
@end

@implementation HandPhotoMutleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLabel.font = [UIFont systemFontOfSize:12];
}
- (instancetype)init{
    if (self = [super init]) {
        self.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return self;
}
- (NSMutableArray *)buttonArray {
    if (!_buttonArray) {
        _buttonArray = [[NSMutableArray alloc] init];
    }
    return _buttonArray;
}
- (void)pickerImageWithCurrentSection:(NSInteger)currentSection
                     withCurrentIndex:(NSInteger)currentIndex
                        withItemModel:(ItemsModel *)itemModel{
    self.currentSection = currentSection;
    self.currentIndex = currentIndex;
    self.itemModel = itemModel;
    
    CGFloat buttonW = (kScreenW-40)/4;
    CGFloat buttonH = (kScreenW-40)/4*0.85;

    if (itemModel.files.count>0) {
        [self.buttonArray removeAllObjects];
        for (int i=0; i<itemModel.files.count; i++) {
            FileModel *fileModel = self.itemModel.files[i];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            CGFloat buttonX = i%4*(buttonW+5);
            CGFloat buttonY = i/4*(buttonH+5);
            button.tag = 1000+i;
            button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
            button.backgroundColor = [UIColor blueColor];
            [button setTitle:fileModel.name forState:UIControlStateNormal];
            [button addTarget:self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            //[self insertSubview:button atIndex:0];
            [self.contentView addSubview:button];
            [self.buttonArray addObject:button];
        }
    }else{
        
        for (UIButton *button in self.buttonArray) {
            [button removeFromSuperview];
        }
        UIButton *oneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        oneButton.frame = CGRectMake(0, 5, buttonW, buttonH);
        oneButton.backgroundColor = [UIColor lightGrayColor];
        [oneButton addTarget:self action:@selector(oneButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [oneButton setTitle:@"选择文件" forState:UIControlStateNormal];
        oneButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:oneButton];
    }

    
    
}

- (void)setItemModel:(ItemsModel *)itemModel {
    
//    if (itemModel.files.count>0) {
//        UILabel *label = [[UILabel alloc] init];
//        label.frame = CGRectMake(0, 0, self.bounds.size.width, 40);
//        label.text = @"支付宝";
//        label.tag = 5;
//        label.backgroundColor = [UIColor redColor];
//        [self.contentView addSubview:label];
//    }else{
//        UILabel *label = [self.contentView viewWithTag:5];
//        [label removeFromSuperview];
//    }
    /*
    
    CGFloat buttonW = (kScreenW-40)/4;
    CGFloat buttonH = (kScreenW-40)/4*0.85;
    NSLog(@"---setItemModel---itemModel.count--%ld",itemModel.files.count);
    if (itemModel.files.count>0) {
        [self.buttonArray removeAllObjects];
        for (int i=0; i<itemModel.files.count; i++) {
            
            NSLog(@"---==当前i---%d",i);
            FileModel *fileModel = self.itemModel.files[i];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            CGFloat buttonX = i%4*(buttonW+5);
            CGFloat buttonY = i/4*(buttonH+5);
            button.tag = 1000+i;
            button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
            button.backgroundColor = [UIColor blueColor];
            [button setTitle:fileModel.name forState:UIControlStateNormal];
            [button addTarget:self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            //[self insertSubview:button atIndex:0];
            [self.contentView addSubview:button];
            [self.buttonArray addObject:button];
        }
    }else{
        
        for (UIButton *button in self.buttonArray) {
            [button removeFromSuperview];
        }
        UIButton *oneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        oneButton.frame = CGRectMake(0, 5, buttonW, buttonH);
        oneButton.backgroundColor = [UIColor lightGrayColor];
        [oneButton addTarget:self action:@selector(oneButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [oneButton setTitle:@"选择文件" forState:UIControlStateNormal];
        oneButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:oneButton];
    }
     */
}
- (void)oneButtonClick {
    if (_delegate &&[_delegate respondsToSelector:@selector(onClickItemAtSection:AtIndex:atItem:)]) {
        [_delegate onClickItemAtSection:self.currentSection AtIndex:self.currentIndex atItem:0];
    }
}
- (void)moreButtonClick:(UIButton *)sender {

    if (_delegate &&[_delegate respondsToSelector:@selector(onClickItemAtSection:AtIndex:atItem:)]) {
        [_delegate onClickItemAtSection:self.currentSection AtIndex:self.currentIndex atItem:sender.tag-1000];
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];

}

@end

//
//  HandphotoCell.m
//  Mogo
//
//  Created by seehoo on 2017/5/26.
//  Copyright © 2017年 zpc. All rights reserved.
//NSMutableArray
//http://pic6.huitu.com/res/20130116/84481_20130116142820494200_1.jpg

#import "HandphotoCell.h"


@interface HandphotoCell()
@property (nonatomic, strong) NSMutableArray *imageMessageArray;

@end

@implementation HandphotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    
}

- (void)setImageViewWithName:(NSString *)imageString
          WithCurrentSection:(NSInteger)section
            WithCurrentIndex:(NSInteger)index {
    
    if (imageString.length<=0) {
        
        self.imageView.image = self.imageMessageArray[section][index];
        self.coverView.hidden = NO;
        self.cameraView.hidden = NO;
    }else{
        
        self.imageView.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",NSHomeDirectory(),imageString]];
        
        [self.coverView setHidden:YES];
        self.cameraView.hidden = YES;
    }
}

- (void)setImageViewWithName:(NSString *)imageURLString
          WithPlaceImageName:(NSString *)placeURLString
          WithCurrentSection:(NSInteger)section
            WithCurrentIndex:(NSInteger)index
                    WithMark:(NSString *)mark{
    
    
    if ([mark isEqualToString:@"1"]) {
        self.imageView.layer.borderColor = [[UIColor redColor] CGColor];
        self.imageView.layer.borderWidth = 2;
    }else{
        self.imageView.layer.borderColor = [[UIColor clearColor] CGColor];
        self.imageView.layer.borderWidth = 0;
    }
    
    if (imageURLString.length<=0) {
        
//        //[self.imageView sd_setImageWithURL:[NSURL URLWithString:placeURLString]];
//        [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",kBaseURL,placeURLString]]];
//        self.coverView.hidden = NO;
//        self.cameraView.hidden = NO;
        
    }else{

        if (![imageURLString containsString:@"Documents"]) {
//            [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",kBaseURL,imageURLString]]];
//
        }else{
            
            self.imageView.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",NSHomeDirectory(),imageURLString]];
        }
        [self.coverView setHidden:YES];
        self.cameraView.hidden = YES;
    }
}
- (void)setItemModel:(ItemsModel *)itemModel {
    self.titleLabel.text = itemModel.title;
    

}

- (NSMutableArray *)imageMessageArray {
    if (!_imageMessageArray) {
        NSArray *array = @[@[[UIImage imageNamed:@"12.png"],
                             [UIImage imageNamed:@"12.png"],
                             [UIImage imageNamed:@"登记证书第1、2页.png"],
                             [UIImage imageNamed:@"登记证书第3、4页.png"],
                             [UIImage imageNamed:@"车辆铭牌信息.png"]
                             ],
                           @[[UIImage imageNamed:@"左前45°.png"],
                             [UIImage imageNamed:@"右后45°.png"],
                             [UIImage imageNamed:@"发动机盖.png"],
                             [UIImage imageNamed:@"发动机舱.png"],
                             [UIImage imageNamed:@"左前减震座.png"],
                             [UIImage imageNamed:@"右前减震座.png"],
                             [UIImage imageNamed:@"后备箱.png"],
                             [UIImage imageNamed:@"后备胎槽.png"],
                             [UIImage imageNamed:@"仪表台和日期合影.png"],
                             [UIImage imageNamed:@"左前门.png"],
                             [UIImage imageNamed:@"右前门.png"],
                             [UIImage imageNamed:@"左右门.png"],
                             [UIImage imageNamed:@"右前门.png"]],
                           @[[UIImage imageNamed:@"12.png"],
                             [UIImage imageNamed:@"12.png"],
                             [UIImage imageNamed:@"12.png"],
                             [UIImage imageNamed:@"12.png"],
                             [UIImage imageNamed:@"12.png"]],
                           @[[UIImage imageNamed:@"12.png"]]];
        _imageMessageArray = [NSMutableArray arrayWithArray:array];
    }
    return _imageMessageArray;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

@end

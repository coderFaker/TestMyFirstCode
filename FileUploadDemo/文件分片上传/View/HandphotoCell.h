//
//  HandphotoCell.h
//  Mogo
//
//  Created by seehoo on 2017/5/26.
//  Copyright © 2017年 zpc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemsModel.h"
@interface HandphotoCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet UIImageView *cameraView;

@property (nonatomic, strong) ItemsModel   *itemModel;
- (void)setImageViewWithName:(NSString *)imageString
          WithCurrentSection:(NSInteger)section
            WithCurrentIndex:(NSInteger)index;

//当前在用
- (void)setImageViewWithName:(NSString *)imageURLString
          WithPlaceImageName:(NSString *)placeURLString
          WithCurrentSection:(NSInteger)section
            WithCurrentIndex:(NSInteger)index
                    WithMark:(NSString *)mark;
@end

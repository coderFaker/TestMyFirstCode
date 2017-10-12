//
//  HandPhotoMutleCell.h
//  文件分片上传
//
//  Created by seehoo on 2017/9/25.
//  Copyright © 2017年 seehoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemsModel.h"


@protocol HandPhotoMutleCellDelegate <NSObject>

- (void)onClickItemAtSection:(NSInteger)section
                     AtIndex:(NSInteger)index
                      atItem:(NSInteger)item;

@end

@interface HandPhotoMutleCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) ItemsModel   *itemModel;
@property (nonatomic,weak)id<HandPhotoMutleCellDelegate> delegate;

- (void)pickerImageWithCurrentSection:(NSInteger)currentSection
                     withCurrentIndex:(NSInteger)currentIndex
                        withItemModel:(ItemsModel *)itemModel;
@end

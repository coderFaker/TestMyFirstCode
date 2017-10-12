//
//  HandHeaderView.h
//  Mogo
//
//  Created by seehoo on 2017/5/26.
//  Copyright © 2017年 zpc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HandHeaderView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;


//@property (nonatomic, strong) SecondHandModel *model;
- (void)setTitleMessageWithArray:(NSMutableArray *)titleArray WithCurrentSection:(NSInteger)section;

- (void)setTitleMessageWithArray:(NSMutableArray *)titleArray;
@end

//
//  HandHeaderView.m
//  Mogo
//
//  Created by seehoo on 2017/5/26.
//  Copyright © 2017年 zpc. All rights reserved.
//

#import "HandHeaderView.h"

@implementation HandHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.contentLabel.font = [UIFont systemFontOfSize:16];
    
}
- (void)setTitleMessageWithArray:(NSMutableArray *)titleArray WithCurrentSection:(NSInteger)section {
    NSArray *array = titleArray[section];
    int index = 0;
    for (NSString *string in array) {
        if (string.length>0) {
            index++;
        }
    }
    self.contentLabel.text = [NSString stringWithFormat:@"(%d/%ld)",index,(unsigned long)array.count];
}
- (void)setTitleMessageWithArray:(NSMutableArray *)titleArray {
    
    int index = 0;
    for (NSString *string in titleArray) {
        if (string.length>0) {
            index++;
        }
    }
    self.contentLabel.text = [NSString stringWithFormat:@"(%d/%ld)",index,(unsigned long)titleArray.count];
}

@end

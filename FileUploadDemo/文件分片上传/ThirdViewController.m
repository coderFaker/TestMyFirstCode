//
//  ThirdViewController.m
//  文件分片上传
//
//  Created by seehoo on 2017/9/28.
//  Copyright © 2017年 seehoo. All rights reserved.
//

#import "ThirdViewController.h"

@interface ThirdViewController ()

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self gcdTestMethod];
}

- (void)gcdTestMethod {
    NSArray *array = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",
                       @"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",
                       @"",@"",@"",@"",@"",@"",@"",@"",@"",@"",
                       @"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_apply(array.count, queue, ^(size_t i) {
//        NSLog(@"------%zu",i);
//        NSString *string = array[i];
//        NSLog(@"-------string----%@",string);
//        
//    });
//    dispatch_apply(10000, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t i) {
//        NSLog(@"------%zu",i);
//    });
//    [array enumerateObjectsUsingBlock:^(NSString *string, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSLog(@"------%zu",idx);
//        NSLog(@"-------string----%@",string);
//
//        
//    }];

    for (int i=0; i<10000; i++) {
        NSLog(@"------%d",i);

    }
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

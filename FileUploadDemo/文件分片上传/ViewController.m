//
//  ViewController.m
//  文件分片上传
//
//  Created by seehoo on 2017/9/18.
//  Copyright © 2017年 seehoo. All rights reserved.
//

#import "ViewController.h"
#import "FirstViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //self.textField.keyboardType = UIKeyboardTypeNumberPad;
    
}
- (IBAction)gotoUploadButtonClick:(id)sender {
    [self.navigationController pushViewController:[FirstViewController new] animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

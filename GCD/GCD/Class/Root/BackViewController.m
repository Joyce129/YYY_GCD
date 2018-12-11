//
//  BackViewController.m
//  GCD
//
//  Created by Jean on 2018/12/11.
//  Copyright © 2018年 北京易盟天地信息技术股份有限公司. All rights reserved.
//

#import "BackViewController.h"

@interface BackViewController ()

@property(nonatomic, strong)UIButton *backButton;

@end

@implementation BackViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
}

- (UIButton *)backButton
{
    if (!_backButton)
    {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake(0, 0, 60, 30);
        //_backButton.backgroundColor = [UIColor redColor];
        [_backButton setImage:[UIImage imageNamed:@"common_back"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        _backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -50, 0, 0);
    }
    return _backButton;
}

//返回事件
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}



@end

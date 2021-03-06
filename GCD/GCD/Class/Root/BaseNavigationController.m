

//
//  BaseNavigationController.m
//  GCD
//
//  Created by Jean on 2018/12/11.
//  Copyright © 2018年 北京易盟天地信息技术股份有限公司. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    /*
    __weak BaseNavigationController *weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
    }
     */
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0)
    {
        viewController.navigationItem.hidesBackButton = YES;
        //隐藏分栏
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
    if ([viewController.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        viewController.navigationController.interactivePopGestureRecognizer.enabled = YES;
        viewController.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

@end

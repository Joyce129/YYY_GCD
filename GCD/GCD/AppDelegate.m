//
//  AppDelegate.m
//  GCD
//
//  Created by Jean on 2018/12/10.
//  Copyright © 2018年 北京易盟天地信息技术股份有限公司. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:[NSClassFromString(@"RootViewController") new]];
    self.window.rootViewController = [NSClassFromString(@"RootViewController") new];
    [self.window makeKeyAndVisible];
    return YES;
}

@end

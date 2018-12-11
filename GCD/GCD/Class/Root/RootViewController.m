


//
//  RootViewController.m
//  GCD
//
//  Created by YYY on 2017/12/29.
//  Copyright © 2017年 成品家（北京）网路科技有限公司. All rights reserved.
//

#import "RootViewController.h"
#import "BaseNavigationController.h"

#import "NSThreadController.h"
#import "NSOperationController.h"
#import "GCDViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"path = %@", path);
    
    NSThreadController *thread = [[NSThreadController alloc]init];
    thread.title = @"NSThread";
    
    NSOperationController *operation = [[NSOperationController alloc]init];
    operation.title = @"NSOperation";
    
    GCDViewController *gcd = [[GCDViewController alloc]init];
    gcd.title = @"GCD";
    
    NSArray *controllers = @[thread, operation, gcd];
    NSMutableArray *subControllers = [NSMutableArray array];
    
    for (int i=0; i<3; i++)
    {
        BaseNavigationController *navVC = [[BaseNavigationController alloc] initWithRootViewController:controllers[i]];
        [subControllers addObject:navVC];
    }
    [self setViewControllers:subControllers animated:YES];
}

@end

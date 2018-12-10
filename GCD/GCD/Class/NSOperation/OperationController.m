


//
//  OperationController.m
//  GCD
//
//  Created by YYY on 2017/12/29.
//  Copyright © 2017年 成品家（北京）网路科技有限公司. All rights reserved.
//

#import "OperationController.h"

@interface OperationController ()

{
    NSString *imageUrl;
}
@property(nonatomic, strong)UIImageView *tempImageView;

@end

@implementation OperationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tempImageView];
    
    imageUrl = @"http://img04.sogoucdn.com/app/a/100520024/8272033edf9190a2cdedcd599781614f";
    
    if (_flag == 0)
    {
        //NSInvocationOperation创建线程
        NSInvocationOperation *invocationOperation = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(loadImageData:) object:imageUrl];
        //直接在当前线程主线程执行
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [queue addOperation:invocationOperation];
    }
    else
    {
        //NSBlockOperation创建线程
        NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
            [self loadImageData:imageUrl];
        }];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [queue addOperation:blockOperation];
        
    }
    // Do any additional setup after loading the view.
}
- (UIImageView *)tempImageView
{
    if (!_tempImageView)
    {
        _tempImageView = [[UIImageView alloc]initWithFrame:CGRectMake(50, 100, 300, 533)];
    }
    return _tempImageView;
}


- (void)loadImageData:(NSString *)urlString
{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
    UIImage *image = [UIImage imageWithData:data];
    if (image != nil)
    {
        [self performSelectorOnMainThread:@selector(refreshImageView:) withObject:image waitUntilDone:YES];
    }
}


- (void)refreshImageView:(UIImage *)image
{
    _tempImageView.image = image;
}

@end

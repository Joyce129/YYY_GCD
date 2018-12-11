


//
//  OperationController.m
//  GCD
//
//  Created by YYY on 2017/12/29.
//  Copyright © 2017年 成品家（北京）网路科技有限公司. All rights reserved.
//

#import "OperationController.h"

@interface OperationController ()

@property(nonatomic, copy)NSString *imageUrl;

@property(nonatomic, strong)UIImageView *tempImageView;

@end

@implementation OperationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"NSOperationQueue使用语法";
    
    [self.view addSubview:self.tempImageView];
    
    _imageUrl = @"http://pic1.cxtuku.com/00/03/76/b37005566943.jpg";
    
    if (_flag == 0)
    {
        //NSInvocationOperation创建线程
        NSInvocationOperation *invocationOperation = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(loadImageData:) object:_imageUrl];
        //直接在当前线程主线程执行
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [queue addOperation:invocationOperation];
    }
    else
    {
        //NSBlockOperation创建线程
        NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
            [self loadImageData:self.imageUrl];
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
        _tempImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 120, 350, 300)];
        _tempImageView.image = [UIImage imageNamed:@"1"];
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

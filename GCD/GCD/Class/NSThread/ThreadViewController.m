



//
//  ThreadViewController.m
//  GCD
//
//  Created by YYY on 2017/12/29.
//  Copyright © 2017年 成品家（北京）网路科技有限公司. All rights reserved.
//

#import "ThreadViewController.h"

@interface ThreadViewController ()
{
    NSString *imageUrl;
}
@property(nonatomic, strong)UIImageView *tempImageView;

@end

@implementation ThreadViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"NSThread使用语法";

    //创建线程
    //[self createThread];
    
    [self.view addSubview:self.tempImageView];
    
    imageUrl = @"http://img02.sogoucdn.com/app/a/100520024/a6e4cd3cfb506dd55ee9484b80186b40";
    [self.view addSubview:self.tempImageView];
    if (_flag == 0)
    {
        //动态实例化
        NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(dynamicThreadAction:) object:imageUrl];
        //设置线程优先级
        thread.threadPriority = 1;
        [thread start];
    }
    else if (_flag == 1)
    {
        //静态实例化
        [NSThread detachNewThreadSelector:@selector(staticThreadAction:) toTarget:self withObject:imageUrl];
    }
    else
    {
        //隐式实例化
        [self performSelectorInBackground:@selector(implicitThreadAction:) withObject:imageUrl];
    }
}

//创建线程
- (void)createThread
{
    //获取当前线程
    NSThread *currentThread = [NSThread currentThread];
    
    //获取主线程
    NSThread *mainThread = [NSThread mainThread];
    
    //暂停当前线程
    [NSThread sleepForTimeInterval:2];
    
    //线程之间通信
    //在指定线程上执行操作
    [self performSelector:@selector(run) onThread:currentThread withObject:nil waitUntilDone:YES];
    
    //在主线程上执行操作
    [self performSelectorOnMainThread:@selector(run) withObject:nil waitUntilDone:YES];
    
    //在当前线程上执行操作
    [self performSelector:@selector(run) withObject:nil];
}

- (UIImageView *)tempImageView
{
    if (!_tempImageView)
    {
        _tempImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 120, 350, 300)];
        _tempImageView.image = [UIImage imageNamed:@"2"];
    }
    return _tempImageView;
}

- (void)dynamicThreadAction:(NSString *)urlString
{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
    UIImage *image = [UIImage imageWithData:data];
    if (image != nil)
    {
        [self performSelectorOnMainThread:@selector(refreshImageView:) withObject:image waitUntilDone:YES];
    }
}

- (void)staticThreadAction:(NSString *)urlString
{
    [self dynamicThreadAction:urlString];
}

- (void)implicitThreadAction:(NSString *)urlString
{
    [self dynamicThreadAction:urlString];
}

- (void)refreshImageView:(UIImage *)image
{
    _tempImageView.image = image;
}

@end

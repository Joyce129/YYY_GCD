



//
//  GCDViewController.m
//  GCD
//
//  Created by YYY on 2017/12/29.
//  Copyright © 2017年 成品家（北京）网路科技有限公司. All rights reserved.
//

#import "GCDViewController.h"

#import "AFNetworking.h"

//宏定义全局并发队列
#define global_queue dispatch_get_global_queue(0, 0)

//宏定义主队列
#define main_queue dispatch_get_main_queue()

@interface GCDViewController ()
{

}
@property(nonatomic, strong)UIImageView *tempImageView1;
@property(nonatomic, strong)UIImage *image1;

@property(nonatomic, strong)UIImageView *tempImageView2;
@property(nonatomic, strong)UIImage *image2;

@end

@implementation GCDViewController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //信号量
    [self signal];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    [self.view addSubview:self.tempImageView1];
    [self.view addSubview:self.tempImageView2];

    //[self signal1];
    
    //调度组异步执行任务
    [self group];
    
    //[self asyncGroup];
}
- (UIImageView *)tempImageView1
{
    if (!_tempImageView1)
    {
        _tempImageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 120, 220, 150)];
        _tempImageView1.image = [UIImage imageNamed:@"1"];
    }
    return _tempImageView1;
}

- (UIImageView *)tempImageView2
{
    if (!_tempImageView2)
    {
        _tempImageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 300, 220, 150)];
        _tempImageView2.image = [UIImage imageNamed:@"2"];
    }
    return _tempImageView2;
}

/**********************dispatch_group 调度组******************/
//调度组
- (void)group
{
    //创建队列组
    dispatch_group_t group = dispatch_group_create();
    
    //入组
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.image1 = [self loadImageData:@"http://pic1.cxtuku.com/00/03/76/b37005566943.jpg"];
        NSLog(@"图片1下载完成: %@",[NSThread currentThread]);
        //出组
        dispatch_group_leave(group);
    });
    
    //入组
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.image2 = [self loadImageData:@"http://img3.redocn.com/tupian/20150408/shucaihelvyezhuangshideshiliangbiankuang_4036044.jpg"];
        NSLog(@"图片2下载完成: %@",[NSThread currentThread]);
        //出组
        dispatch_group_leave(group);
    });
    
    //监听任务完成
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        self.tempImageView1.image = self.image1;
        self.tempImageView2.image = self.image2;
        NSLog(@"显示图片: %@",[NSThread currentThread]);
    });
}

- (void)asyncGroup
{
    //队列组加载图片
    __block UIImage *image1;
    __block UIImage *image2;
    //创建队列组
    dispatch_group_t group = dispatch_group_create();

    //下载任务1
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        image1  = [self loadImageData:@"http://img02.sogoucdn.com/app/a/07/154ab4353f086a9a1ae3eb1cd34d17b9"];
        NSLog(@"图片1下载完成: %@",[NSThread currentThread]);
    });
    
    //下载任务2
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        image2  = [self loadImageData:@"http://img03.sogoucdn.com/app/a/100520020/ae923a4747d1cdd755d5d238d1468cb3"];
        NSLog(@"图片2下载完成: %@",[NSThread currentThread]);
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        self.tempImageView1.image = image1;
        self.tempImageView2.image = image2;
        NSLog(@"显示图片: %@",[NSThread currentThread]);
    });
}
- (UIImage *)loadImageData:(NSString *)urlString
{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
    UIImage *image = [UIImage imageWithData:data];
    return image;
}

//GCD常用函数
- (void)gcdFunction
{
    //主队列 dispatch_get_main_queue()
    //全局队列 dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    //执行一次 dispatch_once
    //循环遍历 dispatch_apply
    //延迟执行 dispatch_after
    
    //UI线程执行，长时间加载内容不放在主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        
    });
    
    //全局并发队列，线程创建
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
    });
    
    //一次性执行，单例 dispatch_once
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
    });
    
    //并发执行，循环迭代 dispatch_apply
    size_t count = 5;
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_apply(count, queue, ^(size_t i)
    {
        NSLog(@"循环执行第%ld次", i);
    });
    
    //延迟执行
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC);
    dispatch_after(when, dispatch_get_main_queue(), ^{
        
    });
    
    //自定义队列
    dispatch_queue_t queue1 = dispatch_queue_create("queue", NULL);
    dispatch_async(queue1, ^{
        
    });
}



/**********************dispatch_barrier_async******************/
//栅栏函数
- (void)barrier
{
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        for (NSInteger i = 0 ; i < 5 ; i++)
        {
            NSLog(@"download1 -- %zd -- %@",i,[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (NSInteger i = 0 ; i < 5 ; i++)
        {
            NSLog(@"download2 -- %zd -- %@",i,[NSThread currentThread]);
        }
    });
    
    dispatch_barrier_async(queue, ^{
        NSLog(@"+++++++++++++++");
    });
    
    dispatch_async(queue, ^{
        for (NSInteger i =0 ; i < 5 ; i++)
        {
            NSLog(@"download3 -- %zd -- %@",i,[NSThread currentThread]);
        }
    });
}

/**********************dispatch_semaphore_t******************/
- (void)signal
{
    //value表示最多几个资源可访问
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(3);
    //任务1
    dispatch_async(global_queue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"run task 1");
        sleep(1);
        NSLog(@"complete task 1");
        dispatch_semaphore_signal(semaphore);
    });
    
    //任务2
    dispatch_async(global_queue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"run task 2");
        sleep(1);
        NSLog(@"complete task 2");
        dispatch_semaphore_signal(semaphore);
    });
    
    //任务3
    dispatch_async(global_queue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"run task 3");
        sleep(1);
        NSLog(@"complete task 3");
        dispatch_semaphore_signal(semaphore);
    });
}
/**********************dispatch_apply******************/
//文件管理 循环迭代，并发执行
- (void)fileManagerDispatch_apply
{
    // 要剪切的文件夹路径
    NSString *fromPath = @"/Users/songweibo/Desktop/from";
    
    // 目标文件夹的路径
    NSString *toPath = @"/Users/songweibo/Desktop/to";
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // 得到文件夹中的子路径
    NSArray *subPaths = [fileManager subpathsAtPath:fromPath];
    
    NSLog(@"%@", subPaths);
    
    // 遍历文件并执行剪切文件的操作
    NSInteger count = subPaths.count;
    dispatch_apply(count, dispatch_get_global_queue(0, 0), ^(size_t index) {
        
        // 文件的名称
        NSString *fileName = subPaths[index];
        // 拼接文件的全路径
        NSString *subPath = [fromPath stringByAppendingPathComponent:fileName];
        // 拼接剪切的目标路径
        NSString *fullPath = [toPath stringByAppendingPathComponent:fileName];
        
        // 执行剪切操作
        [fileManager moveItemAtPath:subPath toPath:fullPath error:nil];
        
        NSLog(@"%@  %@   %@",subPath,fullPath,[NSThread currentThread]);
    });
}

- (void)signal1
{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_async(global_queue, ^{
        for (int i = 0; i<8; i++)
        {
            NSLog(@"i的值是:%d",i);
        }
        //发送通知
        dispatch_semaphore_signal(semaphore);
    });
    
    //信号量等待
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    for (int k = 0; k<5; k++)
    {
        NSLog(@"k的值是:%d",k);
    }
}

/**********************NSOperationQueue******************/
- (void)operationQueue
{
    //创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    //设置最低线程数
    queue.maxConcurrentOperationCount = 5;
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i<8; i++)
        {
            NSLog(@"i的值是:%d",i);
        }
    }];
    
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
        for (int k = 0; k<5; k++)
        {
            NSLog(@"k的值是:%d",k);
        }
    }];
    //实现线程同步
    //添加线程依赖
    [operation1 addDependency:operation2];
    //分别添加到队列中
    [queue addOperation:operation1];
    [queue addOperation:operation2];
}
/**********************NSOperationQueue和信号量******************/
-(void)dispatchAllRequest{
    // 利用线程依赖关系测试
    __weak typeof (self)weakSelf =self;
    
    NSBlockOperation * operation1 = [NSBlockOperation blockOperationWithBlock:^{
        [weakSelf requestA];
        
    }];
    NSBlockOperation * operation2 = [NSBlockOperation blockOperationWithBlock:^{
        [weakSelf requestB];
        
    }];
    NSBlockOperation * operation3 = [NSBlockOperation blockOperationWithBlock:^{
        [weakSelf requestC];
        
    }];
    [operation2 addDependency:operation1];
    [operation3 addDependency:operation2];
    NSOperationQueue * queue = [[NSOperationQueue alloc]init];
    [queue addOperations:@[operation1,operation2,operation3] waitUntilFinished:NO];
}
-(void)requestA{
    
    //创建信号量并设置计数默认为0
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",nil];
    [manager GET:@"http://qr.bookln.cn/qr.html?crcode=110000000F00000000000000B3ZX1CEC" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        dispatch_semaphore_signal(sema);
        NSLog(@"正在执行A");
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ////计数+1操作
        
        dispatch_semaphore_signal(sema);
        NSLog(@"执行错误A");
        
    }];
    
    NSLog(@"正在刷新A");
    //若计数为0则一直等待
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    NSLog(@"已经刷新A");
}
-(void)requestB{
    //创建信号量并设置计数默认为0
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",nil];
    [manager GET:@"http://qr.bookln.cn/qr.html?crcode=110000000F00000000000000B3ZX1CEC" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_semaphore_signal(sema);
        NSLog(@"正在执行B");
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ////计数+1操作
        
        dispatch_semaphore_signal(sema);
        NSLog(@"执行错误B");
        
    }];
    
    NSLog(@"正在刷新B");
    //若计数为0则一直等待
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    NSLog(@"已经刷新B");
    
}
-(void)requestC{
    
    //创建信号量并设置计数默认为0
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",nil];
    [manager GET:@"http://qr.bookln.cn/qr.html?crcode=110000000F00000000000000B3ZX1CEC" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_semaphore_signal(sema);
        NSLog(@"正在执行C");
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ////计数+1操作
        
        dispatch_semaphore_signal(sema);
        NSLog(@"执行错误C");
        
    }];
    
    NSLog(@"正在刷新C");
    //若计数为0则一直等待
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    NSLog(@"已经刷新C");
}
@end





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

@property(nonatomic, strong)UIImageView *tempImageView3;
@property(nonatomic, strong)UIImage *image3;

@end

@implementation GCDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.tempImageView1];
    [self.view addSubview:self.tempImageView2];
    [self.view addSubview:self.tempImageView3];
    
    //调度组异步执行任务
    [self dispatch_group_enter_leave];
    
    //[self dispatch_group_async];
    
    //栅栏函数
    //[self dispatch_barrier];
    
    //信号量
    //[self dispatch_semaphore];
    
    //添加线程依赖
    //[self operationQueue];
    
    //信号量和线程依赖实现线程同步
    //[self operationDependency];
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

- (UIImageView *)tempImageView3
{
    if (!_tempImageView3)
    {
        _tempImageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 480, 220, 150)];
        _tempImageView3.image = [UIImage imageNamed:@"3"];
    }
    return _tempImageView3;
}
/**********************dispatch_group 调度组******************/
//调度组
- (void)dispatch_group_enter_leave
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

- (void)dispatch_group_async
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

/**********************GCD常用函数******************/
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
//dispatch_barrier_async 和 dispatch_barrier_sync
//共同点：
/*
1、等待在它前面插入队列的任务先执行完
2、等待他们自己的任务执行完再执行后面的任务

不同点（追加任务的不同）：
1、dispatch_barrier_sync将自己的任务插入到队列的时候，需要等待自己的任务结束之后才会继续插入被写在它后面的任务，然后执行它们
2、dispatch_barrier_async将自己的任务插入到队列之后，不会等待自己的任务结束，它会继续把后面的任务插入到队列，然后等待自己的任务结束后才执行后面任务。
dispatch_barrier_async的不等待（异步）特性体现在将任务插入队列的过程，它的等待特性体现在任务真正执行的过程。
*/
//栅栏函数
- (void)dispatch_barrier
{
    //创建并发队列
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        self.image1  = [self loadImageData:@"http://img02.sogoucdn.com/app/a/07/154ab4353f086a9a1ae3eb1cd34d17b9"];
        
        [NSThread sleepForTimeInterval:5];
        NSLog(@"图片1下载完成: %@",[NSThread currentThread]);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tempImageView1.image = self.image1;
        });
    });
    dispatch_async(queue, ^{
        self.image2  = [self loadImageData:@"http://img03.sogoucdn.com/app/a/100520020/ae923a4747d1cdd755d5d238d1468cb3"];
        
        [NSThread sleepForTimeInterval:2];
        NSLog(@"图片2下载完成: %@",[NSThread currentThread]);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tempImageView2.image = self.image2;
        });
    });
    
    dispatch_barrier_async(queue, ^{
        for (int i = 0; i <= 5000000; i++)
        {
            if (i == 5000)
            {
                NSLog(@"point1");
            }
            else if (i == 6000)
            {
                NSLog(@"point2");
            }
            else if (i == 7000)
            {
                NSLog(@"point3");
            }
        }
        NSLog(@"+++++++++++++++");
    });
    
    NSLog(@"aaaaa");
    dispatch_async(queue, ^{
        self.image3 = [self loadImageData:@"http://img3.redocn.com/tupian/20150408/shucaihelvyezhuangshideshiliangbiankuang_4036044.jpg"];
        
        [NSThread sleepForTimeInterval:2];
        NSLog(@"图片3下载完成: %@",[NSThread currentThread]);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tempImageView3.image = self.image3;
        });
    });
    
    NSLog(@"bbbbb");
    dispatch_async(queue, ^{
        self.image2  = [self loadImageData:@"http://img03.sogoucdn.com/app/a/100520020/ae923a4747d1cdd755d5d238d1468cb3"];
        
        [NSThread sleepForTimeInterval:2];
        NSLog(@"图片4下载完成: %@",[NSThread currentThread]);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tempImageView2.image = self.image2;
        });
    });
}

/**********************dispatch_semaphore_t******************/
//信号量实现异步线程同步操作
- (void)dispatch_semaphore
{
    /*创建一个dispatch_semaphore_类型的信号量，并且创建的时候需要指定信号量的大小。
    等待信号量和发送信号量的函数是成对出现的。
    并发执行任务时候，在当前任务执行之前，用dispatch_semaphore_wait函数进行等待（阻塞），直到上一个任务执行完毕后且通过dispatch_semaphore_signal函数发送信号量（使信号量的值加1）。
    dispatch_semaphore_wait
    函数收到信号量之后判断信号量的值大于等于1，会再对信号量的值减1，然后当前任务可以执行，执行完毕当前任务后，再通过dispatch_semaphore_signal函数发送信号量（使信号量的值加1）
    等待信号量：如果信号量值为0，那么该函数就会一直等待，也就是不返回（相当于阻塞当前线程），直到该函数等待的信号量的值大于等于1，该函数会对信号量的值进行减1操作，然后返回。
    */
    
    //value表示最多几个资源可访问
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //任务1
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            self.image1  = [self loadImageData:@"http://img02.sogoucdn.com/app/a/07/154ab4353f086a9a1ae3eb1cd34d17b9"];

            NSLog(@"图片1下载完成: %@",[NSThread currentThread]);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.tempImageView1.image = self.image1;
            });
            
            //发送信号量：该函数会对信号量的值进行加1操作
            dispatch_semaphore_signal(semaphore);
        });
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        //任务2
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            self.image2  = [self loadImageData:@"http://img03.sogoucdn.com/app/a/100520020/ae923a4747d1cdd755d5d238d1468cb3"];

            NSLog(@"图片2下载完成: %@",[NSThread currentThread]);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.tempImageView2.image = self.image2;
            });
            
            dispatch_semaphore_signal(semaphore);
        });
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        //任务3
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            self.image3 = [self loadImageData:@"http://img3.redocn.com/tupian/20150408/shucaihelvyezhuangshideshiliangbiankuang_4036044.jpg"];

            NSLog(@"图片3下载完成: %@",[NSThread currentThread]);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.tempImageView3.image = self.image3;
            });
            
            dispatch_semaphore_signal(semaphore);
        });
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    NSLog(@"信号量结束");
}
/**********************dispatch_apply******************/
//文件管理 循环迭代，并发执行
- (void)fileManagerDispatch_apply
{
    // 要剪切的文件夹路径
    NSString *fromPath = @"/Users/yang/Desktop/from";
    
    // 目标文件夹的路径
    NSString *toPath = @"/Users/yang/Desktop/to";
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // 得到文件夹中的子路径
    NSArray *subPaths = [fileManager subpathsAtPath:fromPath];
    
    NSLog(@"%@", subPaths);
    
    // 遍历文件并执行剪切文件的操作
    NSInteger count = subPaths.count;
    dispatch_apply(count, dispatch_get_global_queue(0, 0), ^(size_t index)
    {
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
    //添加线程依赖，先执行operation2，后执行operation1
    [operation2 addDependency:operation2];
    //分别添加到队列中
    [queue addOperation:operation1];
    [queue addOperation:operation2];
}
/**********************NSOperationQueue和信号量******************/
//NSBlockOperation和dispatch_semaphore_t实现并发队列中的线程同步
-(void)operationDependency
{
    // 利用线程依赖关系测试
    //__weak typeof (self)weakSelf =self;
    
    NSBlockOperation * operation1 = [NSBlockOperation blockOperationWithBlock:^{
        [self requestA];
        
    }];
    NSBlockOperation * operation2 = [NSBlockOperation blockOperationWithBlock:^{
        [self requestB];
        
    }];
    NSBlockOperation * operation3 = [NSBlockOperation blockOperationWithBlock:^{
        [self requestC];
        
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
    [manager GET:@"http://qr.bookln.cn/qr.html?crcode=110000000F00000000000000B3ZX1CEC" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
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
    [manager GET:@"http://qr.bookln.cn/qr.html?crcode=110000000F00000000000000B3ZX1CEC" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        [NSThread sleepForTimeInterval:8];
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
-(void)requestC
{
    //创建信号量并设置计数默认为0
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",nil];
    [manager GET:@"http://qr.bookln.cn/qr.html?crcode=110000000F00000000000000B3ZX1CEC" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        [NSThread sleepForTimeInterval:4];
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

-(void)requestAA
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",nil];
    NSLog(@"当前线程2 %@", [NSThread currentThread]);
    [manager GET:@"http://qr.bookln.cn/qr.html?crcode=110000000F00000000000000B3ZX1CEC" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        [NSThread sleepForTimeInterval:8];
        NSLog(@"正在执行A %@", [NSThread currentThread]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"执行错误A");
    }];
    
    NSLog(@"正在刷新A %@", [NSThread currentThread]);
}

@end

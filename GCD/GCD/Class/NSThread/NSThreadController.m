


//
//  HomePageController.m
//  GCD
//
//  Created by YYY on 2017/12/29.
//  Copyright © 2017年 成品家（北京）网路科技有限公司. All rights reserved.
//

#import "NSThreadController.h"
#import "ThreadViewController.h"

@interface NSThreadController ()

@end

@implementation NSThreadController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.cellTitlesArray = @[@"动态创建线程", @"静态创建线程", @"隐式创建线程",];
    
}

#pragma mark UITableView代理方法
//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellTitlesArray.count;
}

//创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = self.cellTitlesArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ThreadViewController *threadVC = [[ThreadViewController alloc]init];
    threadVC.flag = indexPath.row;
    [self.navigationController pushViewController:threadVC animated:YES];
}
@end

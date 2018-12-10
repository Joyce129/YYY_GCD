


//
//  NSOperationController.m
//  GCD
//
//  Created by YYY on 2017/12/29.
//  Copyright © 2017年 成品家（北京）网路科技有限公司. All rights reserved.
//

#import "NSOperationController.h"

#import "OperationController.h"

@interface NSOperationController ()

@end

@implementation NSOperationController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.cellTitlesArray = @[@"NSInvocationOperation创建线程", @"NSBlockOperation创建线程"];
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
    }
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = self.cellTitlesArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OperationController *operation = [[OperationController alloc]init];
    [self.navigationController pushViewController:operation animated:YES];
}


@end

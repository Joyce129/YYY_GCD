//
//  BaseViewController.h
//  GCD
//
//  Created by YYY on 2017/12/29.
//  Copyright © 2017年 成品家（北京）网路科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)NSArray *cellTitlesArray;

@property(nonatomic,strong)UITableView *homePageTable;

@end

//
//  ZTTableVC.m
//  ZTCustomeMJRefreshTest
//
//  Created by tony on 16/9/9.
//  Copyright © 2016年 ZThink. All rights reserved.
//

#import "ZTTableVC.h"
#import "ZTTableViewCell.h"
#import "ZTHeaderRefresh.h"

static NSString * const cellID = @"ZTTableViewCell";
@interface ZTTableVC ()

@end

@implementation ZTTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets =YES;
    self.tableView.mj_header = [ZTHeaderRefresh headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    
}
-(void)refreshData{

    NSLog(@"刷新数据");
    
    
    __weak typeof(self) safeSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([safeSelf.tableView.mj_header isRefreshing]) {
            [safeSelf.tableView.mj_header endRefreshing];
        }
    });

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView * view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    UILabel * label =[[UILabel alloc]initWithFrame:view.frame];
    label.text = [NSString stringWithFormat:@"这是第%ld区,我是plain样式但是没悬停哦",section];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    
    return view;
    
}


#pragma mark ---设置区头的不悬停效果 (ps: 我最近才发现的，很好用的)
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat sectionHeaderHeight = 44;
    if (scrollView.contentOffset.y <= sectionHeaderHeight&&scrollView.contentOffset.y >= 0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, - 2, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, - 2, 0);
    }

}


@end

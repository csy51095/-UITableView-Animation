//
//  ViewController.m
//  newDemo
//
//  Created by jacky on 15/12/10.
//  Copyright © 2015年 jacky. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"


#define cellID @"reuseCellIndentify"
typedef void(^cellBlock)(UITableViewCell *cell);


@interface ViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
//拖拽方向
@property (nonatomic,assign) BOOL dragUp;
//辅助判断拖拽方向，记录上一次触摸点
@property (nonatomic,assign) CGPoint touchLocal;

@property (nonatomic,strong) UISegmentedControl *segment;
//存储动画类型的block
@property (nonatomic,strong) cellBlock cellAnim;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //初始化tableview
    self.tableView = [[UITableView alloc] init];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(414);
    }];
    
    self.tableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.rowHeight = 100;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //初始化segment
    self.segment = [[UISegmentedControl alloc] initWithItems:@[@"缩放动画",@"位移动画"]];
    self.segment.selectedSegmentIndex = 1;
    [self.segment addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    [self.segment sendActionsForControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.segment];
    [self.segment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(50);
    }];
    
    
}

#pragma mark - tableView代理方法Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    UIView *blockView = [[UIView alloc] init];
    
    blockView.backgroundColor = [UIColor greenColor];
    
    [cell.contentView addSubview:blockView];
    
    [blockView mas_makeConstraints:^(MASConstraintMaker *make) {
        {
            make.edges.equalTo(cell.contentView).with.insets(UIEdgeInsetsMake(10, 10, 10, 10));
        }
    }];
    
    self.cellAnim(cell);
    
    return cell;
}

/**
 * 判断拖拽方向
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.touchLocal.x > [scrollView.panGestureRecognizer locationInView:self.view].x) {
        self.dragUp = false;
    }else if(self.touchLocal.x < [scrollView.panGestureRecognizer locationInView:self.view].x)
    {
        self.dragUp = true;
    }
    
    self.touchLocal = [scrollView.panGestureRecognizer locationInView:self.view];
    
}

#pragma mark - segment响应事件
- (void)segmentChanged:(UISegmentedControl*)seg
{
    NSLog(@"seg = %ld",seg.selectedSegmentIndex);
    
    __weak typeof(self) weakSelf = self;
    
    if (seg.selectedSegmentIndex == 0) {//缩放动画
        self.cellAnim = ^(UITableViewCell *cell){
            cell.transform = CGAffineTransformMakeScale(0.1, 0.1);
            [UIView animateWithDuration:0.25 animations:^{
                cell.transform = CGAffineTransformIdentity;
            }];
        };
    }else if (seg.selectedSegmentIndex == 1){//位移动画
        self.cellAnim = ^(UITableViewCell *cell){
            NSInteger distance = weakSelf.dragUp ? -100 : 100;
            cell.transform = CGAffineTransformTranslate(cell.transform, 0, distance);
            [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                cell.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                ;
            }];
        };
    }
    
}


@end

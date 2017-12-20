//
//  ViewController.m
//  4. 网易框架
//
//  Created by 方赫 on 2017/12/19.
//  Copyright © 2017年 方赫. All rights reserved.
//

#import "ViewController.h"
#import "TopLineViewController.h"
#import "HotViewController.h"
#import "VideoViewController.h"
#import "SocietyViewController.h"
#import "ReaderViewController.h"
#import "ScienceViewController.h"


#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define NAVIGATIONBAR_HEIGHT 64

@interface ViewController () <UIScrollViewDelegate>
@property (nonatomic, weak) UIScrollView *titleScrollView;
@property (nonatomic, weak) UIScrollView *contentScrollView;
@property (nonatomic, weak) UIButton *selectedButton;
@property (nonatomic, strong) NSMutableArray *titleButtonArray;
@end

@implementation ViewController

- (NSMutableArray *)titleButtonArray {
    if (_titleButtonArray == nil) {
        _titleButtonArray = [[NSMutableArray alloc] initWithCapacity:self.childViewControllers.count];
    }
    return _titleButtonArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1. 添加标题滚动视图
    [self setupTitleScrollView];
    
    // 2. 添加内容滚动视图
    [self setupContentScrollView];
    
    // 3. 添加所有的子控制器
    [self setupAllChildViewController];
    
    // 4. 添加标题(通过获取子控制器的标题)
    [self setupAllTitle];
    
    // 5. 导航控制器会让ScrollView会增加额外滚动距离(64)
    self.automaticallyAdjustsScrollViewInsets = NO;
}


#pragma mark - 标题滚动视图
- (void)setupTitleScrollView {
    CGFloat x = 0;
    CGFloat y = self.navigationController.navigationBarHidden ? 0 : NAVIGATIONBAR_HEIGHT;
    CGFloat w = SCREEN_WIDTH;
    CGFloat h = 44;
    UIScrollView *titleScrollView = [[UIScrollView alloc] init];
    titleScrollView.frame = CGRectMake(x, y, w, h);
    titleScrollView.backgroundColor = [UIColor whiteColor];
    titleScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:titleScrollView];
    
    _titleScrollView = titleScrollView;
}

#pragma mark - 内容滚动视图
- (void)setupContentScrollView {
    CGFloat x = 0;
    CGFloat y = CGRectGetMaxY(_titleScrollView.frame);
    CGFloat w = SCREEN_WIDTH;
    CGFloat h = SCREEN_HEIGHT - y;
    UIScrollView *contentScrollView = [[UIScrollView alloc] init];
    contentScrollView.frame = CGRectMake(x, y, w, h);
    contentScrollView.pagingEnabled = YES;
    contentScrollView.showsHorizontalScrollIndicator = NO;
    contentScrollView.bounces = NO;
    contentScrollView.delegate = self;
    [self.view addSubview:contentScrollView];
    
    _contentScrollView = contentScrollView;
}

#pragma mark - 添加子控制器
- (void)setupAllChildViewController {
    // 头条
    TopLineViewController *topLineVC = [[TopLineViewController alloc] init];
    topLineVC.title = @"头条";
//    topLineVC.view.backgroundColor = [UIColor redColor];
    [self addChildViewController:topLineVC];
    
    // 热点
    HotViewController *hotVC = [[HotViewController alloc] init];
//    hotVC.view.backgroundColor = [UIColor orangeColor];
    hotVC.title = @"热点";
    [self addChildViewController:hotVC];
    
    // 视频
    VideoViewController *videoVC = [[VideoViewController alloc] init];
//    videoVC.view.backgroundColor = [UIColor magentaColor];
    videoVC.title = @"视频";
    [self addChildViewController:videoVC];
    
    // 社会
    SocietyViewController *societyVC = [[SocietyViewController alloc] init];
//    societyVC.view.backgroundColor = [UIColor purpleColor];
    societyVC.title = @"社会";
    [self addChildViewController:societyVC];
    
    // 订阅
    ReaderViewController *readerVC = [[ReaderViewController alloc] init];
//    readerVC.view.backgroundColor = [UIColor cyanColor];
    readerVC.title = @"订阅";
    [self addChildViewController:readerVC];
    
    // 科技
    ScienceViewController *scienceVC = [[ScienceViewController alloc] init];
//    scienceVC.view.backgroundColor = [UIColor brownColor];
    scienceVC.title = @"科技";
    [self addChildViewController:scienceVC];
}

#pragma mark - 设置标题
- (void)setupAllTitle {
    NSUInteger count = self.childViewControllers.count;
    
    // 设置按钮
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    CGFloat btnW = 100;
    CGFloat btnH = _titleScrollView.bounds.size.height;
    for (int i = 0; i < count; i++) {
        btnX = i * btnW;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(btnX, btnY, btnW, btnH);
        [_titleScrollView addSubview:button];
        
        // 设置内容
        UIViewController *vc = self.childViewControllers[i];
        [button setTitle:vc.title forState:UIControlStateNormal];
        
        // 设置颜色
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        
        // 设置按钮点击
        [button addTarget:self action:@selector(titleClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        // 设置角标
        button.tag = i;
        
        // 默认选中第0个标题
        if (i == 0) {
            [self titleClicked:button];
        }
        
        // 保存按钮到数组
        [self.titleButtonArray addObject:button];
    }
    
    // 设置滚动范围
    _titleScrollView.contentSize = CGSizeMake(btnW * count, 0);
    _contentScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * count, 0);
}

#pragma mark - 标题按钮点击
- (void)titleClicked:(UIButton *)button {
    // 1. 标题变红
    [self selectedTtitle:button];
    
    // 2. 添加对应的子控制器的View
    NSInteger i = button.tag;
    CGFloat x = i * SCREEN_WIDTH;
    [self setupOneChildViewCotnroller:i];
    
    // 4. 偏移scrollView
    [UIView animateWithDuration:0.5 animations:^{
        _contentScrollView.contentOffset = CGPointMake(x, 0);
    }];
}

// 选中标题按钮
- (void) selectedTtitle:(UIButton *)button {
    [_selectedButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    // 设置标题居中
    [self setupTitleCenter:button];
    
    // 标题放大
    _selectedButton.transform = CGAffineTransformMakeScale(1.0, 1.0);
    button.transform = CGAffineTransformMakeScale(1.2, 1.2);
    
    _selectedButton = button;
}

// 设置标题居中: 修改ScrollView的contentOffset
- (void)setupTitleCenter:(UIButton *)titleButton {
    // 设置偏移量, 不能低于0, 不能超过
    CGFloat offsetX = titleButton.center.x - SCREEN_WIDTH * 0.5;
    // 处理最小偏移量
    if (offsetX < 0) {
        offsetX = 0;
    }
    // 处理最大偏移量
    if (offsetX > _titleScrollView.contentSize.width - SCREEN_WIDTH) {
        offsetX = _titleScrollView.contentSize.width - SCREEN_WIDTH;
    }
    
    [_titleScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

// 选中子控制器
- (void)setupOneChildViewCotnroller:(NSInteger)i {
    UIViewController *vc = self.childViewControllers[i];
    
    // 计算子控制器view的尺寸
    if (vc.view.superview == nil) {
        CGFloat x = i * SCREEN_WIDTH;
        vc.view.frame = CGRectMake(x, 0, _contentScrollView.bounds.size.width, _contentScrollView.bounds.size.height);
        [_contentScrollView addSubview:vc.view];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 1. 获取索引
    NSInteger i = scrollView.contentOffset.x / SCREEN_WIDTH;
    
    // 2. 获取按钮
    UIButton *button = _titleButtonArray[i];
    // 2.2 执行按钮点击方法
    [self titleClicked:button];
    
    // 3. 切换子控制器
    [self setupOneChildViewCotnroller:i];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 1. 获取按钮(左右)
    NSInteger left = scrollView.contentOffset.x / SCREEN_WIDTH;
    NSInteger right = left + 1;
    
    UIButton *leftButton = self.titleButtonArray[left];
    UIButton *rightButton = nil;
    if (right < self.titleButtonArray.count) {
        rightButton = self.titleButtonArray[right];
    }
    
    // 2. 计算偏移量比例(0~1)
    CGFloat scaleR = scrollView.contentOffset.x / SCREEN_WIDTH;  // 只要小数点
    scaleR -= left;
    
    CGFloat scaleL = 1 - scaleR;
    
    // 3. 设置缩放(0~1 -> 1.2)
    leftButton.transform = CGAffineTransformMakeScale(scaleL * 0.2 + 1, scaleL * 0.2 + 1);
    rightButton.transform = CGAffineTransformMakeScale(scaleR * 0.2 + 1, scaleR * 0.2 + 1);

    // 4. 字体颜色渐变
    [leftButton setTitleColor:[UIColor colorWithRed:scaleL green:0 blue:0 alpha:1] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithRed:scaleR green:0 blue:0 alpha:1] forState:UIControlStateNormal];
    
    NSLog(@"%f, %f", scaleL, scaleR);
}


@end

//
//  ZTHeaderRefresh.m
//  ZTCustomeMJRefreshTest
//
//  Created by tony on 16/9/9.
//  Copyright © 2016年 ZThink. All rights reserved.
//

#import "ZTHeaderRefresh.h"
#import "UIColor+HexColor.h"


#define kBackViewColor          @"#ffffff"  //白色、背景颜色
#define kHeaderFreshViewWH  80
#define kImageViewWH        50
#define kLabelH             20
#define kOffsetH            60
#define kLabelColor         [UIColor colorWithRed:196/255.0 green:196/255.0 blue:196/255.0 alpha:1.0]

@interface ZTHeaderRefresh()
@property (weak, nonatomic) UIView *headerFreshView;
@property (weak, nonatomic) UILabel *label;
@property (weak, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) NSMutableArray *images;
@property (nonatomic, assign) CGFloat lastOffsetY;
@end

@implementation ZTHeaderRefresh

#pragma mark - Getter
- (NSMutableArray *)images
{
    if (!_images) {
        NSMutableArray *images = [NSMutableArray array];
        for (int index = 0; index < 26; index++)
        {
            NSString *imageN = [NSString stringWithFormat:@"fresh_%d", index+1];
            NSString *path = [[NSBundle mainBundle] pathForResource:imageN ofType:@"png"];
            
            UIImage *image = [UIImage imageWithContentsOfFile:path];
            [images addObject:image];
        }
        _images = images;
    }
    return _images;
}

#pragma mark - 初始化子控件
- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 120;
    
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithHex:kBackViewColor];
    [self addSubview:view];
    self.headerFreshView = view;
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = kLabelColor;
    label.font = [UIFont boldSystemFontOfSize:10];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    [self.headerFreshView addSubview:label];
    self.label = label;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"fresh_1"];
    imageView.animationImages = self.images;
    imageView.animationDuration = 26 * 0.0385;
    imageView.animationRepeatCount = MAXFLOAT;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.headerFreshView addSubview:imageView];
    self.imageView = imageView;
}

#pragma mark - 设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
    self.headerFreshView.bounds = CGRectMake(0, -40, self.mj_w, self.mj_h);
    self.headerFreshView.center = CGPointMake(self.mj_w * 0.5, self.mj_h * 0.5);
    
    CGFloat imageViewX = self.headerFreshView.mj_w * 0.5 - kImageViewWH * 0.5;
    self.imageView.frame = CGRectMake(imageViewX, 5, kImageViewWH, kImageViewWH);
    
    CGFloat labelX = self.headerFreshView.mj_w * 0.5 - kHeaderFreshViewWH * 0.5;
    self.label.frame = CGRectMake(labelX, kImageViewWH, kHeaderFreshViewWH, kLabelH);
    
    self.lastOffsetY = -kOffsetH;
}

#pragma mark - 监听scrollView的方法
/** contentOffset改变 */
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
    CGFloat alpha = [self alphaOrScaleValue:change];
    
    self.imageView.alpha = alpha;
    [self freshImgScaleAnimation:alpha];
}

/** contentSize改变 */
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
}

/** 拖拽状态改变 */
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
}

#pragma mark - 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
        {
            self.label.text = @"下拉刷新";
            [self endAnimation];
        }
            break;
        case MJRefreshStatePulling:
        {
            self.label.text = @"松开加载更多";
            [self endAnimation];
        }
            break;
        case MJRefreshStateRefreshing:
        {
            self.label.text = @"加载中...";
            [self startAnimation];
        }
            break;
        default:
            break;
    }
}

#pragma mark - Private Method
/** 根据拖拽下的偏移计算出透明与缩放比例 */
- (CGFloat)alphaOrScaleValue:(NSDictionary *)change
{
    CGRect offset = [[change objectForKey:@"new"] CGRectValue];
    
    CGFloat offsetY = offset.origin.y;
    
    CGFloat delta = offsetY - _lastOffsetY;
    
    CGFloat alpha = - (delta / kOffsetH);
    
    if (alpha >= 1) {
        alpha = 0.99;
    }
    return alpha;
}

/** 缩放 */
- (void)freshImgScaleAnimation:(CGFloat)alpha
{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 1.0;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(alpha, alpha, alpha)]];
    animation.values = values;
    
    [self.imageView.layer addAnimation:animation forKey:nil];
}

/** 开启图片动画 */
- (void)startAnimation
{
    [self.imageView startAnimating];
}

/** 停止图片动画 */
- (void)endAnimation
{
    [self.imageView stopAnimating];
    [self.imageView.layer removeAllAnimations];
}


@end

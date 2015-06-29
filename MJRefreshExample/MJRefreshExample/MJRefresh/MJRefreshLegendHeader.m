//  代码地址: https://github.com/CoderMJLee/MJRefresh
//  代码地址: http://code4app.com/ios/%E5%BF%AB%E9%80%9F%E9%9B%86%E6%88%90%E4%B8%8B%E6%8B%89%E4%B8%8A%E6%8B%89%E5%88%B7%E6%96%B0/52326ce26803fabc46000000
//  MJRefreshLegendHeader.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/3/4.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "MJRefreshLegendHeader.h"
#import "MJRefreshConst.h"
#import "UIView+MJExtension.h"
#import "MJLDMCircleView.h"
#import "SVIndefiniteAnimatedView.h"
#import "MJRefreshConst.h"

@interface MJRefreshLegendHeader()
@property (nonatomic, weak) UIImageView *arrowImage;
@property (nonatomic, strong) SVIndefiniteAnimatedView *activityView;
@property (nonatomic, strong) CALayer *imageLayer;
@property (nonatomic) CGFloat progress;

@property (nonatomic, strong) MJLDMCircleView *circleView;
@end

@implementation MJRefreshLegendHeader

#pragma mark - lazy load
- (UIImageView *)arrowImage
{
    if (!_arrowImage) {
        UIImageView *arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pull_refresh_arrow"]];
        [self addSubview:_arrowImage = arrowImage];
    }
    self.imageLayer = _arrowImage.layer;
    self.imageLayer.hidden = NO;
    self.imageLayer.transform = CATransform3DMakeRotation(DEGREES_TO_RADIANS(0),0,0,1);
    return _arrowImage;
}

- (MJLDMCircleView *)circleView {
    if (!_circleView) {
        _circleView = [[MJLDMCircleView alloc] initWithFrame:CGRectZero];
        _circleView.clearsContextBeforeDrawing = YES;
        self.circleView.alpha = 1.0;
        [self addSubview:_circleView];
    }
    return _circleView;
}

- (SVIndefiniteAnimatedView *)activityView {
    if (!_activityView) {
        _activityView = [[SVIndefiniteAnimatedView alloc] initWithFrame:CGRectZero];
        _activityView.strokeThickness = 1.0f;
        _activityView.strokeColor = [UIColor colorWithRed:0x66/255.0 green:0x66/255.0 blue:0x66/255.0 alpha:1];
        _activityView.radius = 10.0f;
        _activityView.center = self.center;
        _activityView.alpha = 0.0;
        [_activityView sizeToFit];
        [self addSubview:_activityView];
        [self bringSubviewToFront:_activityView];
    }
    return _activityView;
}

#pragma mark - 初始化
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 箭头
    CGFloat arrowX = (self.stateHidden && self.updatedTimeHidden) ? self.mj_w * 0.5 : (self.mj_w * 0.5 - 100);
    self.arrowImage.center = CGPointMake(arrowX, self.mj_h * 0.5);
    self.circleView.bounds = CGRectMake(0, 0, 30, 30);
    self.circleView.center = self.arrowImage.center;
    
    // 指示器
    self.activityView.bounds = CGRectMake(0, 0, 30, 30);
    self.activityView.center = self.arrowImage.center;
    
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    
    static CGFloat prevProgress;
    
    if(progress > 1.0) {
        progress = 1.0;
    }
    
    if (progress >= 0 && progress <=1.0) {
        CABasicAnimation *animationImage = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        animationImage.fromValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(360*prevProgress)];
        animationImage.toValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(360*progress)];
        animationImage.duration = 0.15;
        animationImage.removedOnCompletion = NO;
        animationImage.fillMode = kCAFillModeForwards;
        [self.imageLayer addAnimation:animationImage forKey:@"arrow_rotation"];
        
        [self.circleView setProgress:progress];
        [self.circleView setNeedsDisplay];
    }
    prevProgress = progress;
}

- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    [self setProgress:pullingPercent];
}
#pragma mark - 公共方法
#pragma mark 设置状态
- (void)setState:(MJRefreshHeaderState)state
{
    if (self.state == state) return;
    
    // 旧状态
    MJRefreshHeaderState oldState = self.state;
    
    switch (state) {
        case MJRefreshHeaderStateIdle: {
            if (oldState == MJRefreshHeaderStateRefreshing) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJRefreshSlowAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.pullingPercent = 0.0;
                    self.arrowImage.alpha = 1.0;
                    self.activityView.alpha = 0.0;
                    self.circleView.alpha = 1.0;
                });
            } else {
                self.pullingPercent = self.pullingPercent;
            }
           
            break;
        }
            
        case MJRefreshHeaderStatePulling: {
            self.circleView.alpha = 1.0;
            self.activityView.alpha = 0.0;
            break;
        }
            
        case MJRefreshHeaderStateRefreshing: {
            self.activityView.alpha = 1.0;
            self.arrowImage.alpha = 0.0;
            self.circleView.alpha = 0.0;
            break;
        }
            
        default:
            break;
    }
    
    // super里面有回调，应该在最后面调用
    [super setState:state];
}

@end



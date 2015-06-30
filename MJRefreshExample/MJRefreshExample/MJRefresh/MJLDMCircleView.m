//
//  MJLDMCircleView.m
//  Pods
//
//  Created by ypchen on 6/24/15.
//
//

#import "MJLDMCircleView.h"

@implementation MJLDMCircleView

- (nonnull instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0x66/255.0 green:0x66/255.0 blue:0x66/255.0 alpha:1].CGColor);
    CGFloat startAngle = -M_PI/2;
    CGFloat step = 12*M_PI/6 * self.progress;
    CGContextAddArc(context, self.bounds.size.width/2, self.bounds.size.height/2, self.bounds.size.width/2-5, startAngle, startAngle+step, 0);
    CGContextStrokePath(context);
}
@end

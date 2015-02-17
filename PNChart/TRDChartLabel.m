//
//  TRDChartLabel.m
//  Pods
//
//  Created by Mobile on 29-07-14.
//
//

#import "TRDChartLabel.h"

@implementation TRDChartLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        _titleLabel.text = @"Hello!";
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title textColor:(UIColor *)textColor {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        
        _titleLabel.textColor = textColor;
        _radius = 2;
        _margin = 1;
        _indicatorHeight = 2;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void) setup {
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectInset(self.bounds, 1.0, 1.0)];
    _titleLabel.font = [UIFont systemFontOfSize:12];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    
    _bubbleLayer = [CAShapeLayer layer];
    _bubbleLayer.frame = self.bounds;

    [self.layer addSublayer:_bubbleLayer];
    
    [self addSubview:_titleLabel];
}


- (void) showText:(NSString *)text {
    
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.fillRule = kCAFillRuleEvenOdd;
    maskLayer.frame = _bubbleLayer.bounds;

    UIBezierPath *bgBezierPath = [self bgBezierPath:self.bounds];

    maskLayer.path = bgBezierPath.CGPath;
    _bubbleLayer.mask = maskLayer;
    
    CGFloat height = (CGRectGetHeight(bgBezierPath.bounds) - _radius);
    
    CGRect frame = _titleLabel.frame;
    frame.size.height = height;
    frame.origin.y = _margin;
    _titleLabel.frame = frame;

    UIColor *bgColor = _labelColor ? _labelColor : [UIColor colorWithRed:246.0 / 255.0 green:246.0 / 255.0 blue:246.0 / 255.0 alpha:1.0f];
    
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    lineLayer.lineWidth = CGRectGetWidth(_bubbleLayer.bounds);
    lineLayer.strokeColor = bgColor.CGColor;
    lineLayer.strokeStart = 0.0f;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(CGRectGetWidth(_bubbleLayer.bounds)/2, CGRectGetHeight(_bubbleLayer.bounds))];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(_bubbleLayer.bounds)/2, 0)];
    [path closePath];
    
    lineLayer.path = path.CGPath;
    [_bubbleLayer addSublayer:lineLayer];
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 1.0;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = @0.0f;
    pathAnimation.toValue = @1.0f;
    
    [lineLayer addAnimation:pathAnimation forKey:@"StrokeEndAnimation"];
    lineLayer.strokeEnd = 1.0f;

    _titleLabel.text = text;
}

- (UIBezierPath *)bgBezierPath:(CGRect)rect {
    
    //// Bezier Drawing
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    
    [bezierPath moveToPoint:CGPointMake(CGRectGetMidX(rect), CGRectGetHeight(rect)-_margin)];
    
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMidX(rect)-_indicatorHeight*sqrtf(3.0), CGRectGetHeight(rect)-_margin - _indicatorHeight)];
    [bezierPath addLineToPoint: CGPointMake(_margin + _radius, CGRectGetHeight(rect) - _margin - _indicatorHeight)];
    [bezierPath addArcWithCenter:CGPointMake(_margin+_radius, CGRectGetHeight(rect) -_margin - _radius - _indicatorHeight) radius:_radius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    [bezierPath addLineToPoint: CGPointMake(_margin, _margin + _radius)];
    [bezierPath addArcWithCenter:CGPointMake(_margin + _radius, _margin + _radius) radius:_radius startAngle:M_PI endAngle:3*M_PI_2 clockwise:YES];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetWidth(rect) - _margin - _radius, _margin)];
    [bezierPath addArcWithCenter:CGPointMake(CGRectGetWidth(rect) - _margin - _radius, _margin + _radius) radius:_radius startAngle:3*M_PI_2 endAngle:0 clockwise:YES];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetWidth(rect) - _margin, CGRectGetHeight(rect) - _margin - _radius - _indicatorHeight)];
    [bezierPath addArcWithCenter:CGPointMake(CGRectGetWidth(rect) - _margin - _radius, CGRectGetHeight(rect) - _margin - _radius - _indicatorHeight) radius:_radius startAngle:0 endAngle:M_PI_2 clockwise:YES];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMidX(rect)+ (_indicatorHeight*sqrtf(3.0)), CGRectGetHeight(rect)- _margin - _indicatorHeight)];

    [bezierPath closePath];
    
    return bezierPath;
}

@end

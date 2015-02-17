//
//  PNBarChart.m
//  PNChartDemo
//
//  Created by kevin on 11/7/13.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//

#import "TRDBarChart.h"
#import "PNColor.h"
#import "PNChartLabel.h"
#import "TRDBar.h"

#import "TRDChartLabel.h"

@interface TRDBarChart () {
    NSMutableArray *_bars;
    NSMutableArray *_labels;
    
    NSMutableArray *_alternativeLabels;
}

- (UIColor *)barColorAtIndex:(NSUInteger)index;

@end

@implementation TRDBarChart

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds   = YES;
        _showLabel           = YES;
        _barBackgroundColor  = PNLightGrey;
        _labelTextColor      = [UIColor grayColor];
        _labelFont           = [UIFont systemFontOfSize:11.0f];
        _labels              = [NSMutableArray array];
        _bars                = [NSMutableArray array];
        _xLabelSkip          = 1;
        _yLabelSum           = 4;
        _labelMarginTop      = 0;
        _chartMargin         = 15.0;
        _barRadius           = 2.0;
        _showChartBorder     = NO;
        _yChartLabelWidth    = 18;
        
        _alternativeXLabels  = [NSMutableArray array];
    }

    return self;
}


- (void)setYValues:(NSArray *)yValues
{
    _yValues = yValues;
    
    if (_yMaxValue) {
        _yValueMax = _yMaxValue;
    }else{
        [self getYValueMax:yValues];
    }
    

    _xLabelWidth = (self.frame.size.width - _chartMargin * 2) / [_yValues count];
}

- (void)getYValueMax:(NSArray *)yLabels
{
    NSInteger max = 0;
    
    for (NSString *valueString in yLabels) {
        NSInteger value = [valueString integerValue];
        
        if (value > max) {
            max = value;
        }
    }
    
    //Min value for Y label
    if (max < 5) {
        max = 5;
    }
    
    _yValueMax = (int)max;
}


- (void)setYLabels:(NSArray *)yLabels
{
    
}


- (void)setXLabels:(NSArray *)xLabels
{
    _xLabels = xLabels;

    if (_showLabel) {
        _xLabelWidth = (self.frame.size.width - _chartMargin * 2) / [xLabels count];
    }
}


- (void)setStrokeColor:(UIColor *)strokeColor
{
    _strokeColor = strokeColor;
}


- (void)strokeChart
{
    [self viewCleanupForCollection:_labels];
    [self viewCleanupForCollection:_alternativeLabels];
    
    //Add Labels
    if (_showLabel) {
        //Add x labels
        int labelAddCount = 0;
        for (int index = 0; index < _xLabels.count; index++) {
            labelAddCount += 1;
            
            if (labelAddCount == _xLabelSkip) {
                NSString *labelText = _xLabels[index];
                PNChartLabel * label = [[PNChartLabel alloc] initWithFrame:CGRectZero];
                label.font = _labelFont;
                label.textColor = _labelTextColor;
                [label setTextAlignment:NSTextAlignmentCenter];
                label.text = labelText;
                [label sizeToFit];
                CGFloat labelXPosition  = (index *  _xLabelWidth + _chartMargin + _xLabelWidth /2.0 );
                
                label.center = CGPointMake(labelXPosition, self.frame.size.height - _chartMargin*1.35 + label.frame.size.height /2.0 + _labelMarginTop);
                labelAddCount = 0;
                
                [_labels addObject:label];
                [self addSubview:label];
            }
        }
        
        //Add y labels
        if (_showYLabels) {
            float yLabelSectionHeight = (self.frame.size.height - _chartMargin * 2 - xLabelHeight) / _yLabelSum;
            
            for (NSInteger index = 0; index < _yLabelSum; index++) {
                
                //            NSString *labelText = _yLabelFormatter((CGFloat)_yValueMax * ( (_yLabelSum - index) / (CGFloat)_yLabelSum ));
                NSString *labelText = [NSString stringWithFormat:@"%f", ((CGFloat)_yValueMax * ( (_yLabelSum - index) / (CGFloat)_yLabelSum ))];
                
                PNChartLabel * label = [[PNChartLabel alloc] initWithFrame:CGRectMake(0,
                                                                                      yLabelSectionHeight * index + _chartMargin - yLabelHeight/2.0,
                                                                                      _yChartLabelWidth,
                                                                                      yLabelHeight)];
                label.font = _labelFont;
                label.textColor = _labelTextColor;
                [label setTextAlignment:NSTextAlignmentRight];
                label.text = labelText;
                
                [_labels addObject:label];
                [self addSubview:label];
                
            }
            
        }
    }
    
    
    [self viewCleanupForCollection:_bars];
    
    
    //Add bars
    CGFloat chartCavanHeight = self.frame.size.height - _chartMargin * 4 - xLabelHeight - (_showLabel ? 15 : 0);
    NSInteger index = 0;
    
    for (NSString *valueString in _yValues) {
        float value = [valueString floatValue];
        
        float grade = (float)value / (float)_yValueMax;
        TRDBar *bar;
        CGFloat barWidth;
        CGFloat barXPosition;
        
        if (_barWidth) {
            barWidth = _barWidth;
            barXPosition = index *  _xLabelWidth + _chartMargin + _xLabelWidth /2.0 - _barWidth /2.0;
        }else{
            barXPosition = index *  _xLabelWidth + _chartMargin + _xLabelWidth * 0.25;
            if (_showLabel) {
                barWidth = _xLabelWidth * 0.5;
                
            }
            else {
                barWidth = _xLabelWidth * 0.6;
                
            }
        }
        
        bar = [[TRDBar alloc] initWithFrame:CGRectMake(barXPosition, //Bar X position
                                                      self.frame.size.height - chartCavanHeight - xLabelHeight - _chartMargin, //Bar Y position
                                                      barWidth, // Bar witdh
                                                      chartCavanHeight)]; //Bar height
        
        //Change Bar Radius
        bar.barRadius = _barRadius;
        
        //Change Bar Background color
        bar.backgroundColor = _barBackgroundColor;
        
        //Bar StrokColor First
        if (self.strokeColor) {
            bar.barColor = self.strokeColor;
        }else{
            bar.barColor = [self barColorAtIndex:index];
        }
        
        
        //
        __block CGRect barFrame = bar.frame;
        bar.completionBlock = ^(){
            if (_showLabel) { // Alternative Labels
                NSString *labelText = _alternativeXLabels[index];
                
                UIColor *backgroundColor = _alternativeBackgroundColor ? _alternativeBackgroundColor : PNGrey;
                
                CGFloat height = 40;
                CGFloat width = 60;
                CGFloat margin = 5;
                CGFloat yLabelPosition = CGRectGetMinY(barFrame) + (1-grade)*chartCavanHeight - height - margin;
                CGFloat xLabelPosition = (barXPosition + barWidth/2) - width/2;
                
                
                TRDChartLabel * label = [[TRDChartLabel alloc] initWithFrame:CGRectMake(xLabelPosition, yLabelPosition, width, height) title:labelText textColor:[UIColor whiteColor]];
                label.labelColor = backgroundColor;
                //            label.titleLabel.text = labelText;
                label.radius = 4;
                label.indicatorHeight = 4;
                
                [label showText:labelText];
                
                [_alternativeLabels addObject:label];
                [self addSubview:label];
                
            }
        };
        
        
        
        //Height Of Bar
        bar.grade = grade;
        
        //For Click Index
        bar.tag = index;
        
        [_bars addObject:bar];
        [self addSubview:bar];
        
        
        index++;
    }
    
    //Add chart border lines
    
    if (_showChartBorder) {
        
        UIColor *borderColor = _chartBorderColor ? _chartBorderColor : PNLightGrey;
        CGFloat borderLineWidth = _borderLineWidth > 0 ? _borderLineWidth : 1.0;
        
        _chartBottomLine = [CAShapeLayer layer];
        _chartBottomLine.lineCap      = kCALineCapSquare;
        _chartBottomLine.fillColor    = [[UIColor whiteColor] CGColor];
        _chartBottomLine.lineWidth    = borderLineWidth;
        _chartBottomLine.strokeEnd    = 0.0;
        
        
        UIBezierPath *progressline = [UIBezierPath bezierPath];
        
        //        [progressline moveToPoint:CGPointMake(_chartMargin, self.frame.size.height - xLabelHeight - _chartMargin)];
        [progressline moveToPoint:CGPointMake(_chartMargin, self.frame.size.height - _chartMargin*1.5)];
        
        //        [progressline addLineToPoint:CGPointMake(self.frame.size.width - _chartMargin,  self.frame.size.height - xLabelHeight - _chartMargin)];
        [progressline addLineToPoint:CGPointMake(self.frame.size.width - _chartMargin,  self.frame.size.height - _chartMargin*1.5)];
        
        [progressline setLineWidth:borderLineWidth];
        [progressline setLineCapStyle:kCGLineCapSquare];
        _chartBottomLine.path = progressline.CGPath;
        
        
        _chartBottomLine.strokeColor = borderColor.CGColor;
        
        
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = 0.5;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.fromValue = @0.0f;
        pathAnimation.toValue = @1.0f;
        [_chartBottomLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
        
        _chartBottomLine.strokeEnd = 1.0;
        
        [self.layer addSublayer:_chartBottomLine];
        
        //Add left Chart Line
        
        _chartLeftLine = [CAShapeLayer layer];
        _chartLeftLine.lineCap      = kCALineCapSquare;
        _chartLeftLine.fillColor    = [[UIColor whiteColor] CGColor];
        _chartLeftLine.lineWidth    = borderLineWidth;
        _chartLeftLine.strokeEnd    = 0.0;
        
        UIBezierPath *progressLeftline = [UIBezierPath bezierPath];
        
        //        [progressLeftline moveToPoint:CGPointMake(_chartMargin, self.frame.size.height - xLabelHeight - _chartMargin)];
        //        [progressLeftline addLineToPoint:CGPointMake(_chartMargin,  _chartMargin)];
        
        [progressLeftline moveToPoint:CGPointMake(_chartMargin, self.frame.size.height - _chartMargin*1.5)];
        [progressLeftline addLineToPoint:CGPointMake(_chartMargin,  _chartMargin)];
        
        [progressLeftline setLineWidth:borderLineWidth];
        [progressLeftline setLineCapStyle:kCGLineCapSquare];
        _chartLeftLine.path = progressLeftline.CGPath;
        
        
        _chartLeftLine.strokeColor = borderColor.CGColor;
        
        
        CABasicAnimation *pathLeftAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathLeftAnimation.duration = 0.5;
        pathLeftAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathLeftAnimation.fromValue = @0.0f;
        pathLeftAnimation.toValue = @1.0f;
        [_chartLeftLine addAnimation:pathLeftAnimation forKey:@"strokeEndAnimation"];
        
        _chartLeftLine.strokeEnd = 1.0;
        
        [self.layer addSublayer:_chartLeftLine];
    }
}


- (void)viewCleanupForCollection:(NSMutableArray *)array
{
    if (array.count) {
        [array makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [array removeAllObjects];
    }
}


#pragma mark - Class extension methods

- (UIColor *)barColorAtIndex:(NSUInteger)index
{
    if ([self.strokeColors count] == [self.yValues count]) {
        return self.strokeColors[index];
    }
    else {
        return self.strokeColor;
    }
}


#pragma mark - Touch detection

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchPoint:touches withEvent:event];
    [super touchesBegan:touches withEvent:event];
}


- (void)touchPoint:(NSSet *)touches withEvent:(UIEvent *)event
{
    //Get the point user touched
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    UIView *subview = [self hitTest:touchPoint withEvent:nil];
    
    if ([subview isKindOfClass:[TRDBar class]] && [self.delegate respondsToSelector:@selector(userClickedOnBarCharIndex:)]) {
        [self.delegate userClickedOnBarCharIndex:subview.tag];
    }
}


@end

//
//  TRDChartLabel.h
//  Pods
//
//  Created by Mobile on 29-07-14.
//
//

#import <UIKit/UIKit.h>

@interface TRDChartLabel : UIView

@property (nonatomic, strong) CAShapeLayer *bubbleLayer;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic) CGFloat radius;
@property (nonatomic) CGFloat margin;
@property (nonatomic) CGFloat indicatorHeight;
@property (nonatomic, strong) UIColor *labelColor;

- (instancetype) initWithFrame:(CGRect)frame title:(NSString *)title textColor:(UIColor *)textColor;
- (void) showText:(NSString *)text;
@end

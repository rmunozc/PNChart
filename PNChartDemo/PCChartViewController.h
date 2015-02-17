//
//  PCChartViewController.h
//  PNChartDemo
//
//  Created by kevin on 11/7/13.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNChartDelegate.h"
#import "PNChart.h"
#import "TRDChartLabel.h"
#import "TRDBarChart.h"

@interface PCChartViewController : UIViewController<PNChartDelegate, TRDChartDelegate>

@property (nonatomic) PNLineChart * lineChart;
@property (nonatomic) PNBarChart * barChart;
@property (nonatomic) PNCircleChart * circleChart;
@property (nonatomic) PNPieChart *pieChart;
@property (nonatomic) PNScatterChart *scatterChart;
@property (nonatomic) TRDChartLabel *trdChart;
@property (nonatomic) TRDBarChart *trdBarChart;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (IBAction)changeValue:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *changeValueButton;

@end

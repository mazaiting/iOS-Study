//
//  MTProcessView.m
//  02Downloader断点续传
//
//  Created by mazaiting on 18/1/8.
//  Copyright © 2018年 mazaiting. All rights reserved.
//

#import "MTProcessView.h"

@implementation MTProcessView

// 设置进度
- (void)setProcess:(float)process {
    _process = process;
    // 设置文字
    [self setTitle:[NSString stringWithFormat:@"%0.2f%%", process * 100] forState:UIControlStateNormal];
    // 重绘
    [self setNeedsDisplay];
}

// 使用贝塞尔曲线画圆
- (void)drawRect:(CGRect)rect {
    // 创建一个贝塞尔曲线
    UIBezierPath *path = [UIBezierPath bezierPath];
    // 圆心
    CGPoint center = CGPointMake(rect.size.width / 2, rect.size.height / 2);
    // 圆半径
    CGFloat radius = MIN(center.x, center.y) - 5;
    // 开始弧度
    CGFloat startAngle = - M_PI_2;
    // 结束弧度
    CGFloat endAngle = 2 * M_PI * self.process + startAngle;
    
    // 化弧
    [path addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    
    // 设置线宽
    path.lineWidth = 5;
    // 设置笔的风格--圆形
    path.lineCapStyle = kCGLineCapRound;
    // 设置线的颜色
    [[UIColor orangeColor] setStroke];
    // 绘画
    [path stroke];
}

@end

//
//  AlphaHiddenOpaque.m
//  CCPOCStudy
//
//  Created by Ceair on 2017/11/17.
//  Copyright © 2017年 Ceair. All rights reserved.
//

#import "AlphaHiddenOpaque.h"

@implementation AlphaHiddenOpaque

/*
 * alpha 浮点值 取值范围0-1.0 表示从完全透明到完全不透明
   * 当alpha=0时，当前UIView和subview都会被隐藏，当前UIView会从响应者链中移除，而响应者链中的下一个会成为第一响应者。
 * hidden BOOL值 表示UIView是否隐藏 默认NO
   * 当hidden=YES时，当前UIView和subview都会被隐藏，当前UIView会从响应者链中移除，而响应者链中的下一个会成为第一响应者。
 * opaque BOOL值，UIView默认YES，UIButton等子类默认NO。表示当前UIView是否不透明。
   *主要用于提升绘图系统的性能优化，具体参考下面实例
 */



/*
 * 以下方法创建了三个相交UIView
 * 对于相交部分，GPU会通过相交图层的颜色进行图层混合，计算出混合部分的颜色，理想情况下的计算公式：
 * R = S + D * (1 - Sa)
 * R=混合后的颜色，S=上层视图颜色,D=下层视图颜色，Sa=上层视图颜色的alpha值
 * 当opaque=YES,alpha=1时，R=S；
 * 当alpha!=1.0,请将opaque=NO,否则会出现无法预料的效果 
 */
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        CGFloat w = CGRectGetWidth(frame)/2;
        CGFloat h = CGRectGetHeight(frame)/2;
        UIView *leftV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w,h+10)];
        leftV.backgroundColor = [UIColor redColor];
        UIView *rightV = [[UIView alloc] initWithFrame:CGRectMake(w, 0, w, h+10)];
        rightV.backgroundColor = [UIColor greenColor];
        rightV.opaque = NO;
        UIView *bottomV = [[UIView alloc] initWithFrame:CGRectMake(0, h-10, w*2, h+10)];
        bottomV.backgroundColor = [UIColor blueColor];
        [self addSubview:bottomV];
        [self addSubview:leftV];
        [self addSubview:rightV];
    }
    return self;
}

@end

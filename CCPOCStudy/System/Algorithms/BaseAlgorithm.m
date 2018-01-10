//
//  BaseAlgorithm.m
//  CCPOCStudy
//
//  Created by chuchengpeng on 2018/1/10.
//  Copyright © 2018年 Ceair. All rights reserved.
//

#import "BaseAlgorithm.h"

@implementation BaseAlgorithm

int commonDivisor(int a, int b) {
    int temp = 0;
    if (a < b) {
        temp = a;
        a = b;
        b = temp;
    }
    while (b!=0) {
        temp = a%b;
        a = b;
        b = temp;
        NSLog(@"%s__%d__%d",__func__,a,b);  
    }
    
    return a;
}

@end

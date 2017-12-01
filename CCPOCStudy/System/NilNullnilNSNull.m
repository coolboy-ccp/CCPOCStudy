//
//  NilNullnilNSNull.m
//  CCPOCStudy
//
//  Created by Ceair on 2017/11/17.
//  Copyright © 2017年 Ceair. All rights reserved.
//

#import "NilNullnilNSNull.h"

@implementation NilNullnilNSNull


/*
 * 对于非c++开发来说nil,NULL,Nil 的本质都是（(void*）0)
 * nil 本质是 （(void*）0)
   * 表示指向oc对象的指针为空
 * NULL 本质是 ((void *) 0)
   * 表示c指针为空
 * Nil 本质是 ((void *) 0)
   * 表示oc类类型的变量值为空
 * NSNull oc类 表示空置，用于保存一个空的占位对象
 */

void example () {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
    char *cStr = NULL;
    NSString *str = nil;
    Class anyClass = Nil;
    NSArray *arr = @[[NSNull null]];
#pragma clang diagnostic pop
}

@end

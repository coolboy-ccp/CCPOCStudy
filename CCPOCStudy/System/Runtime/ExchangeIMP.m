//
//  ExchangeIMP.m
//  CCPOCStudy
//
//  Created by chuchengpeng on 2017/12/21.
//  Copyright © 2017年 Ceair. All rights reserved.
//

#import "ExchangeIMP.h"
#import <objc/runtime.h>

@implementation ExchangeIMP

/**
 交换两个方法的实现

 @param cls 交换方法的类
 @param oSel 源方法名
 @param pSel 交换方法名
 */
+ (void)exchangeImpInClass:(Class)cls orginSel:(SEL)oSel placeSel:(SEL)pSel {
    Method om = class_getInstanceMethod(cls, oSel);
    Method pm = class_getInstanceMethod(cls, pSel);
    BOOL isAddSuccess = class_addMethod(cls, oSel, method_getImplementation(pm), method_getTypeEncoding(pm));
    if (isAddSuccess) {
        class_replaceMethod(cls, pSel, method_getImplementation(om), method_getTypeEncoding(om));
    }
    else {
        method_exchangeImplementations(om, pm);
    }
}

//http://www.jianshu.com/p/2c93446d86bd
//Aspects

@end

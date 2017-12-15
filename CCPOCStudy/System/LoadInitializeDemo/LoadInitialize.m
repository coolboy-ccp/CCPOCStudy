//
//  LoadInitialize.m
//  CCPOCStudy
//
//  Created by Ceair on 2017/11/30.
//  Copyright © 2017年 Ceair. All rights reserved.
//

#import "LoadInitialize.h"


#pragma mark -- load --
/*
 * load 方法在程序运行后立即执行
 在load方法调用时,系统没有autorelease pool,在load中创建的对象都不能被自动释放
 load的执行顺序:supClass,subClass,categoryClass
 如果当前类没有写load方法,那么不会使用父类的load方法(ps,父类的load方法会调用,但那个是父类调用的)
 
 * initialize 方法在类的方法第一次被调用时执行(不包含load方法)
 initialize的执行顺序,supClass/categoryClass(如果存在分类,supClass中的initialize会被覆盖),subClass
 如果当前类没有写initialize方法,会调用父类的initialize(父类自己也会调用initialize)
 
 **相同点 相对runtime而言,两个方法只会被调用一次.但我们可以手动的重复调用这两个方法,这两个方法会在程序运行一开始就会被调用
 */

@implementation LoadInitialize

+ (void)load {
    NSLog(@"sup_load");
}

+ (void)initialize {
    NSLog(@"sup_initialize");
}

@end

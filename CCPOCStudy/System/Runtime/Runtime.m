//
//  Runtime.m
//  CCPOCStudy
//
//  Created by chuchengpeng on 2017/12/20.
//  Copyright © 2017年 Ceair. All rights reserved.
//

#import "Runtime.h"
#import <objc/runtime.h>
#import <objc/message.h>


@interface MyInvocation:NSObject
@end
@implementation MyInvocation

- (void)runtimeTest3 {
    NSLog(@"我是消息转发");
}

- (void)runtimeTest4 {
    NSLog(@"我是test4的消息转发");
}

@end

/*
 * 解决不能调用objc_msgSend(id,sel)
 * 选中progect -> build setting -> search objc -> select Enable strict checking... -> set NO
 */

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"
@implementation Runtime
#pragma clang diagnostic pop

- (void)runtimeTest1 {
    NSLog(@"%s",__func__);
}


#pragma mark -- 动态方法决议---

//实例方法决议
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if (sel == @selector(runtimeTest2)) {
        /**
         为一个类添加方法

         @param cls#> <#cls#> description#> 需要添加方法的类
         @param name#> <#name#> description#> 方法名sel
         @param imp#> <#imp#> description#> 方法实现（oc方法本质是至少含有两个参数：self，_cmd的c函数）
         @param types#> <#types#> description#> 返回值和参数类型
         *****
         * types
         * v -> return void
         * @ -> self
         * : _cmd
         ps:@表示object对象，:表示SEL，其他类型参考官方文档
         *****
         @return 是否成功添加
         */
        return class_addMethod([self class], sel, (IMP)myTest1,"v@:");
    }
    return [super resolveInstanceMethod:sel];
}

//类方法决议
+ (BOOL)resolveClassMethod:(SEL)sel {
    return [super resolveClassMethod:sel];
}

void myTest1(id self,SEL _cmd) {
    NSLog(@"我是动态决议");
}

#pragma mark -- 消息转发1 --
- (id)forwardingTargetForSelector:(SEL)aSelector {
    return [MyInvocation new];
}

#pragma mark -- 消息转发2 --
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if (aSelector == @selector(runtimeTest4)) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    return [super methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    SEL sel = anInvocation.selector;
    id mi = [MyInvocation new];
    if ([mi respondsToSelector:sel]) {
        [anInvocation invokeWithTarget:mi];
    }
}
@end

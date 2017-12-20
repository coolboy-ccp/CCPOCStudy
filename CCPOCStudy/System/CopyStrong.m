//
//  CopyStrong.m
//  CCPOCStudy
//
//  Created by chuchengpeng on 2017/12/15.
//  Copyright © 2017年 Ceair. All rights reserved.
//

#import "CopyStrong.h"


//http://blog.csdn.net/CHENYUFENG1991/article/details/51771728


#pragma mark -- 非容器对象 --
/*
 * 深拷贝是内容拷贝，浅拷贝是指针拷贝
 
 * 可变对象copy后返回的对象是不可变的，mutableCopy返回的对象是可变的
 
 * 对于可变对象的copy和mutableCopy，一般都是深拷贝
 * 对于一个不可变变量的copy，一般都是浅拷贝
 * mutableObj = [obj copy];后，mutableObj不可变，不能调用可变的相关方法
 */

/*
 * 对于自定义对象，实现了NSCopying | NSMutableCopying后，无论是copy还是mutableCopy都是深拷贝
 */
@interface myObj:NSObject <NSCopying, NSMutableCopying>
//
@property (nonatomic, strong) NSString *objName;
//
@property (nonatomic, copy) NSString *objNameC;
@end

@implementation myObj


//使用copy，会深拷贝一个对象，但对象的属性依然是浅拷贝。如果想要实现属性也是深拷贝，需要每个属性都重新分配地址
/*
 * 使用copy或mutabCopy，深拷贝一个对象
 * 对于不可变赋值的变量，copy和strong修饰没有区别, 都是指针拷贝（浅拷贝）
 * 对于可变变量
 * objNameC 使用copy，属于深拷贝
 * objName 使用strong 属于浅拷贝
 * 如果：obj.property = [value mutbleCopy];无论是strong还是copy修饰，都是深拷贝
 
 */
- (instancetype)copyWithZone:(NSZone *)zone {
    myObj *obj = [[myObj allocWithZone:zone] init];
    obj.objName = self.objName;
    obj.objNameC  = self.objNameC;
    return obj;
}

//完全copy，对象，以及对象的属性都是深拷贝
- (instancetype)mutableCopyWithZone:(NSZone *)zone {
    myObj *obj = [[myObj allocWithZone:zone] init];
    obj.objNameC = [[NSString alloc] initWithString:self.objNameC];
    obj.objName = [[NSString alloc] initWithString:self.objName];
    return obj;
}


@end

#pragma mark -- 容器对象 --
/*
 * 可变对象的复制（copy,mutableCopy）都是内容拷贝（深拷贝）
 * 不可变对象的copy是指针拷贝（浅拷贝），mutableCopy是内容拷贝（深拷贝）
 * 对于容器而言，元素对象始终是指针复制
 */


@interface CopyStrong ()

@end

@implementation CopyStrong

- (void)testCopyStrong {
 
}



@end

//
//  KVC.m
//  CCPOCStudy
//
//  Created by Ceair on 2017/11/29.
//  Copyright © 2017年 Ceair. All rights reserved.
//

#import "KVC.h"

//测试数组
NSArray *kvcssss() {
    NSArray *nums = @[@"1",@"2",@"1"];
    NSMutableArray *marr = [NSMutableArray array];
    for (NSString *num in nums) {
        KVC *kvc = [KVC new];
        kvc.kvc_1 = num;
        [marr addObject:kvc];
    }
    return marr.copy;
}

#pragma mark -- NSKeyValueCoding --
/*
 * KVC Key-Value-Coding,即NSKeyValueCoding,一个非正式的Protocol,提供一种机制间接访问对象的属性.
 * 从最基础的层次来讲,KVC有两个方法:设置key的值,获取key的值
 
 ** Key-value coding is a mechanism enabled by the NSKeyValueCoding informal protocol that objects adopt to provide indirect access to their properties. When an object is key-value coding compliant, its properties are addressable via string parameters through a concise, uniform messaging interface. This indirect access mechanism supplements the direct access afforded by instance variables and their associated accessor methods.
 ** KVC是遵循了NSKeyValueCoding非正式协议的对象,提供间接访问其属性的一种机制.如果对象兼容KVC,那么,它的属性可以用字符串参,通过一个统一的接口访问.这个间接访问机制是对实例变量和他们关联的访问方法所提供的直接访问的补充.
 
 */

void demo_1() {
    KVC *kvc = [KVC new];
    [kvc setValue:@"kvc_1" forKey:@"kvc_1"];
    NSString *kvc1 = [kvc valueForKey:@"kvc_1"];
    [kvc setValue:@"kvc_2" forKeyPath:@"kvcInstance.kvc_1"];
    NSString *kvc2 = [kvc valueForKeyPath:@"kvcInstance.kvc_1"];
    NSLog(@"kvc1:%@  kvc2:%@",kvc1,kvc2);   
}


#pragma mark -- Collection operators --
/*
 * KVC的collection operators
 * keypathToCollection.@collectionOperator.keypathToProperty
 * |___Left key path__|Collection operator|__Right key path__|
 
 ** Left key path:如果有,则代表需要操作的对象的路径(相对于调用者)
 ** Collection operator:以@开头的操作符
 ** Right key path:指定被操作的属性
 */


#pragma mark -- Aggregation Operators --
/*
 * Aggregation Operators 集合操作符
 ** Aggregation operators work on either an array or set of properties, producing a single value that reflects some aspect of the collection.
 ** 集合操作符可用于array或set,返回一个表示集合某一方面的单个值
 
 * @avg:返回平均值
 * @count:返回数组里的元素个数,如果设置了Right key path,会被忽略
 * @max:返回数组中的最大值
 * @min:返回数组中的最小值
 * @sum:求和
 */
void demo_aggregation () {
    NSArray *demoArrays = @[@"1",@"2",@"2",@"777",@"3"];
    int avg = [[demoArrays valueForKeyPath:@"@avg.intValue"] intValue];
    int count = [[demoArrays valueForKeyPath:@"@count.intValue"] intValue];
    int min = [[demoArrays valueForKeyPath:@"@min.intValue"] intValue];
    int max = [[demoArrays valueForKeyPath:@"@max.intValue"] intValue];
    int sum = [[demoArrays valueForKeyPath:@"@sum.intValue"] intValue];
    NSLog(@"avg:%d, count:%d, min:%d, max:%d, sum:%d",avg,count,min,max,sum);
    
}

#pragma mark -- Arrat Operators --
/*
 * Array Operators 数组操作符
 ** The array operators cause valueForKeyPath: to return an array of objects corresponding to a particular set of the objects indicated by thr right key path.
 ** 数组操作符调用valueForKeyPath:,返回right key path 指定的对象,对应的特定的集合.
 ** IMPORTANT : The valueForKeyPath: method raises an exception if any of the leaf objects is nil when using array operators
 ** 注意:使用数组操作符时,若数组中有对象为nil,则valueForKeyPath:会抛出异常
 
 *@distinctUnionOfObjects
 ** When you specify the @distinctUnionOfObjects operator, valueForKeyPath: creates and returns an array containing the distinct objects of the collection corresponding to the property specified by the right key path.
 ** 使用distinctUnionOfObjects 根据right key path指定的属性,返回包含不同对象的数组
 * @unionOfObjects
 ** When you specify the @unionOfObjects operator, valueForKeyPath: creates and returns an array containing all the objects of the collection corresponding to property specified by the right key path. Unlike @distinctUnionOfObjects, duplicate objects are not removed.
 ** 使用 @unionOfObjects 根据right key path指定的属性,返回包含所有对象的数组,不会删除相同的元素
 */
void demo_array() {
    NSArray *arr = kvcssss();
    NSArray *distinctArray = [arr valueForKeyPath:@"@distinctUnionOfObjects.kvc_1"];
    NSArray *array = [arr valueForKeyPath:@"unionOfObjects.kvc_1"];
    NSLog(@"%s:distinctArray:%@\narray:%@",__FUNCTION__,distinctArray,array);
}


#pragma mark -- Nesting Operators --

/*
 * Nesting Operators 嵌套操作符
 ** The nesting operators operate on nested collections, where each entry of the collection itself contains a collection.
 ** 嵌套操作符对嵌套集合进行操作,其中集合的每个条目都是一个集合
 ** IMPORTANT: The valueForKeyPath: method raises an exception if any of the leaf objects is nil when using nesting operators.
 ** 注意: 当数组中有元素为空时,会崩溃
 
 * @distinctUnionOfArrays
 ** When you specify the @distinctUnionOfArrays operator, valueForKeyPath: creates and returns an array containing the distinct objects of the combination of all the collections corresponding to the property specified by the right key path.
 ** 使用 @distinctUnionOfArrays 返回一个包含right key path指定的属性,对应的所有集合的不同对象的组合数组
 * @unionOfArrays
 ** When you specify the @unionOfArrays operator, valueForKeyPath: creates and returns an array containing the all the objects of the combination of all the collections corresponding to the property specified by the right key path, without removing duplicates.
 ** 使用 @unionOfArrays 返回一个包含right key path指定的属性,对应的所有集合的组合数组,不会去重
 ps:返回的数组都是一维数组
 
 * @distinctUnionOfSets用于NSSet,因为集合中没有相同的元素,所以不存在去不去重
 */

void domo_nesting() {
    NSArray *arr1 = kvcssss();
    NSArray *arr2 = kvcssss();
    NSArray *arr = @[arr1,arr2];
    NSArray *distinctArray = [arr valueForKeyPath:@"@distinctUnionOfArrays.kvc_1"];
    NSArray *array = [arr valueForKeyPath:@"unionOfArrays.kvc_1"];
    NSLog(@"%s:distinctArray:%@\narray:%@",__FUNCTION__,distinctArray,array);
}


#pragma mark -- Non-Object Values --
/*
 * Wrapping and Unwrapping Scalar Types
 * Scalar Types 如:BOOL,char,double,float,int,long,...
 这些类型用NSNumber wrapping 如:numberWithBool:,numberWithChar:
 unwarpping时,调用boolValue,charValue
 */

/*
 * Wrapping and Unwrapping Structures
 * 系统用NSValue封装了常见的结构体封如下:
 NSPoint valueWithPoint: pointValue
 NSRange valueWithRange: rangeValue
 NSRect  valueWithRect:(macOS only) rectValue
 NSSize  valueWithSize: sizeValue
 对于自定义的结构体,如下:
 */

@implementation KVC

/*------demo for Wrapping and Unwrapping self def Structures-----*/
- (void)setTfs:(TFs)tfs {
    NSValue *value = [NSValue value:&tfs withObjCType:@encode(TFs)];
    [self setValue:value forKey:@"tfs"];
}

- (TFs)tfs {
    NSValue *value = [self valueForKey:@"tfs"];
    TFs tf;
    [value getValue:&tf];
    return tf;
}
/*------demo for Wrapping and Unwrapping self def Structures-----*/

@end

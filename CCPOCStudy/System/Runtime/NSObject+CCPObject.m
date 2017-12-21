//
//  NSObject+CCPObject.m
//  CCPOCStudy
//
//  Created by chuchengpeng on 2017/12/21.
//  Copyright © 2017年 Ceair. All rights reserved.
//

#import "NSObject+CCPObject.h"
#import <objc/runtime.h>

//快递归档 解归档
@interface myObjcet:NSObject<NSCoding>
{
    NSString *ivarTestString;
}

//
@property (nonatomic, copy) NSString *testString;

@end

@implementation myObjcet

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_testString forKey:@"testString"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    _testString = [aDecoder decodeObjectForKey:@"testString"];
    return self;
}


@end

static const void *ccpTestPropertyKey = &ccpTestPropertyKey;

@implementation NSObject (CCPObject)

- (NSString *)ccpTestProperty {
    return objc_getAssociatedObject(self, ccpTestPropertyKey);
}

- (void)setCcpTestProperty:(NSString *)ccpTestProperty {
    /*
     * 第一个参数是需要关联属性的对象
     * 第二个参数是关联的标识符
     * 第三个参数是赋值
     * 第三个参数是property的描述
     */
    objc_setAssociatedObject(self, ccpTestPropertyKey, ccpTestProperty, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

//获取当前类的所有属性的名称
- (NSArray<NSString *> *)propertyNames {
    NSMutableArray *names = [NSMutableArray array];
    //返回属性的个数
    u_int count;
    u_int count1;
    //返回属性列表
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    Ivar *invals = class_copyIvarList([self class], &count1);
    for (int i = 0; i < count1; i ++) {
        const char *cName = ivar_getName(invals[i]);
        id value = [self valueForKey:[NSString stringWithUTF8String:cName]];
        NSLog(@"ivar%d: %s---%@",i,cName,value);
    }
    for (int i = 0; i < count; i ++) {
        const char *cName = property_getName(properties[i]);
         id value = [self valueForKey:[NSString stringWithUTF8String:cName]];
        NSLog(@"property%d: %s---%@",i,cName,value);
        
        NSString *name = [NSString stringWithUTF8String:cName];
        [names addObject:name];
    }
    free(properties);
    return names;
}


/*
 NSString *const MJPropertyTypeInt = @"i";
 NSString *const MJPropertyTypeShort = @"s";
 NSString *const MJPropertyTypeFloat = @"f";
 NSString *const MJPropertyTypeDouble = @"d";
 NSString *const MJPropertyTypeLong = @"l";
 NSString *const MJPropertyTypeLongLong = @"q";
 NSString *const MJPropertyTypeChar = @"c";
 NSString *const MJPropertyTypeBOOL1 = @"c";
 NSString *const MJPropertyTypeBOOL2 = @"b";
 NSString *const MJPropertyTypePointer = @"*";
 
 NSString *const MJPropertyTypeIvar = @"^{objc_ivar=}";
 NSString *const MJPropertyTypeMethod = @"^{objc_method=}";
 NSString *const MJPropertyTypeBlock = @"@?";
 NSString *const MJPropertyTypeClass = @"#";
 NSString *const MJPropertyTypeSEL = @":";
 NSString *const MJPropertyTypeId = @"@";
 */

- (NSArray<Class> *)typeOfProperties {
    
    /*
     T@"NSString",&,N,V_name
     T@"NSDictionary",C,N,V_dic
     T@"NSArray",C,N,V_array
     -------T后面跟的是参数类型，@表示object类型，B表示bool，f表示float，其他的去官方文档看
     TB,N,V_bl
     Tf,N,V_abc
     */
    NSMutableArray *marr = [NSMutableArray new];
    u_int count;
    objc_property_t *propertys = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i ++) {
        const char *cTypeName = property_getAttributes(propertys[i]);
        NSString *typeName = [NSString stringWithUTF8String:cTypeName];
        
//        if ([typeName containsString:@"@"]) {
//            NSString *subType = [typeName componentsSeparatedByString:@"T@\""].lastObject;
//            subType = [subType componentsSeparatedByString:@"\""].firstObject;
//            [marr addObject:NSClassFromString(subType)];
//        }
        NSString *subType = [typeName componentsSeparatedByString:@"T@\""].lastObject;
        subType = [subType componentsSeparatedByString:@"\""].firstObject;
        [marr addObject:NSClassFromString(subType)];
        NSLog(@"typeName: %@  %@",typeName,NSClassFromString(subType));
    }
    return marr;
}




@end

//
//  ViewController.m
//  CCPOCStudy
//
//  Created by Ceair on 2017/11/17.
//  Copyright © 2017年 Ceair. All rights reserved.
//

#import "ViewController.h"
#import "SubLoadInitialize.h"
#import "SubLoadInitialize2.h"
#import "CopyStrong.h"
#import "Runtime.h"
#import "NSObject+CCPObject.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
#pragma mark -- 测试load和initialize
//    [SubLoadInitialize new];
//    [SubLoadInitialize2 new];
#pragma mark -- 测试copy --
//    CopyStrong *cs = [CopyStrong new];
//   // abort();
//    [cs testCopyStrong];
#pragma mark -- 测试动态方法决议和消息转发 --
//    Runtime *rt = [Runtime new];
//    [rt runtimeTest1];
//    [rt runtimeTest2];
//    [rt runtimeTest3];
//    [rt runtimeTest4];
#pragma mark -- 测试添加属性和获取属性列表 --
    _name = @"name";
    ivalName = @"ivalName";
    [self propertyNames];
//    [self typeOfProperties];
    
}


@end

//
//  CCPOCStudyTests.m
//  CCPOCStudyTests
//
//  Created by chuchengpeng on 2018/1/8.
//  Copyright © 2018年 Ceair. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Encryption_MD5.h"
#import "BaseAlgorithm.h"


@interface CCPOCStudyTests : XCTestCase

@end

@implementation CCPOCStudyTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testEncryption_md5 {
    [Encryption_MD5 normalMD5:@"123"];
}

- (void)testEncryption_md5_uppercase {
    [Encryption_MD5 uppercaseMD5:@"123"];
}

- (void)testCommonDivisor {
    commonDivisor(12, 16);
}

@end

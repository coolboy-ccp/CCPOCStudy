//
//  Encryption_MD5.h
//  CCPOCStudy
//
//  Created by chuchengpeng on 2018/1/8.
//  Copyright © 2018年 Ceair. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Encryption_MD5 : NSObject

//获取小写的MD5
+ (NSString *)normalMD5:(NSString *)oStr;
//获取大写的MD5
+ (NSString *)uppercaseMD5:(NSString *)oStr;

@end

//
//  Encryption_SHA1.m
//  CCPOCStudy
//
//  Created by chuchengpeng on 2018/1/8.
//  Copyright © 2018年 Ceair. All rights reserved.
//

#import "Encryption_SHA1.h"
#import <CommonCrypto/CommonHMAC.h>

@implementation Encryption_SHA1

/*
 安全哈希算法（Secure Hash Algorithm）主要适用于数字签名标准（Digital Signature Standard DSS）里面定义的数字签名算法（Digital Signature Algorithm DSA）。对于长度小于2^64位的消息，SHA1会产生一个160位的消息摘要。当接收到消息的时候，这个消息摘要可以用来验证数据的完整性。在传输的过程中，数据很可能会发生变化，那么这时候就会产生不同的消息摘要。
 SHA1有如下特性：不可以从消息摘要中复原信息；两个不同的消息不会产生同样的消息摘要。
 
 */

//普通加密
+ (NSString *)sha1:(NSString *)oStr {
    const char *cOStr = [oStr cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cOStr length:oStr.length];
    UInt8 digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (u_int)data.length, digest);
    NSMutableString *str = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH*2];
    for (int i = 0 ;i<CC_SHA1_DIGEST_LENGTH;i++) {
        [str appendFormat:@"%02x",digest[i]];
    }
    NSLog(@"%s__%@",__func__,str);
    return str;
}

@end

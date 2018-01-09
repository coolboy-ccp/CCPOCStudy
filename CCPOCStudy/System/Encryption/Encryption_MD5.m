//
//  Encryption_MD5.m
//  CCPOCStudy
//
//  Created by chuchengpeng on 2018/1/8.
//  Copyright © 2018年 Ceair. All rights reserved.
//

#import "Encryption_MD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation Encryption_MD5
/*
 1、压缩性：任意长度的数据，算出的MD5值长度都是固定的。
 2、容易计算：从原数据计算出MD5值很容易。
 3、抗修改性：对原数据进行任何改动，哪怕只修改1个字节，所得到的MD5值都有很大区别。
 4、弱抗碰撞：已知原数据和其MD5值，想找到一个具有相同MD5值的数据（即伪造数据）是非常困难的。
 5、强抗碰撞：想找到两个不同的数据，使它们具有相同的MD5值，是非常困难的。
 6、MD5加密是不可解密的，但是网上有一些解析MD5的，那个相当于一个大型的数据库，通过匹配MD5去找到原密码。所以，只要在要加密的字符串前面加上一些字母数字符号或者多次MD5加密，这样出来的结果一般是解析不出来的*/

/*
 * MD5-Message digest algorithm 5 消息摘要算法5
 * 具有以下特性:
 ** 1.压缩性：任意长度的数据，算出的MD5值长度都是固定的。
 ** 2.容易计算：从源数据计算出MD5很容易
 ** 3.抗修改性：对源数据进行任何改动，所得到的MD5值的区别很大
 ** 4.弱抗碰撞：已知源数据和MD5值，想找到一个具有相同MD5值得数据（即伪造数据）是非常困难的。
 ** 5.强抗碰撞：想找到两个不同数据，使他们具有相同的MD5值，是非常困难的
 ** 6.MD5加密不可逆。但通过http://www.cmd5.com可以匹配到原密码。所以，在进行MD5加密的时候需要对源数据或加密后的数据进行处理（如：加盐），以提高安全性。
 * ps:
 （1）一定要和后台开发人员约定好，MD5加密的位数是16位还是32位(大多数都是32位的)，16位的可以通过32位的转换得到。
 （2）MD5加密区分 大小写，使用时要和后台约定好
 
 * 用于对敏感信息加密（如用户名，密码），或对文件进行加密,请求参数校验（防止请求参数被拦截修改）
 */

//获取小写的MD5
+ (NSString *)normalMD5:(NSString *)oStr {
    const char *cOstr = [oStr UTF8String];
    unsigned char reslut[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cOstr, (CC_LONG)strlen(cOstr), reslut);
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x",reslut[i]];
    }
    NSLog(@"%s__%@",__func__,digest);
    return digest;
}

//获取大写的MD5
+ (NSString *)uppercaseMD5:(NSString *)oStr {
    const char *cOstr = [oStr UTF8String];
    unsigned char reslut[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cOstr, (CC_LONG)strlen(cOstr), reslut);
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02X",reslut[i]];
    }
    NSLog(@"%s__%@",__func__,digest);
    return digest;
}

@end

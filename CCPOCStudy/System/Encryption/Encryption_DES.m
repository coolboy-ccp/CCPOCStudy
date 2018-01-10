//
//  Encryption_DES.m
//  CCPOCStudy
//
//  Created by chuchengpeng on 2018/1/9.
//  Copyright © 2018年 Ceair. All rights reserved.
//

#import "Encryption_DES.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation Encryption_DES
/* Data Encryption Standard 数据加密标准
 * 对称加密 常规加密 私钥加密 单钥加密
 ** 对称加密由5部分组成
 ** 明文(plaintext):原始数据，作为算法的输入
 ** 加密算法(encryption algeorithm):加密算法对明文进行各种替换和转换
 ** 密钥(secret key):也算算法的输入。算法进行的具体替换和转换取决于密钥
 ** 密文(ciphertest):已经加密的消息输出
 ** 解密算法(decryption algorithm):加密算法的反向执行。使用密文和密钥产生原始明文
 */


+ (NSString *)parseByte2HexString:(Byte *)bytes :(int)len {
    NSString *hexStr = @"";
    if (bytes) {
        for (int i = 0; i < len; i++) {
            NSString *newHS = [NSString stringWithFormat:@"%x",bytes[i]&0xff];
            if ([newHS length] == 1) {
                hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHS];
            }
            else {
                hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHS];
            }
        }
    }
    return hexStr;
}

+ (NSData *)convertHexStrToData:(NSString *)str {
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    
    NSLog(@"hexdata: %@", hexData);
    return hexData;
}


//加密
+ (NSString *)encryption:(NSString *)plainText key:(NSString *)key {
    NSString *ciphertext = nil;
    const char *textBytes = [plainText UTF8String];
    size_t dataLength = [plainText length];
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    bufferPtrSize = (dataLength + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    bufferPtr = malloc(bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    NSData *data = [key dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bts = (Byte *)[data bytes];
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES, kCCOptionPKCS7Padding, [key UTF8String], kCCKeySizeDES, bts, textBytes, dataLength, (void *)bufferPtr, bufferPtrSize, &movedBytes);
    if (cryptStatus == kCCSuccess) {
        ciphertext = [self parseByte2HexString:bufferPtr :(int)movedBytes];
    }
    ciphertext = [ciphertext uppercaseString];
    return ciphertext;
}

//解密
+ (NSString *)decryption:(NSString *)cipherText key:(NSString *)key {
    NSString *plainText = nil;
    NSData *cipherData = [self convertHexStrToData:[cipherText lowercaseString]];
    unichar buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesDecry = 0;
    NSData *data = [key dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bts = (Byte *)[data bytes];
    CCCryptorStatus crypStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES, kCCOptionPKCS7Padding, [key UTF8String], kCCKeySizeDES, bts, [cipherData bytes], [cipherData length], buffer, 1024, &numBytesDecry);
    if (crypStatus == kCCSuccess) {
        NSData* data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecry];
        plainText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return plainText;
}

@end

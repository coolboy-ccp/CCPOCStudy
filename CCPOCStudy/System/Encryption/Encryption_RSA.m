//
//  Encryption_RSA.m
//  CCPOCStudy
//
//  Created by chuchengpeng on 2018/1/9.
//  Copyright © 2018年 Ceair. All rights reserved.
//

#import "Encryption_RSA.h"
#import <Security/Security.h>

@implementation Encryption_RSA

/*
 * RSA 非对称加密
 * 公钥加密 私钥解密 | 私钥加密 公钥解密
 
 * 生成模板长为1024bit的私钥文件private_key.pem
 ** openssl genrsa -out private_key.pem 1024
 * 生成证书请求文件 rsaCerReq.csr
 ** openssl req -new -key private_key.pem -out rsaCerReq.csr
 * 生成证书rsaCert.crt,设置有效期为1年
 ** openssl x509 -req -days 3650 -in rsaCerReq.csr -signkey private_key.pem -out rsaCert.crt
 
 * 生成ios使用的公钥文件public_key.der
 ** openssl x509 -outform der -in rsaCert.crt -out public_key.der
 * 生成ios使用的私钥文件private_key.p12
 ** openssl pkcs12 -export -out private_key.p12 -inkey private_key.pem -in rsaCert.crt
 
 (下面的两个文件用文本编辑器打开即可获取相应的秘钥字符串)
 * 生成java使用的公钥rsa_public_key.pem
 ** openssl rsa -in private_key.pem -out rsa_public_key.pem -pubout
 * 生成Java使用的私钥pkcs8_private_key.pem
 ** openssl pkcs8 -topk8 -in private_key.pem -out pkcs8_private_key.pem -nocrypt
 
 ** http://web.chacuo.net/netrsakeypair 生成公私钥字符串的网站
 
 https://www.jianshu.com/p/43f7fc8d8e14
 https://www.jianshu.com/p/74a796ec5038
 */

static NSString *base64_encode_data(NSData *data) {
    NSData *nData = [data base64EncodedDataWithOptions:0];
    NSString *ret = [[NSString alloc] initWithData:nData encoding:NSUTF8StringEncoding];
    return ret;
}

static NSData *base64_decode(NSString *str) {
    NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return data;
}

#pragma mark -- 使用.der公钥文件加密

//从文件中获取公钥
+ (SecKeyRef)publicKeyWithFilePath:(NSString *)fp {
    NSData *cerdata = [NSData dataWithContentsOfFile:fp];
    if (!cerdata) {
        return nil;
    }
    SecCertificateRef cert = SecCertificateCreateWithData(NULL, (CFDataRef)cerdata);
    SecKeyRef kf = NULL;
    SecTrustRef tf = NULL;
    SecPolicyRef pf = NULL;
    if (cert != NULL) {
        if (SecTrustCreateWithCertificates((CFTypeRef)cert, pf, &tf) == noErr) {
            SecTrustResultType rt;
            if (SecTrustEvaluate(tf, &rt) == noErr) {
                kf = SecTrustCopyPublicKey(tf);
            }
        }
    }
    if (pf) CFRelease(pf);
    if (tf) CFRelease(tf);
    if (cert) CFRelease(cert);
    return kf;
}

//加密
+ (NSString *)encryptyString:(NSString *)str filePath:(NSString *)fp {
    if (![str dataUsingEncoding:NSUTF8StringEncoding]) {
        return nil;
    }
    if (fp == nil) return nil;
    SecKeyRef kf = [self publicKeyWithFilePath:fp];
    if (kf == NULL) return nil;
    NSData *ndata = [self encryptData:[str dataUsingEncoding:NSUTF8StringEncoding] withKeyRef:kf];
    NSString *ret = base64_encode_data(ndata);
    return ret;
}

+ (NSData *)encryptData:(NSData *)data withKeyRef:(SecKeyRef) keyRef{
    const uint8_t *srcbuf = (const uint8_t *)[data bytes];
    size_t srclen = (size_t)data.length;
    size_t block_size = SecKeyGetBlockSize(keyRef) * sizeof(uint8_t);
    void *outbuf = malloc(block_size);
    size_t src_block_size = block_size - 11;
    NSMutableData *ret = [[NSMutableData alloc] init];
    for(int idx=0; idx<srclen; idx+=src_block_size){
        size_t data_len = srclen - idx;
        if(data_len > src_block_size){
            data_len = src_block_size;
        }
        size_t outlen = block_size;
        OSStatus status = noErr;
        status = SecKeyEncrypt(keyRef,
                               kSecPaddingPKCS1,
                               srcbuf + idx,
                               data_len,
                               outbuf,
                               &outlen
                               );
        if (status != 0) {
            NSLog(@"SecKeyEncrypt fail. Error Code: %d", status);
            ret = nil;
            break;
        }else{
            [ret appendBytes:outbuf length:outlen];
        }
    }
    
    free(outbuf);
    CFRelease(keyRef);
    return ret;
}

/**
 使用公钥文件对字符串进行加密

 @param oStr 需要加密的字符串
 @param fp 公钥地址
 @return 加密后的字符串
 */
+ (NSString *)encryption_RSA_der:(NSString *)oStr filePath:(NSString *)fp {
    if (!oStr || !fp) {
        return nil;
    }
    return [self encryptyString:oStr filePath:fp];
}

#pragma mark -- 获取私钥文件解密
//获取私钥
+ (SecKeyRef)privateKeyRefWifthFilePath:(NSString *)fp password:(NSString *)pw {
    NSData *data = [NSData dataWithContentsOfFile:fp];
    if (data == nil) return nil;
    SecKeyRef kf = NULL;
    NSDictionary *opts = @{(__bridge id)kSecImportExportPassphrase:pw};
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    OSStatus sError = SecPKCS12Import((__bridge CFDataRef)data, (__bridge CFDictionaryRef)opts, &items);
    if (noErr == sError && CFArrayGetCount(items) > 0) {
        CFDictionaryRef identifyDic = CFArrayGetValueAtIndex(items, 0);
        SecIdentityRef idRF = (SecIdentityRef)CFDictionaryGetValue(identifyDic, kSecImportItemIdentity);
        sError = SecIdentityCopyPrivateKey(idRF, &kf);
        if (sError != noErr) {
            kf = NULL;
        }
    }
    CFRelease(items);
    return kf;
}

+ (NSData *)decryption:(NSData *)data fileKeyRef:(SecKeyRef)keyRef {
    const uint8_t *srcbuf = (const uint8_t *)[data bytes];
    size_t srclen = (size_t)data.length;
    size_t block_size = SecKeyGetBlockSize(keyRef) * sizeof(uint8_t);
    UInt8 *outbuf = malloc(block_size);
    size_t src_block_size = block_size;
    
    NSMutableData *ret = [[NSMutableData alloc] init];
    for(int idx=0; idx<srclen; idx+=src_block_size){
        size_t data_len = srclen - idx;
        if(data_len > src_block_size){
            data_len = src_block_size;
        }
        
        size_t outlen = block_size;
        OSStatus status = noErr;
        status = SecKeyDecrypt(keyRef,
                               kSecPaddingNone,
                               srcbuf + idx,
                               data_len,
                               outbuf,
                               &outlen
                               );
        if (status != 0) {
            NSLog(@"SecKeyEncrypt fail. Error Code: %d", status);
            ret = nil;
            break;
        }else{
            //the actual decrypted data is in the middle, locate it!
            int idxFirstZero = -1;
            int idxNextZero = (int)outlen;
            for ( int i = 0; i < outlen; i++ ) {
                if ( outbuf[i] == 0 ) {
                    if ( idxFirstZero < 0 ) {
                        idxFirstZero = i;
                    } else {
                        idxNextZero = i;
                        break;
                    }
                }
            }
            
            [ret appendBytes:&outbuf[idxFirstZero+1] length:idxNextZero-idxFirstZero-1];
        }
    }
    
    free(outbuf);
    CFRelease(keyRef);
    return ret;
}

+ (NSString *)decryption:(NSString *)str filePath:(NSString *)fp password:(NSString *)pwd{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    if (fp == nil) return nil;
    SecKeyRef kf = [self privateKeyRefWifthFilePath:fp password:pwd];
    if (kf == nil) return nil;
    data = [self decryption:data fileKeyRef:kf];
    NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return ret;
}

+ (NSString *)decryption:(NSString *)oStr file:(NSString *)fp password:(NSString *)pwd {
    if (!oStr || !fp) {
        return nil;
    }
    pwd = pwd?:@"";
    return [self decryption:oStr filePath:fp password:pwd];
}

#pragma mark -- 使用公钥字符串加密

+ (NSString *)useStringEncry:(NSString *)str publicKey:(NSString *)key {
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSData *ecData = [self useStringEncryData:data publicKey:key];
    NSString *ret = base64_encode_data(ecData);
    return ret;
}

+ (NSData *)useStringEncryData:(NSData *)data publicKey:(NSString *)key {
    if (!data || !key) return nil;
    SecKeyRef kf = [self addPublicKey:key];
    if (!kf) return nil;
    return [self encryptData:data withKeyRef:kf];
}


+ (SecKeyRef)addPublicKey:(NSString *)key{
    NSRange spos = [key rangeOfString:@"-----BEGIN PUBLIC KEY-----"];
    NSRange epos = [key rangeOfString:@"-----END PUBLIC KEY-----"];
    if(spos.location != NSNotFound && epos.location != NSNotFound){
        NSUInteger s = spos.location + spos.length;
        NSUInteger e = epos.location;
        NSRange range = NSMakeRange(s, e-s);
        key = [key substringWithRange:range];
    }
    key = [key stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@" "  withString:@""];
    
    // This will be base64 encoded, decode it.
    NSData *data = base64_decode(key);
    data = [self stripPublicKeyHeader:data];
    if(!data){
        return nil;
    }
    
    //a tag to read/write keychain storage
    NSString *tag = @"RSAUtil_PubKey";
    NSData *d_tag = [NSData dataWithBytes:[tag UTF8String] length:[tag length]];
    
    // Delete any old lingering key with the same tag
    NSMutableDictionary *publicKey = [[NSMutableDictionary alloc] init];
    [publicKey setObject:(__bridge id) kSecClassKey forKey:(__bridge id)kSecClass];
    [publicKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [publicKey setObject:d_tag forKey:(__bridge id)kSecAttrApplicationTag];
    SecItemDelete((__bridge CFDictionaryRef)publicKey);
    
    // Add persistent version of the key to system keychain
    [publicKey setObject:data forKey:(__bridge id)kSecValueData];
    [publicKey setObject:(__bridge id) kSecAttrKeyClassPublic forKey:(__bridge id)
     kSecAttrKeyClass];
    [publicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)
     kSecReturnPersistentRef];
    
    CFTypeRef persistKey = nil;
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)publicKey, &persistKey);
    if (persistKey != nil){
        CFRelease(persistKey);
    }
    if ((status != noErr) && (status != errSecDuplicateItem)) {
        return nil;
    }
    [publicKey removeObjectForKey:(__bridge id)kSecValueData];
    [publicKey removeObjectForKey:(__bridge id)kSecReturnPersistentRef];
    [publicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
    [publicKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    SecKeyRef keyRef = nil;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)publicKey, (CFTypeRef *)&keyRef);
    if(status != noErr){
        return nil;
    }
    return keyRef;
}

+ (NSData *)stripPublicKeyHeader:(NSData *)d_key{
    // Skip ASN.1 public key header
    if (d_key == nil) return(nil);
    
    unsigned long len = [d_key length];
    if (!len) return(nil);
    
    unsigned char *c_key = (unsigned char *)[d_key bytes];
    unsigned int  idx     = 0;
    
    if (c_key[idx++] != 0x30) return(nil);
    
    if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
    else idx++;
    
    // PKCS #1 rsaEncryption szOID_RSA_RSA
    static unsigned char seqiod[] =
    { 0x30,   0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x01,
        0x01, 0x05, 0x00 };
    if (memcmp(&c_key[idx], seqiod, 15)) return(nil);
    
    idx += 15;
    
    if (c_key[idx++] != 0x03) return(nil);
    
    if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
    else idx++;
    if (c_key[idx++] != '\0') return(nil);
    return ([NSData dataWithBytes:&c_key[idx] length:len - idx]);
}

#pragma mark -- 使用私钥字符串解密

+ (NSString *)useStringDecry:(NSString *)str privateKey:(NSString *)key {
    if (key == nil) return nil;
    NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    data = [self useStringDecryData:data privateKey:key];
    NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return ret;
}

+ (NSData *)useStringDecryData:(NSData *)data privateKey:(NSString *)key {
    if (!data || !key) return nil;
    SecKeyRef kf = [self addPublicKey:key];
    if (kf == nil) return nil;
    return [self decryption:data fileKeyRef:kf];
}

+ (SecKeyRef)addPrivateKey:(NSString *)key{
    NSRange spos = [key rangeOfString:@"-----BEGIN RSA PRIVATE KEY-----"];
    NSRange epos = [key rangeOfString:@"-----END RSA PRIVATE KEY-----"];
    if(spos.location != NSNotFound && epos.location != NSNotFound){
        NSUInteger s = spos.location + spos.length;
        NSUInteger e = epos.location;
        NSRange range = NSMakeRange(s, e-s);
        key = [key substringWithRange:range];
    }
    key = [key stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@" "  withString:@""];
    
    // This will be base64 encoded, decode it.
    NSData *data = base64_decode(key);
    data = [self stripPrivateKeyHeader:data];
    if(!data){
        return nil;
    }
    
    //a tag to read/write keychain storage
    NSString *tag = @"RSAUtil_PrivKey";
    NSData *d_tag = [NSData dataWithBytes:[tag UTF8String] length:[tag length]];
    
    // Delete any old lingering key with the same tag
    NSMutableDictionary *privateKey = [[NSMutableDictionary alloc] init];
    [privateKey setObject:(__bridge id) kSecClassKey forKey:(__bridge id)kSecClass];
    [privateKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [privateKey setObject:d_tag forKey:(__bridge id)kSecAttrApplicationTag];
    SecItemDelete((__bridge CFDictionaryRef)privateKey);
    
    // Add persistent version of the key to system keychain
    [privateKey setObject:data forKey:(__bridge id)kSecValueData];
    [privateKey setObject:(__bridge id) kSecAttrKeyClassPrivate forKey:(__bridge id)
     kSecAttrKeyClass];
    [privateKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)
     kSecReturnPersistentRef];
    
    CFTypeRef persistKey = nil;
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)privateKey, &persistKey);
    if (persistKey != nil){
        CFRelease(persistKey);
    }
    if ((status != noErr) && (status != errSecDuplicateItem)) {
        return nil;
    }
    
    [privateKey removeObjectForKey:(__bridge id)kSecValueData];
    [privateKey removeObjectForKey:(__bridge id)kSecReturnPersistentRef];
    [privateKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
    [privateKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    
    // Now fetch the SecKeyRef version of the key
    SecKeyRef keyRef = nil;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)privateKey, (CFTypeRef *)&keyRef);
    if(status != noErr){
        return nil;
    }
    return keyRef;
}

+ (NSData *)stripPrivateKeyHeader:(NSData *)d_key{
    // Skip ASN.1 private key header
    if (d_key == nil) return(nil);
    
    unsigned long len = [d_key length];
    if (!len) return(nil);
    
    unsigned char *c_key = (unsigned char *)[d_key bytes];
    unsigned int  idx     = 22; //magic byte at offset 22
    
    if (0x04 != c_key[idx++]) return nil;
    
    //calculate length of the key
    unsigned int c_len = c_key[idx++];
    int det = c_len & 0x80;
    if (!det) {
        c_len = c_len & 0x7f;
    } else {
        int byteCount = c_len & 0x7f;
        if (byteCount + idx > len) {
            //rsa length field longer than buffer
            return nil;
        }
        unsigned int accum = 0;
        unsigned char *ptr = &c_key[idx];
        idx += byteCount;
        while (byteCount) {
            accum = (accum << 8) + *ptr;
            ptr++;
            byteCount--;
        }
        c_len = accum;
    }
    return [d_key subdataWithRange:NSMakeRange(idx, c_len)];
}
@end

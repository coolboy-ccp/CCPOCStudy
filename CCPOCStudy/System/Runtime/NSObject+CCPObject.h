//
//  NSObject+CCPObject.h
//  CCPOCStudy
//
//  Created by chuchengpeng on 2017/12/21.
//  Copyright © 2017年 Ceair. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (CCPObject)

//
@property (nonatomic, copy) NSString *ccpTestProperty;

- (NSArray<Class> *)typeOfProperties;

- (NSArray<NSString *> *)propertyNames;
@end

//
//  Employee+CoreDataProperties.h
//  CCPOCStudy
//
//  Created by chuchengpeng on 2017/12/20.
//  Copyright © 2017年 Ceair. All rights reserved.
//
//

#import "Employee+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Employee (CoreDataProperties)

+ (NSFetchRequest<Employee *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *birthday;
@property (nonatomic) float height;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *sectionName;
@property (nullable, nonatomic, retain) Company *company;

@end

NS_ASSUME_NONNULL_END

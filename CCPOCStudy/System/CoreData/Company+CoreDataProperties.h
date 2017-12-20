//
//  Company+CoreDataProperties.h
//  CCPOCStudy
//
//  Created by chuchengpeng on 2017/12/20.
//  Copyright © 2017年 Ceair. All rights reserved.
//
//

#import "Company+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Company (CoreDataProperties)

+ (NSFetchRequest<Company *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *companyName;
@property (nullable, nonatomic, copy) NSDate *createDate;
@property (nullable, nonatomic, retain) NSSet<Employee *> *employee;

@end

@interface Company (CoreDataGeneratedAccessors)

- (void)addEmployeeObject:(Employee *)value;
- (void)removeEmployeeObject:(Employee *)value;
- (void)addEmployee:(NSSet<Employee *> *)values;
- (void)removeEmployee:(NSSet<Employee *> *)values;

@end

NS_ASSUME_NONNULL_END

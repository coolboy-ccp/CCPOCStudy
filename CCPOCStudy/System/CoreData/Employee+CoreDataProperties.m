//
//  Employee+CoreDataProperties.m
//  CCPOCStudy
//
//  Created by chuchengpeng on 2017/12/20.
//  Copyright © 2017年 Ceair. All rights reserved.
//
//

#import "Employee+CoreDataProperties.h"

@implementation Employee (CoreDataProperties)

+ (NSFetchRequest<Employee *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Employee"];
}

@dynamic birthday;
@dynamic height;
@dynamic name;
@dynamic sectionName;
@dynamic company;

@end

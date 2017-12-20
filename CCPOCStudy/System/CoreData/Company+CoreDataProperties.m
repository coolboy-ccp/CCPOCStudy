//
//  Company+CoreDataProperties.m
//  CCPOCStudy
//
//  Created by chuchengpeng on 2017/12/20.
//  Copyright © 2017年 Ceair. All rights reserved.
//
//

#import "Company+CoreDataProperties.h"

@implementation Company (CoreDataProperties)

+ (NSFetchRequest<Company *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Company"];
}

@dynamic companyName;
@dynamic createDate;
@dynamic employee;

@end

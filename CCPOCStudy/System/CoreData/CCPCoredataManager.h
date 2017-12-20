//
//  CCPCoredataManager.h
//  CCPOCStudy
//
//  Created by chuchengpeng on 2017/12/15.
//  Copyright © 2017年 Ceair. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Company+CoreDataProperties.h"
#import "Employee+CoreDataProperties.h"



@interface CCPCoredataManager : NSObject

//
@property (nonatomic, strong, readonly) NSManagedObjectContext *moc;
//
@property (nonatomic, strong, readonly) NSManagedObjectModel *mom;
//
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *psc;
//
@property (strong, readonly) NSPersistentContainer *pc;

- (void)saveContext;
- (NSURL *)applicationDocumentDirectory;

@end

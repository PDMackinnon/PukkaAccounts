//
//  DataManager.h
//  PukkaAccounts
//
//  Created by Paul Mackinnon on 10/10/2011.
//  Copyright 2011 DJCAD, Dundee University. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const DataManagerDidSaveNotification;
extern NSString * const DataManagerDidSaveFailedNotification;

@interface DataManager : NSObject {
@private
    NSPersistentStoreCoordinator *__persistentStoreCoordinator;
    NSManagedObjectModel *__managedObjectModel;
    NSManagedObjectContext *__managedObjectContext;
}

@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;


+ (DataManager*)sharedInstance;
- (BOOL)save;

@end

//
//  User.h
//  PukkaAccounts
//
//  Created by Paul Mackinnon on 17/07/2012.
//  Copyright (c) 2012 Dundee University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Transaction;

@interface User : NSManagedObject

@property (nonatomic, retain) NSNumber * enabledUser;
@property (nonatomic, retain) NSNumber * currentYearofStudy;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * emailAddress;
@property (nonatomic, retain) NSString * matricNumber;
@property (nonatomic, retain) NSString * fullName;
@property (nonatomic, retain) NSString * subjectOfStudy;
@property (nonatomic, retain) NSSet *transactions;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addTransactionsObject:(Transaction *)value;
- (void)removeTransactionsObject:(Transaction *)value;
- (void)addTransactions:(NSSet *)values;
- (void)removeTransactions:(NSSet *)values;

@end

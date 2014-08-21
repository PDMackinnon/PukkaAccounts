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

@property (nonatomic, strong) NSNumber * enabledUser;
@property (nonatomic, strong) NSNumber * currentYearofStudy;
@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSString * emailAddress;
@property (nonatomic, strong) NSString * matricNumber;
@property (nonatomic, strong) NSString * fullName;
@property (nonatomic, strong) NSString * subjectOfStudy;
@property (nonatomic, strong) NSSet *transactions;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addTransactionsObject:(Transaction *)value;
- (void)removeTransactionsObject:(Transaction *)value;
- (void)addTransactions:(NSSet *)values;
- (void)removeTransactions:(NSSet *)values;

@end

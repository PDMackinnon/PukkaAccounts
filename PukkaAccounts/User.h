//
//  User.h
//  PukkaAccounts
//
//  Created by Paul Mackinnon on 10/10/2011.
//  Copyright (c) 2011 DJCAD, Dundee University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Transaction;

@interface User : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * currentYearofStudy;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * emailAddress;
@property (nonatomic, retain) NSString * matricNumber;
@property (nonatomic, retain) NSString * fullName;
@property (nonatomic, retain) NSString * subjectOfStudy;
@property (nonatomic, retain) NSSet* transactions;

@end

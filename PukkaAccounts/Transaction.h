//
//  Transaction.h
//  PukkaAccounts
//
//  Created by Paul Mackinnon on 10/10/2011.
//  Copyright (c) 2011 DJCAD, Dundee University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Transaction : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * transDescription;
@property (nonatomic, retain) NSDecimalNumber * creditAmount;
@property (nonatomic, retain) NSNumber * pending;
@property (nonatomic, retain) NSDecimalNumber * itemCost;
@property (nonatomic, retain) NSNumber * saleQuantity;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) User * user;

@end

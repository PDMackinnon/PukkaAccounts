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
@property (nonatomic, strong) NSString * transDescription;
@property (nonatomic, strong) NSDecimalNumber * creditAmount;
@property (nonatomic, strong) NSNumber * pending;
@property (nonatomic, strong) NSDecimalNumber * itemCost;
@property (nonatomic, strong) NSNumber * saleQuantity;
@property (nonatomic, strong) NSDate * date;
@property (nonatomic, strong) User * user;

@end

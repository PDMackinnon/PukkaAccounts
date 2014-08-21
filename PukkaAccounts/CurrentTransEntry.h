//
//  CurrentTransEntry.h
//  PukkaAccounts
//
//  Created by Paul Mackinnon on 11/10/2011.
//  Copyright 2011 DJCAD, Dundee University. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CurrentTransEntry : NSObject {
@private
   NSDecimalNumber * _value;
}
@property (nonatomic, strong) NSString * transDescription;
@property (nonatomic, strong) NSDecimalNumber * itemCost;
@property (nonatomic, strong) NSNumber * saleQuantity;
@property (nonatomic, strong) NSDate * saleDate;

@property (readonly) NSDecimalNumber * saleAmountValue;  //calculated value


@end

//
//  CurrentTransEntry.m
//  PukkaAccounts
//
//  Created by Paul Mackinnon on 11/10/2011.
//  Copyright 2011 DJCAD, Dundee University. All rights reserved.
//

#import "CurrentTransEntry.h"


@implementation CurrentTransEntry

@synthesize transDescription = _transDescription;
@synthesize itemCost = _itemCost;
@synthesize saleQuantity = _saleQuantity;
@synthesize saleDate = _saleDate;


-(NSDecimalNumber *)saleAmountValue {
    
  //  NSDecimalNumber* val = [itemCost decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithDecimal:[saleQuantity decimalValue]]];
   // return val;
    
  //  NSDecimalNumber *q = [NSDecimalNumber decimalNumberWithDecimal:[self.saleQuantity decimalValue]];
  //  return ([self.itemCost decimalNumberByMultiplyingBy:q]);
    
    NSLog(@"%@",[_itemCost className]);
    
//   _value = [self.itemCost decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"4.0"]];
   
//   return [self.itemCost decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"4.0"]];
   
    
    float itemCostFloat = [_itemCost floatValue];
    float result = -1 * itemCostFloat * [_saleQuantity intValue];
    NSLog(@"result = %f",result);
    
    return [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithFloat:result] decimalValue] ];
    
    
}


+(NSSet *) keyPathsForValuesAffectingSaleAmountValue {
    return [NSSet setWithObjects:@"self.itemCost", @"self.saleQuantity", nil];
    
}


- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        self.saleQuantity = [NSNumber numberWithInt:1];
        
        
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

@end



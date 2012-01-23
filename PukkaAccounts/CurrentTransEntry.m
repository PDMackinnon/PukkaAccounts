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



/* Answers (aDecimal x -1) */
NSDecimalNumber* negate(NSDecimalNumber *aDecimal) {
    return [aDecimal decimalNumberByMultiplyingBy:
            [NSDecimalNumber decimalNumberWithMantissa: 1
                                              exponent: 0
                                            isNegative: YES]];
}//end negate



-(NSDecimalNumber *)saleAmountValue {
    
    //fix thanks to Apple TSI # 186633505
    //number formatter in nib chng to X10.4 custom, Generate Decimal Numbers
    //now stays in NSDeciaml through the calc - done 21-1-12
    
    NSDecimalNumber* val = [self.itemCost decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithDecimal:[self.saleQuantity decimalValue]]];
    return negate(val);
    
    /*
    float itemCostFloat = [_itemCost floatValue];
    float result = -1 * itemCostFloat * [_saleQuantity intValue];
    NSLog(@"result = %f",result);
    
    return [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithFloat:result] decimalValue] ];
    */
    
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
        
        self.saleDate = [NSDate date];  //fixes bug - needed to init date to today - changed 21/1/12
        
        
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

@end



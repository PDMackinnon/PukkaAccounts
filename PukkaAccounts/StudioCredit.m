//
//  StudioCredit.m
//  PukkaAccounts
//
//  Created by Paul Mackinnon on 26/03/2012.
//  Copyright (c) 2012 DJCAD, Dundee University. All rights reserved.
//

#import "StudioCredit.h"

@implementation StudioCredit
@synthesize descriptionTextField;
@synthesize amountTextField;

@synthesize creditDescription = _creditDescription;
@synthesize creditAmount = _creditAmount;



- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        self.creditAmount = nil;
        
        self.creditDescription = @"Studio Credit";      
        
    }
    
    return self;
}


@end

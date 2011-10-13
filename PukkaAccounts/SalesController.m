//
//  SalesController.m
//  PukkaAccounts
//
//  Created by Paul Mackinnon on 11/10/2011.
//  Copyright 2011 DJCAD, Dundee University. All rights reserved.
//

#import "SalesController.h"


@implementation SalesController

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void)awakeFromNib {

    [self setFilterPredicate:[NSPredicate predicateWithFormat:@"pending == YES"]];
 
    //   NSLog(@"%@",[self filterPredicate]);
}


- (void)dealloc
{
    [super dealloc];
}

@end

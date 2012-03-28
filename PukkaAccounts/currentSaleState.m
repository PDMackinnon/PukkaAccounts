//
//  CurrentSaleState.m
//  PukkaAccounts
//
//  Created by Paul Mackinnon on 27/10/2011.
//  Copyright 2011 DJCAD, Dundee University. All rights reserved.
//

#import "CurrentSaleState.h"


@implementation CurrentSaleState
@synthesize greenImageCell;
@synthesize redImageCell;
@synthesize newBalanceDisplay;
@synthesize allTransactions;
@synthesize priceEach;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}


+(NSSet *) keyPathsForValuesAffectingProcessSaleButtonImage {
    return [NSSet setWithObjects:@"self.newBalanceDisplay.floatValue",@"self.allTransactions.arrangedObjects", nil];
    
}

-(NSImage *)processSaleButtonImage {
    
    if ([newBalanceDisplay floatValue] < 0) {
        
        return [redImageCell image];
    }
    else {
        
        return [greenImageCell image];
    }
}





-(NSColor *)newBalanceDisplayColor {
    
    
    
    //temp
    
    return [NSColor grayColor];   
}


@end

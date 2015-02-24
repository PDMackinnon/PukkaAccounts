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
@synthesize currentBalanceDisplay;
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



+(NSSet *) keyPathsForValuesAffectingProcessSaleButtonImage {
    return [NSSet setWithObjects:@"self.currentBalanceDisplay.floatValue",@"self.allTransactions.arrangedObjects", nil];
    
}

-(NSImage *)processSaleButtonImage {
    
    if ([currentBalanceDisplay floatValue] < 0) {
        
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

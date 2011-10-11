//
//  TransController.m
//  PrintSeller
//
//  Created by Paul Mackinnon on 16/09/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TransController.h"


@implementation TransController

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void)awakeFromNib {
    [self setFilterPredicate:[NSPredicate predicateWithFormat:@"pending == NO"]];
}





- (void)dealloc
{
    [super dealloc];
}

@end

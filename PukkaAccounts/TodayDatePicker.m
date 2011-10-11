//
//  TodayDatePicker.m
//  PrintSeller
//
//  Created by Paul Mackinnon on 12/09/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TodayDatePicker.h"


@implementation TodayDatePicker

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


-(void)awakeFromNib {
    
    // Create todays date
    
    NSDate *todayDate = [NSDate date];
    
    // use the todayDate as the newStartDate
    [self setDateValue:todayDate];
    
    
    
}


- (void)dealloc
{
    [super dealloc];
}

@end

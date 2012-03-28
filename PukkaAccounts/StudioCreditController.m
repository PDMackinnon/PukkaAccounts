//
//  StudioCreditController.m
//  PukkaAccounts
//
//  Created by Paul Mackinnon on 26/03/2012.
//  Copyright (c) 2012 DJCAD, Dundee University. All rights reserved.
//

#import "StudioCreditController.h"

@implementation StudioCreditController
@synthesize modalAddMultipleCredits;

- (IBAction)addCreditForSelected:(id)sender {
    
    long result = [[NSApplication sharedApplication] runModalForWindow:modalAddMultipleCredits];
    
    [modalAddMultipleCredits close];

}

- (IBAction)cancelAddModal:(id)sender {
     
    [[NSApplication sharedApplication] abortModal];
    
    
}


@end

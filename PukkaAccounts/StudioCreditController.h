//
//  StudioCreditController.h
//  PukkaAccounts
//
//  Created by Paul Mackinnon on 26/03/2012.
//  Copyright (c) 2012 DJCAD, Dundee University. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface StudioCreditController : NSObjectController


@property (assign) IBOutlet NSWindow *modalAddMultipleCredits;


- (IBAction)addCreditForSelected:(id)sender;
- (IBAction)cancelAddModal:(id)sender;

@end

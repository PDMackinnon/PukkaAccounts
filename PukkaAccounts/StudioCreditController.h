//
//  StudioCreditController.h
//  PukkaAccounts
//
//  Created by Paul Mackinnon on 26/03/2012.
//  Copyright (c) 2012 DJCAD, Dundee University. All rights reserved.
//

#import <AppKit/AppKit.h>
#import <WebKit/WebView.h>

#import "DataManager.h"
#import "Transaction.h"

@interface StudioCreditController : NSObjectController


@property (assign) IBOutlet NSWindow *modalAddMultipleCredits;

@property (assign) IBOutlet NSArrayController *searchResultsController;
@property (assign) IBOutlet NSTextField *totalAmountAdded;

- (IBAction)addCreditForSelected:(id)sender;
- (IBAction)cancelAddModal:(id)sender;
- (IBAction)confirmAddCredits:(id)sender;
- (IBAction)printInvoice:(id)sender;

@end

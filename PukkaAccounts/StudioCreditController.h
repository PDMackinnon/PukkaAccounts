//
//  StudioCreditController.h
//  PukkaAccounts
//
//  Created by Paul Mackinnon on 26/03/2012.
//  Copyright (c) 2012 DJCAD, Dundee University. All rights reserved.
//

#import <AppKit/AppKit.h>
#import <WebKit/WebKit.h>

#import "CJSONSerializer.h"
#import "CJSONDeserializer.h"


#import "DataManager.h"
#import "Transaction.h"

@interface StudioCreditController : NSObjectController


@property (strong) IBOutlet NSWindow *modalAddMultipleCredits;
@property (strong) IBOutlet NSWindow *modalDisableUsers;
@property (strong) IBOutlet NSWindow *modalEnableUsers;

@property (strong) IBOutlet NSArrayController *searchResultsController;
@property (strong) IBOutlet NSTextField *totalAmountAdded;
@property (strong) IBOutlet NSTextView *messageText;

- (IBAction)addCreditForSelected:(id)sender;
- (IBAction)cancelAddModal:(id)sender;
- (IBAction)confirmAddCredits:(id)sender;
- (IBAction)printInvoice:(id)sender;
- (IBAction)emailUsersToCredit:(id)sender;


- (IBAction)enableSelectedUsers:(id)sender;
- (IBAction)disableSelectedUsers:(id)sender;

- (IBAction)confirmDisableUsers:(id)sender;
- (IBAction)confirmEnableUsers:(id)sender;

- (IBAction)exportSelectedBalances:(id)sender;


@end

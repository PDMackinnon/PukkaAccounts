//
//  PukkaAccountsAppDelegate.h
//  PukkaAccounts
//
//  Created by Paul Mackinnon on 10/10/2011.
//  Copyright 2011 DJCAD, Dundee University. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>

#import "CJSONSerializer.h"
#import "CJSONDeserializer.h"

#import "TodayDatePicker.h"

#import "DataManager.h"
#import "Transaction.h"



@interface PukkaAccountsAppDelegate : NSObject <NSApplicationDelegate> {
@private
    NSWindow *window;
  // DataManager *_dataManager;
    NSWindow *manageUsersWindow;
    
    Transaction *pendingCredit;
    TodayDatePicker *creditDate;
    NSTextField *creditDescr;
    NSTextField *creditAmount;
    NSTextField *crDateDispl;
    NSTextField *crDescrDispl;
    NSTextField *creditAmountDispl;
    NSTextField *crTransTotal;
    NSTextField *crNewBalance;
    NSTextField *crCurrBalance;
    NSArrayController *userSearch;
    NSView *studioCreditView;
    NSTextField *studioCreditDescr;
    NSTextField *studioCreditAmount;
    NSButton *studioCreditCheckBox;
}

@property (assign) IBOutlet NSWindow *window;
@property (readonly) DataManager *dataManager;
@property (assign) IBOutlet NSWindow *manageUsersWindow;
@property (assign) IBOutlet NSWindow *studioCreditManagerWindow;


@property (nonatomic,retain) Transaction *pendingCredit;

@property (assign) IBOutlet TodayDatePicker *creditDate;
@property (assign) IBOutlet NSTextField *creditDescr;
@property (assign) IBOutlet NSTextField *creditAmount;

@property (assign) IBOutlet NSTextField *crDateDispl;
@property (assign) IBOutlet NSTextField *crDescrDispl;
@property (assign) IBOutlet NSTextField *creditAmountDispl;

@property (assign) IBOutlet NSTextField *crTransTotal;
@property (assign) IBOutlet NSTextField *crNewBalance;
@property (assign) IBOutlet NSTextField *crCurrBalance;

@property (assign) IBOutlet NSArrayController *userSearch;

@property (assign) IBOutlet NSView *studioCreditView;
@property (assign) IBOutlet NSTextField *studioCreditDescr;
@property (assign) IBOutlet NSTextField *studioCreditAmount;
@property (assign) IBOutlet NSButton *studioCreditCheckBox;


- (IBAction)addNewCredit:(id)sender;
- (IBAction)processCredit:(id)sender;
- (IBAction)cancelNewCredit:(id)sender;


- (IBAction)activateStudioCreditWindow:(id)sender;


- (IBAction)saveAction:sender;
- (IBAction)activatePOSwindow:(id)sender;
- (IBAction)activateManageUsersWin:(id)sender;
- (IBAction)importJSON:(id)sender;
- (IBAction)importWithCredit:(id)sender;

@end

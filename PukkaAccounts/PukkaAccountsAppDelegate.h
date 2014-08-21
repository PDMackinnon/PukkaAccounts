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
    NSWindow *__strong window;
  // DataManager *_dataManager;
    NSWindow *__strong manageUsersWindow;
    
    Transaction *pendingCredit;
    TodayDatePicker *__strong creditDate;
    NSTextField *__strong creditDescr;
    NSTextField *__strong creditAmount;
    NSTextField *__strong crDateDispl;
    NSTextField *__strong crDescrDispl;
    NSTextField *__strong creditAmountDispl;
    NSTextField *__strong crTransTotal;
    NSTextField *__strong crNewBalance;
    NSTextField *__strong crCurrBalance;
    NSArrayController *__strong userSearch;
    NSView *__strong studioCreditView;
    NSTextField *__strong studioCreditDescr;
    NSTextField *__strong studioCreditAmount;
    NSButton *__strong studioCreditCheckBox;
}

@property (strong) IBOutlet NSWindow *window;
@property (readonly) DataManager *dataManager;
@property (strong) IBOutlet NSWindow *manageUsersWindow;
@property (strong) IBOutlet NSWindow *studioCreditManagerWindow;
@property (strong) IBOutlet NSWindow *reportsWindow;


@property (nonatomic,strong) Transaction *pendingCredit;

@property (strong) IBOutlet TodayDatePicker *creditDate;
@property (strong) IBOutlet NSTextField *creditDescr;
@property (strong) IBOutlet NSTextField *creditAmount;

@property (strong) IBOutlet NSTextField *crDateDispl;
@property (strong) IBOutlet NSTextField *crDescrDispl;
@property (strong) IBOutlet NSTextField *creditAmountDispl;

@property (strong) IBOutlet NSTextField *crTransTotal;
@property (strong) IBOutlet NSTextField *crNewBalance;
@property (strong) IBOutlet NSTextField *crCurrBalance;

@property (strong) IBOutlet NSArrayController *userSearch;

@property (strong) IBOutlet NSView *studioCreditView;
@property (strong) IBOutlet NSTextField *studioCreditDescr;
@property (strong) IBOutlet NSTextField *studioCreditAmount;
@property (strong) IBOutlet NSButton *studioCreditCheckBox;


- (IBAction)addNewCredit:(id)sender;
- (IBAction)processCredit:(id)sender;
- (IBAction)cancelNewCredit:(id)sender;


- (IBAction)activateStudioCreditWindow:(id)sender;


- (IBAction)saveAction:sender;
- (IBAction)activatePOSwindow:(id)sender;
- (IBAction)activateManageUsersWin:(id)sender;
- (IBAction)importJSON:(id)sender;
- (IBAction)importWithCredit:(id)sender;
- (IBAction)updateJSON:(id)sender;

@end

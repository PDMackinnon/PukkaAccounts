//
//  CurrentTransEntryController.h
//  PukkaAccounts
//
//  Created by Paul Mackinnon on 11/10/2011.
//  Copyright 2011 DJCAD, Dundee University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import <CoreData/CoreData.h>

#import "DataManager.h"
#import "Transaction.h"
#import "SalesController.h"
#import "TransController.h"

#import "TodayDatePicker.h"

#import "LabelPrintView.h"




@interface CurrentTransEntryController : NSObjectController {
@private
    
    NSArrayController *__strong userSearch;
//    NSButton *saleProcessButton;
//    NSTextField *newBalance;
    SalesController *__strong posArrayController;
    TransController *__strong transactionsController;
}


@property (strong) IBOutlet SalesController *posArrayController;
@property (strong) IBOutlet TransController *transactionsController;
@property (strong) IBOutlet NSArrayController *userSearch;

//@property (assign) IBOutlet NSButton *saleProcessButton;
//@property (assign) IBOutlet NSTextField *newBalance;

- (IBAction)addSaleTransaction:(id)sender;
- (IBAction)processSale:(id)sender;
- (IBAction)cancelPendingSales:(id)sender;
- (IBAction)insufficientCredit:(id)sender;


@end

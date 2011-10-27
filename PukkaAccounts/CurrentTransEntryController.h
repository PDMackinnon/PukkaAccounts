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




@interface CurrentTransEntryController : NSObjectController {
@private
    
    NSArrayController *userSearch;
    SalesController *posArrayController;
    TransController *transactionsController;
}


@property (assign) IBOutlet SalesController *posArrayController;
@property (assign) IBOutlet TransController *transactionsController;
@property (assign) IBOutlet NSArrayController *userSearch;


- (IBAction)addSaleTransaction:(id)sender;
- (IBAction)processSale:(id)sender;
- (IBAction)cancelPendingSales:(id)sender;
- (IBAction)insufficientCredit:(id)sender;


@end

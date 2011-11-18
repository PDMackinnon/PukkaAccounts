//
//  CurrentTransEntryController.m
//  PukkaAccounts
//
//  Created by Paul Mackinnon on 11/10/2011.
//  Copyright 2011 DJCAD, Dundee University. All rights reserved.
//

#import "CurrentTransEntryController.h"


@implementation CurrentTransEntryController
@synthesize posArrayController;
@synthesize transactionsController;
@synthesize userSearch;
//@synthesize saleProcessButton;
//@synthesize newBalance;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        
    }
    
    return self;
}

- (IBAction)addSaleTransaction:(id)sender {
    
    [self commitEditing]; //ensure that latest edit in unit price field is updated to the model
    
    
    NSManagedObjectContext * moc = [[DataManager sharedInstance] managedObjectContext];
    
    NSManagedObject *newTransaction = [[Transaction alloc] initWithEntity:[NSEntityDescription entityForName:@"Transaction" inManagedObjectContext:moc] insertIntoManagedObjectContext:moc];
    
    
    //debug bad date...
    
    NSLog(@"date = %@",[[self content] valueForKey:@"saleDate"]);
    
  //  [newTransaction setValue:[[self content] valueForKey:@"saleDate"] forKey:@"date"];
    [newTransaction setValue: [NSDate date] forKey:@"date"];

   
    
    
    [newTransaction setValue:[[self content] valueForKey:@"transDescription"] forKey:@"transDescription"];
    
    [newTransaction setValue:[[self content] valueForKey:@"saleAmountValue"]  forKey:@"creditAmount"];
    
    [newTransaction setValue:[[self content] valueForKey:@"itemCost"] forKey:@"itemCost"]; 
    [newTransaction setValue:[[self content] valueForKey:@"saleQuantity"] forKey:@"saleQuantity"];
    
    [newTransaction setValue:[NSNumber numberWithBool:YES] forKey:@"pending"];
    
    [newTransaction setValue:[[userSearch selectedObjects] objectAtIndex:0] forKey:@"user"];
    
    
    
    // visually affect the main POS process sale button if the resulting balance is in deficit - experiment
    /*
    NSLog(@"new balance = %f",[newBalance floatValue]);
    
    if ([newBalance floatValue] < 0 ) {
        [saleProcessButton setState:NSOffState];
    }
    else
    {
        [saleProcessButton setState:NSOnState];
    }
    */
    //result is that we need to use bindings..... as update is not dynamic enough
    
    
}//end add Sale


- (IBAction)processSale:(id)sender {
    
    
    //for selected user - get pending transactions - email user witn the items and message
    // confirm new total is still in credit - TODO -> or else email with message to user with amount required
    
    // these pending transactions setPending = NO
    
    // [_currencyFormatter stringFromNumber:[pendingCredit creditAmount]]
    
    
    NSNumberFormatter *_currencyFormatter = [[NSNumberFormatter alloc] init];
    [_currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    NSDateFormatter *_dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [_dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    

    NSString * emailSubj = @"Printing completed. Please Collect.";
    NSString * encodedEmailSubj = (NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                      NULL,
                                                                                      (CFStringRef)emailSubj,
                                                                                      NULL,
                                                                                      (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                      kCFStringEncodingUTF8 );
    
    NSMutableString * emailMessage = [NSMutableString stringWithFormat:@"DJCAD Print Sales from your account:\n\n"];
        
    NSString* emailAddr = [[[userSearch selectedObjects] objectAtIndex:0] emailAddress];

    NSArray* pendingSales = [posArrayController arrangedObjects];  
    
    NSString* atSymbol = @" @ ";
    
    for (id saleObject in pendingSales) {        
        [emailMessage appendFormat:@"%@ :\t\t %@  x\t %@ \t\t\t %@ %@ \t = \t %@ \n",
                                                                [_dateFormatter stringFromDate:[saleObject date]],
                                                                [saleObject saleQuantity],
                                                                [saleObject transDescription],
                                                                atSymbol,
                                                                [_currencyFormatter stringFromNumber:[saleObject itemCost]],
                                                                [_currencyFormatter stringFromNumber:[saleObject creditAmount]]];
  
        
    }//end iterate for loop
    
    
    [posArrayController willChangeValueForKey:@"arrangedObjects"];
    
    for (id saleObject in pendingSales) {
        NSLog(@"pending = %@, amount = %@, person = %@",[saleObject pending], [saleObject creditAmount], [[saleObject user] fullName]);    
        
        //last step - pending = NO
        //    [saleObject setPending:[NSNumber numberWithBool:NO]];
        
        [saleObject setValue:[NSNumber numberWithBool:NO] forKey:@"pending"];
        
    }//end iterate for loop
    
    [posArrayController didChangeValueForKey:@"arrangedObjects"];
    
    
    
    //   [[self managedObjectContext] processPendingChanges];
    //   NSError *error = nil;
    //   [self.managedObjectContext save:&error]; 
    //    [[self posTableView] reloadData];
    //    [[self posTableView] setNeedsDisplay];
    //   [_salesController setFilterPredicate:[NSPredicate predicateWithFormat:@"pending == YES"]];
    
    [posArrayController rearrangeObjects];
    [transactionsController rearrangeObjects];
    
    //continue email process.. now transaction is done...
    
    
    NSLog(@"transactions .....%@",[transactionsController valueForKeyPath:@"arrangedObjects.@sum.creditAmount"]);
    
    [emailMessage appendFormat:@"\n\n\nNew balance Total is:\t %@",[_currencyFormatter stringFromNumber:[transactionsController valueForKeyPath:@"arrangedObjects.@sum.creditAmount"]]];
    
    NSString * encodedEmailMessage = (NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                         NULL,
                                                                                         (CFStringRef)emailMessage,
                                                                                         NULL,
                                                                                         (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                         kCFStringEncodingUTF8 );
    
    
    NSString* mailToString = [NSString stringWithFormat:@"mailto:%@?subject=%@&body=%@",emailAddr,encodedEmailSubj,encodedEmailMessage];
    
    NSURL * url = [NSURL URLWithString:mailToString];
    
    [[NSWorkspace sharedWorkspace] openURL:url];
    
    [_currencyFormatter release];  //end of email section..
    [_dateFormatter release];
    
    
    
    NSLog(@"%@",[posArrayController arrangedObjects]);
    
    //clear inputs
    
    [[self content] setValue:[NSDate date] forKey:@"saleDate"];  // todays date
    [[self content] setValue:[NSNumber numberWithInt:1] forKey:@"saleQuantity"];
    [[self content] setValue:@"" forKey:@"transDescription"];
    [[self content] setValue:@"" forKey:@"itemCost"];
     
    
}//end process sale






- (IBAction)cancelPendingSales:(id)sender {
    [posArrayController removeObjectsAtArrangedObjectIndexes:
     [NSIndexSet indexSetWithIndexesInRange:
      NSMakeRange(0, [[posArrayController arrangedObjects] count])]];   //removes all pending objects via posarraycontroller

    //clear inputs
    [[self content] setValue:[NSDate date] forKey:@"saleDate"];  // todays date
    [[self content] setValue:[NSNumber numberWithInt:1] forKey:@"saleQuantity"];
    [[self content] setValue:@"" forKey:@"transDescription"];
    [[self content] setValue:@"" forKey:@"itemCost"];

    
}

- (IBAction)insufficientCredit:(id)sender {
    //leave the pending transactions as they are, but email the user to request more credit 
    
    NSNumberFormatter *_currencyFormatter = [[NSNumberFormatter alloc] init];
    [_currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    NSDateFormatter *_dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [_dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    
    NSString * emailSubj = @"Printing on hold. Please supply account credit";
    NSString * encodedEmailSubj = (NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                      NULL,
                                                                                      (CFStringRef)emailSubj,
                                                                                      NULL,
                                                                                      (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                      kCFStringEncodingUTF8 );
    
    NSMutableString * emailMessage = [NSMutableString stringWithFormat:@"Pending items that exceed the available balance:\n\n"];
    
    NSString* emailAddr = [[[userSearch selectedObjects] objectAtIndex:0] emailAddress];
    
    NSArray* pendingSales = [posArrayController arrangedObjects];  
    
    NSString* atSymbol = @" @ ";
    
    for (id saleObject in pendingSales) {        
        [emailMessage appendFormat:@"%@ :\t %@  x\t %@ \t\t %@ %@ \t = \t %@ \n",
         [_dateFormatter stringFromDate:[saleObject date]],
         [saleObject saleQuantity],
         [saleObject transDescription],
         atSymbol,
         [_currencyFormatter stringFromNumber:[saleObject itemCost]],
         [_currencyFormatter stringFromNumber:[saleObject creditAmount]]];
        
        
    }//end iterate for loop

    
    [emailMessage appendFormat:@"\n\n\nCurrent balance available is:\t %@",[_currencyFormatter stringFromNumber:[transactionsController valueForKeyPath:@"arrangedObjects.@sum.creditAmount"]]];
    
    NSString * encodedEmailMessage = (NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                         NULL,
                                                                                         (CFStringRef)emailMessage,
                                                                                         NULL,
                                                                                         (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                         kCFStringEncodingUTF8 );
    
    
    NSString* mailToString = [NSString stringWithFormat:@"mailto:%@?subject=%@&body=%@",emailAddr,encodedEmailSubj,encodedEmailMessage];
    
    NSURL * url = [NSURL URLWithString:mailToString];
    
    [[NSWorkspace sharedWorkspace] openURL:url];
    
    [_currencyFormatter release];  //end of email section..
    [_dateFormatter release];
    
    
    //clear inputs
    
    [[self content] setValue:[NSDate date] forKey:@"saleDate"];  // todays date
    [[self content] setValue:[NSNumber numberWithInt:1] forKey:@"saleQuantity"];
    [[self content] setValue:@"" forKey:@"transDescription"];
    [[self content] setValue:@"" forKey:@"itemCost"];
    
    
    
}





- (void)dealloc
{
    [super dealloc];
}


@end

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
    
    
    
    NSLog(@"new transaction is : %@",newTransaction);
    
    
    
    
}//end add Sale


- (IBAction)processSale:(id)sender {
    
    
    //for selected user - get pending transactions - email user witn the items and message
    
    // confirm new total is still in credit - TODO -> or else email with message to user with amount required
    
    // these pending transactions setPending = NO
    
    //thats it there is no next step!
    
    //    NSLog(@"%@",[[_salesController content] filteredArrayUsingPredicate:[_salesController filterPredicate]]);
    
    
    //NSLog(@"filter = %@",[_salesController filterPredicate]);
    
    
    //  NSArray *pendingSales = [[_salesController content] filteredArrayUsingPredicate:[_salesController filterPredicate]];
    
    
    
    //iterate over pendingSales array, and process as required
    
    //  NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    //  [request setEntity:[NSEntityDescription entityForName:@"Transaction" inManagedObjectContext:[self managedObjectContext]]];
    
    
    
    
    NSArray* pendingSales = [posArrayController arrangedObjects];                    
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





- (void)dealloc
{
    [super dealloc];
}


@end

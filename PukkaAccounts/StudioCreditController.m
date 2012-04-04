//
//  StudioCreditController.m
//  PukkaAccounts
//
//  Created by Paul Mackinnon on 26/03/2012.
//  Copyright (c) 2012 DJCAD, Dundee University. All rights reserved.
//

#import "StudioCreditController.h"


@interface StudioCreditController (internal)

-(void) addStudioCredit:(NSDecimalNumber *)amount forUser:(NSManagedObject*)currentUser;

@end

@implementation StudioCreditController (internal)


-(void) addStudioCredit:(NSDecimalNumber *)amount forUser:(NSManagedObject*)currentUser {
    
    NSManagedObjectContext * moc = [[DataManager sharedInstance] managedObjectContext];
    
    Transaction* importCredit = [[Transaction alloc] initWithEntity:[NSEntityDescription entityForName:@"Transaction" inManagedObjectContext:moc] insertIntoManagedObjectContext:moc];
    
    
    [importCredit setValue:[NSDate date] forKey:@"date"];                              //today's date
    [importCredit setValue:@"DJCAD Studio credit" forKey:@"transDescription"];         // describe as studio credit....
    [importCredit setValue:amount forKey:@"creditAmount"];                             //amount as given
    
    [importCredit setValue:amount forKey:@"itemCost"];                                 //amount as given
    
    [importCredit setValue:[NSNumber numberWithInt:1] forKey:@"saleQuantity"];
    [importCredit setValue:[NSNumber numberWithBool:NO] forKey:@"pending"];    // not pending as inserted immediateley
    
    [importCredit setValue:currentUser forKey:@"user"];
    
    
    [importCredit release];   //need to consider memory management....
    
}


@end





@implementation StudioCreditController
@synthesize modalAddMultipleCredits;
@synthesize searchResultsController;
@synthesize totalAmountAdded;

- (IBAction)addCreditForSelected:(id)sender {
    
    [self commitEditing]; //make sure data entry is accepted
    
    NSArray * selectedUsers = [self searchResultsController].selectedObjects;
    
    long c = selectedUsers.count;
    float f = [[[self content] valueForKey:@"creditAmount"] floatValue];
    [self totalAmountAdded].floatValue = c * f;
    
    
    
    long result = [[NSApplication sharedApplication] runModalForWindow:modalAddMultipleCredits];
    
    [modalAddMultipleCredits close];

}

- (IBAction)cancelAddModal:(id)sender {
     
    [[NSApplication sharedApplication] abortModal];
    
    
}

- (IBAction)confirmAddCredits:(id)sender {
    
  //  NSLog(@"count = %lu",[[self searchResultsController].selectedObjects count]);
 //   NSLog(@"/n/nselected is %@",[self searchResultsController].selectedObjects);
    
    
 
    //perform add credit for each member of the array
    //main task
    
    for (id userToCredit in [self searchResultsController].selectedObjects) {
        
        
        [self addStudioCredit:[[self content] valueForKey:@"creditAmount"] forUser:(NSManagedObject *)userToCredit];
        
    }
    
    
    [[NSApplication sharedApplication] stopModal];
    
}

- (IBAction)printInvoice:(id)sender {
    
    WebView * printWebView = [[WebView alloc] initWithFrame:NSMakeRect(0.0, 0.0, 800.0, 600.0) frameName:@"pwFrame" groupName:@"pwGroup"];
    
    //gen HTML here
 
    NSMutableString * invoiceHTML = [NSMutableString stringWithFormat:@"%@<br><br>Print@DJCAD studio credits were added as follows: <br><br>",[NSDate date]];
    
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
 //   [numberFormatter setLocale];
    
    
    for (id userToCredit in [self searchResultsController].selectedObjects) {
        
        [invoiceHTML appendFormat:@"%@ recieved studio credit of %@ <br>", [userToCredit valueForKey:@"fullName"],
         [numberFormatter stringFromNumber:[[self content] valueForKey:@"creditAmount"]]];
    
    }

    [[printWebView mainFrame] loadHTMLString:invoiceHTML baseURL:nil];
    

    
    /* to load from file...
     
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"invoice" 
                                                         ofType:@"html"
                                                    inDirectory:@""];
    NSURL* fileURL = [NSURL fileURLWithPath:filePath];
    NSURLRequest* request = [NSURLRequest requestWithURL:fileURL];
    [[printWebView mainFrame] loadRequest:request];
    
     */
     
    
    
    //now print it...
    
    [printWebView print:self];
    
    
    
    
}


@end

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
-(void) emailDJCADorders;

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
    
    

    
}



-(void) emailDJCADorders {
    
    NSNumberFormatter *_currencyFormatter = [[NSNumberFormatter alloc] init];
    [_currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    NSArray * selectedUsers = [self searchResultsController].selectedObjects;
    
    
//    NSLog(@"%@",[self messageText].string);
//    NSLog(@"%lu",selectedUsers.count);
//    NSLog(@"%@", [[self content] valueForKey:@"creditDescription"]);
//    NSLog(@"%@", [_currencyFormatter stringFromNumber:[[self content] valueForKey:@"creditAmount"]]);
//    NSLog(@"%@",[self totalAmountAdded].stringValue);

    
    
    
    
    NSString * emailMessage = [NSString stringWithFormat:NSLocalizedString(@"%@\n\nINVOICE:\n\n%lu * %@ of %@ = %@",@"Batched Studio Credit email message"),
                               [self messageText].string,
                               selectedUsers.count,
                               [[self content] valueForKey:@"creditDescription"],
                               [_currencyFormatter stringFromNumber:[[self content] valueForKey:@"creditAmount"]],
                               [self totalAmountAdded].stringValue];
    
    
   

    
    
    NSString * emailSubj = NSLocalizedString(@"Studio%20Credit%20Invoice",@"Batched Studio Credit email subject");
    
    NSString * encodedEmailMessage = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                         NULL,
                                                                                         (CFStringRef)emailMessage,
                                                                                         NULL,
                                                                                         (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                         kCFStringEncodingUTF8 ));
    
    NSString* emailAddr = @"djcadorders@dundee.ac.uk";
    
    NSString* mailToString = [NSString stringWithFormat:@"mailto:%@?subject=%@&body=%@",emailAddr,emailSubj,encodedEmailMessage];
    
 //   NSLog(@"%@",mailToString);
    
    
    
    NSURL * url = [NSURL URLWithString:mailToString];
    
    [[NSWorkspace sharedWorkspace] openURL:url];
    
}

@end





@implementation StudioCreditController
@synthesize modalAddMultipleCredits;
@synthesize modalDisableUsers;
@synthesize modalEnableUsers;
@synthesize searchResultsController;
@synthesize totalAmountAdded;
@synthesize messageText;

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
    
    
    //TODO - email djcadorders@dundee.ac.uk with the total invoice summary....
    
    [self emailDJCADorders];
    
    
    
    
    [[NSApplication sharedApplication] stopModal];
    
}

- (IBAction)printInvoice:(id)sender {
    
    
    //TODO - refine frame size to suit - i.e. more users to add -> height of frame is bigger
    
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
    
//    [printWebView print:self];
    
    [ [  [printWebView.mainFrame frameView] documentView] print:self];
    
    
    
}

- (IBAction)emailUsersToCredit:(id)sender {
    
    
    
    NSMutableString* emailAddr = [NSMutableString stringWithString:@"djcadprint@dundee.ac.uk"];
    
    
    for (id userToCredit in [self searchResultsController].selectedObjects) {
        
        [emailAddr appendFormat:@",%@",[userToCredit valueForKey:@"emailAddress"]];
        
    }

//    NSLog(@"address = %@",emailAddr);
    
    
    
    NSNumberFormatter *_currencyFormatter = [[NSNumberFormatter alloc] init];
    [_currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    NSArray * selectedUsers = [self searchResultsController].selectedObjects;
    
    NSString * emailMessage = [NSString stringWithFormat:@"%@\n\n%@\t\t%@\n\n",
                               [self messageText].string,
                               [[self content] valueForKey:@"creditDescription"],
                               [_currencyFormatter stringFromNumber:[[self content] valueForKey:@"creditAmount"]]
                                ];
    
//    NSLog(@"message = %@",emailMessage);
    
    
    
  //  NSString * emailSubj = NSLocalizedString(@"",@"");     TODO !!
    
    NSString * emailSubj = @"Print DJCAD Studio Credits";
    
    
    NSString * encodedEmailSubj = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                         NULL,
                                                                                         (CFStringRef)emailSubj,
                                                                                         NULL,
                                                                                         (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                         kCFStringEncodingUTF8 ));
    
    
    NSString * encodedEmailMessage = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                         NULL,
                                                                                         (CFStringRef)emailMessage,
                                                                                         NULL,
                                                                                         (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                         kCFStringEncodingUTF8 ));
      
    
    
    NSString* mailToString = [NSString stringWithFormat:@"mailto:%@?subject=%@&body=%@",emailAddr,encodedEmailSubj,encodedEmailMessage];
    
//       NSLog(@"composed email string = %@",mailToString);
    
    
    
    NSURL * url = [NSURL URLWithString:mailToString];
    

    
    [[NSWorkspace sharedWorkspace] openURL:url];
    
    

    
    
    
    
}






- (IBAction)enableSelectedUsers:(id)sender {
    
    
    NSArray * selectedUsers = [self searchResultsController].selectedObjects;

    long result = [[NSApplication sharedApplication] runModalForWindow: modalEnableUsers];
    
    [modalEnableUsers close];

    
    
}

- (IBAction)disableSelectedUsers:(id)sender {
    
    
    NSArray * selectedUsers = [self searchResultsController].selectedObjects;

    long result = [[NSApplication sharedApplication] runModalForWindow: modalDisableUsers];
    
    [modalDisableUsers close];
    
    
}

- (IBAction)confirmDisableUsers:(id)sender {
    
    for (id userToDisable in [self searchResultsController].selectedObjects) {
        
        [userToDisable setValue:[NSNumber numberWithBool:NO] forKey:@"enabledUser"];
        
    }//end for loop

    
    
    [[NSApplication sharedApplication] stopModal];
    
}//end confirm Disabled Users method

- (IBAction)confirmEnableUsers:(id)sender {
    for (id userToEnable in [self searchResultsController].selectedObjects) {
        
        [userToEnable setValue:[NSNumber numberWithBool:YES] forKey:@"enabledUser"];
        
    }//end for loop
    
    
    
    [[NSApplication sharedApplication] stopModal];
}

- (IBAction)exportSelectedBalances:(id)sender {
    
    
    NSLog(@"export balances 2014 admin tasks");
    
    
    NSMutableArray *exportData = [NSMutableArray array]; //empty mutable array
    
    NSDateFormatter *jsonDateFormat = [[NSDateFormatter alloc] init];
    [jsonDateFormat setFormatterBehavior:NSDateFormatterBehavior10_4];
    [jsonDateFormat setDateStyle:NSDateFormatterShortStyle];
    [jsonDateFormat setTimeStyle:NSDateFormatterNoStyle];
    

    NSNumberFormatter *_currencyFormatter = [[NSNumberFormatter alloc] init];
    [_currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    
    
    
    
    NSArray * selectedUsers = [self searchResultsController].selectedObjects;
    
    for (id userToExport in selectedUsers) {
        
        
//        @property (nonatomic, strong) NSNumber * enabledUser;
//        @property (nonatomic, strong) NSNumber * currentYearofStudy;
//        @property (nonatomic, strong) NSString * userName;
//        @property (nonatomic, strong) NSString * emailAddress;
//        @property (nonatomic, strong) NSString * matricNumber;
//        @property (nonatomic, strong) NSString * fullName;
//        @property (nonatomic, strong) NSString * subjectOfStudy;
//        @property (nonatomic, strong) NSSet *transactions;

        /*
        NSLog(@"userName is: %@\n",[userToExport valueForKey:@"userName"]);
        NSLog(@"currentYearofStudy is: %@\n",[userToExport valueForKey:@"currentYearofStudy"]);
        NSLog(@"fullName is: %@\n",[userToExport valueForKey:@"fullName"]);
        NSLog(@"subjectOfStudy is: %@\n",[userToExport valueForKey:@"subjectOfStudy"]);
        NSLog(@"matricNumber is: %@\n",[userToExport valueForKey:@"matricNumber"]);
        NSLog(@"emailAddress is: %@\n",[userToExport valueForKey:@"emailAddress"]);
       // NSLog(@"transactions is: %@\n",[userToExport valueForKey:@"transactions"]);
        NSLog(@"total 1 is: %@\n",[userToExport valueForKeyPath:@"transactions.@sum.creditAmount"]);
        */
        

        //****------****-----
        NSPredicate * notPending = [NSPredicate predicateWithFormat:@"pending == NO"];
        NSSet *doneTransactions = [[userToExport valueForKey:@"transactions"] filteredSetUsingPredicate:notPending];
        
      //  NSLog(@"total 2 is: %@\n", [doneTransactions valueForKeyPath:@"@sum.creditAmount"]);

        // total 2 is the correct answer !
        //****------****-----

        
        
        NSArray *userRow = [NSArray arrayWithObjects:   [userToExport valueForKey:@"userName"],
                                                        [userToExport valueForKey:@"matricNumber"],
                                                        [userToExport valueForKey:@"currentYearofStudy"],
                                                        [userToExport valueForKey:@"fullName"],
                                                        [userToExport valueForKey:@"subjectOfStudy"],
                                                        [userToExport valueForKey:@"emailAddress"],
                                                        [doneTransactions valueForKeyPath:@"@sum.creditAmount"],
                                                        nil];
        
      //  NSLog(@"row recored is: %@",userRow);
        
        [exportData addObject:userRow];
        
        
        
    }//end for loop

    NSError *error = NULL;
    
    
    NSData *theJSONData = [[CJSONSerializer serializer] serializeArray:exportData error:&error];
    if (error) {
        NSLog(@"Serialization Error: %@", error);
    }
    
    // Change the data back to a string
    NSString* theStringObject = [[NSString alloc] initWithData:theJSONData encoding:NSUTF8StringEncoding];
    
    
    NSLog(@"export JSON...\n%@",theStringObject);
    
    
    int result;
    NSArray *fileTypes = [NSArray arrayWithObject:@"json"];
    NSSavePanel *saveJSONpanel = [NSSavePanel savePanel];
    [saveJSONpanel setAllowedFileTypes:fileTypes];
    
    result = [saveJSONpanel runModal];
    
    if (result == NSFileHandlingPanelOKButton) {
        
        NSURL*  theFile = [saveJSONpanel URL];
        
        //write the file....
        
        NSLog(@"save as...%@",theFile);
        
        error = NULL;
        
        [theStringObject writeToURL:theFile atomically:YES encoding:NSUTF8StringEncoding error:&error];
        
        
        if (error) {
            NSLog(@"file save Error: %@", error);
        }
        
        
    }

    
    
    
}


@end

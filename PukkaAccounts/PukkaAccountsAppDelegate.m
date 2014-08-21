//
//  PukkaAccountsAppDelegate.m
//  PukkaAccounts
//
//  Created by Paul Mackinnon on 10/10/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PukkaAccountsAppDelegate.h"

@interface PukkaAccountsAppDelegate (internal)
    
-(void) addStudioCredit:(float)amount forUser:(NSManagedObject*)currentUser;

@end

@implementation PukkaAccountsAppDelegate (internal)


-(void) addStudioCredit:(float)amount forUser:(NSManagedObject*)currentUser {
    
    NSManagedObjectContext * moc = [[DataManager sharedInstance] managedObjectContext];

    Transaction* importCredit = [[Transaction alloc] initWithEntity:[NSEntityDescription entityForName:@"Transaction" inManagedObjectContext:moc] insertIntoManagedObjectContext:moc];
    
    
    [importCredit setValue:[NSDate date] forKey:@"date"];                              //today's date
    [importCredit setValue:@"DJCAD Studio credit" forKey:@"transDescription"];         // describe as studio credit....
    [importCredit setValue:[NSNumber numberWithFloat: amount] forKey:@"creditAmount"];                             //amount as given
    
    [importCredit setValue:[NSNumber numberWithFloat: amount] forKey:@"itemCost"];                                 //amount as given
            
    [importCredit setValue:[NSNumber numberWithInt:1] forKey:@"saleQuantity"];
    [importCredit setValue:[NSNumber numberWithBool:NO] forKey:@"pending"];    // not pending as inserted immediateley
    
    [importCredit setValue:currentUser forKey:@"user"];
    
    
    
}


@end


@implementation PukkaAccountsAppDelegate

@synthesize manageUsersWindow;
@synthesize studioCreditManagerWindow;
@synthesize reportsWindow;
@synthesize creditDate;
@synthesize creditDescr;
@synthesize creditAmount;
@synthesize crDateDispl;
@synthesize crDescrDispl;
@synthesize creditAmountDispl;
@synthesize crTransTotal;
@synthesize crNewBalance;
@synthesize crCurrBalance;
@synthesize userSearch;
@synthesize studioCreditView;
@synthesize studioCreditDescr;
@synthesize studioCreditAmount;
@synthesize studioCreditCheckBox;
@dynamic pendingCredit;

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
   // _dataManager = [DataManager sharedInstance];
    
}

-(void)awakeFromNib {
    [window setExcludedFromWindowsMenu:YES];
    [manageUsersWindow setExcludedFromWindowsMenu:YES];
    [studioCreditManagerWindow setExcludedFromWindowsMenu:YES];
    [reportsWindow setExcludedFromWindowsMenu:YES];
    
}


-(DataManager *) dataManager {
    return [DataManager sharedInstance];
    
}

/**
    Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
 */
- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window {
    return [[[DataManager sharedInstance] managedObjectContext] undoManager];
}

/**
    Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
 */
- (IBAction) saveAction:(id)sender {
    //  NSError *error = nil;
    
    [[DataManager sharedInstance] save];
    
}



- (IBAction)addNewCredit:(id)sender {
    //single line transaction is prepared to add when the larger confirmation button is pressed. 
    // so need just a single transaction stored and displayed, pending the confirmation
    
    NSManagedObjectContext * moc = [[DataManager sharedInstance] managedObjectContext];
    pendingCredit = [[Transaction alloc] initWithEntity:[NSEntityDescription entityForName:@"Transaction" inManagedObjectContext:moc] insertIntoManagedObjectContext:nil];
    
    
    NSLog(@"pending credit object is: @%@",pendingCredit);
    
    [pendingCredit setValue:creditDate.dateValue forKey:@"date"];
    [pendingCredit setValue:creditDescr.stringValue forKey:@"transDescription"];
    [pendingCredit setValue:[NSNumber numberWithFloat:creditAmount.floatValue] forKey:@"creditAmount"];  //note need to change to NSDecimal !!!! TODO
    
    [pendingCredit setValue:[NSNumber numberWithFloat:creditAmount.floatValue] forKey:@"itemCost"]; //note need to change to NSDecimal !!!! TODO
    
    [pendingCredit setValue:[NSNumber numberWithInt:1] forKey:@"saleQuantity"];
    [pendingCredit setValue:[NSNumber numberWithBool:NO] forKey:@"pending"];    // will not mark this as pending as it will be prepared to be valid non-pending -> ready to be added to MOC later...
    
    
    NSLog(@"pending credit object is: @%@",pendingCredit);
    
    NSLog(@"amount = %@\n\n\n",[pendingCredit creditAmount]);
    
    
    //display new credit
    [crDateDispl setObjectValue:[creditDate dateValue]];
    [crDescrDispl setStringValue:creditDescr.stringValue];
    [creditAmountDispl setFloatValue:creditAmount.floatValue];
    
    [crTransTotal setFloatValue:creditAmount.floatValue];
    [crNewBalance setFloatValue:crCurrBalance.floatValue + creditAmount.floatValue];
    
}//end add new credit method


- (IBAction)processCredit:(id)sender {
    if (pendingCredit == nil) {
        //alert error !
        // TODO
        
        return;
    }//end if
    
    
    NSManagedObjectContext * moc = [[DataManager sharedInstance] managedObjectContext];

    //add credit transaction to main MOC
    [moc insertObject:pendingCredit];
    
    [pendingCredit setValue:[[userSearch selectedObjects] objectAtIndex:0] forKey:@"user"];
    
    NSLog(@"pending credit object is: @%@",pendingCredit);
    
    NSLog(@"%@",[[userSearch selectedObjects] objectAtIndex:0]);
    
    NSError *err = nil;
    
    [moc save:&err];
    
    
    //email User
    //TODO
    
    
    NSNumberFormatter *_currencyFormatter = [[NSNumberFormatter alloc] init];
    [_currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    NSString * emailMessage = [NSString stringWithFormat:NSLocalizedString(@"DJCAD Print Credit added to your account: %@",@"email message for print credit added"), [_currencyFormatter stringFromNumber:[pendingCredit creditAmount]]];
    
    NSString * emailSubj = NSLocalizedString(@"Print%20Credit%20added",@"email subject for print credit added");
    
    NSString * encodedEmailMessage = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                         NULL,
                                                                                         (CFStringRef)emailMessage,
                                                                                         NULL,
                                                                                         (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                         kCFStringEncodingUTF8 ));
    
//    NSString* emailAddr = [[[userSearch selectedObjects] objectAtIndex:0] emailAddress];
    
    NSString* emailAddr = [[[userSearch selectedObjects] objectAtIndex:0] objectForKey:@"emailAddress"];

    
    NSString* mailToString = [NSString stringWithFormat:@"mailto:%@?subject=%@&body=%@",emailAddr,emailSubj,encodedEmailMessage];
    
    
    NSURL * url = [NSURL URLWithString:mailToString];
    
    [[NSWorkspace sharedWorkspace] openURL:url];
    

    
    
    
    
    
// clear current pending from display and from memory    
    
     //clear and release current pending credit object
    pendingCredit = nil;
    
    //display cleared
    [crDateDispl setStringValue:@""];
    [crDescrDispl setStringValue:@""];
    [creditAmountDispl setStringValue:@""];
    
    [crTransTotal setFloatValue:0.0];
    [crNewBalance setFloatValue:crCurrBalance.floatValue];
    
    [creditDate setObjectValue:[NSDate date]];  // todays date
    [creditDescr setStringValue:@""];
    [creditAmount setStringValue:@""];
    
    
    
    
}

- (IBAction)cancelNewCredit:(id)sender {
    //display cleared
    [crDateDispl setStringValue:@""];
    [crDescrDispl setStringValue:@""];
    [creditAmountDispl setStringValue:@""];
    
    [crTransTotal setFloatValue:0.0];
    [crNewBalance setFloatValue:crCurrBalance.floatValue];
    
    [creditDate setObjectValue:[NSDate date]];  // todays date
    [creditDescr setStringValue:@""];
    [creditAmount setStringValue:@""];
}

- (IBAction)activateStudioCreditWindow:(id)sender {
    [studioCreditManagerWindow makeKeyAndOrderFront:self];
}



- (IBAction)activatePOSwindow:(id)sender {
    [window makeKeyAndOrderFront:self];
    
}

- (IBAction)activateManageUsersWin:(id)sender {
    [manageUsersWindow makeKeyAndOrderFront:self];

}


- (IBAction)updateJSON:(id)sender {
    //open a file dialog, and import CVS plain text for parsing
    
    
    int result;
    NSArray *fileTypes = [NSArray arrayWithObject:@"json"];
    NSOpenPanel *openJSONpanel = [NSOpenPanel openPanel];
    result = [openJSONpanel runModalForDirectory:NSHomeDirectory()
                                            file:nil types:fileTypes];
    
    if (result == NSOKButton) {
        NSArray *filesToOpen = [openJSONpanel filenames];
        
        NSString *theFile = [filesToOpen objectAtIndex:0];
        
        
        NSLog(@"the file is: %@",theFile);
        // NSError * error = [[NSError alloc] init];
        NSError *error = NULL;
        
        NSString *theFileString = [NSString stringWithContentsOfFile:theFile encoding:NSUTF8StringEncoding error:&error];
        if (nil == theFileString) return;
        //    NSScanner *scanner = [NSScanner scannerWithString:theFileString];
        
        NSData *jsonData = [theFileString dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *importDict = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
   
        NSArray *usersImport = [importDict objectForKey:@"users"];
        
        NSArray *matricsToUpdate = [usersImport valueForKey:@"matric"];
        
     //   NSLog(@"matrics to update: %@",matricsToUpdate);
        
        NSPredicate *matricPredicate = [NSPredicate predicateWithFormat:@"matricNumber IN %@",matricsToUpdate];
        
        //fetch these matrics....
         NSManagedObjectContext * moc = [[DataManager sharedInstance] managedObjectContext];
        NSEntityDescription *userEntity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:moc];
        NSFetchRequest *fetchUsersToUpdateReq = [[NSFetchRequest alloc] init];
        [fetchUsersToUpdateReq setEntity:userEntity];
        [fetchUsersToUpdateReq setPredicate:matricPredicate];
        
        NSArray *usersToUpdate = [moc executeFetchRequest:fetchUsersToUpdateReq error:nil];
        
        
       // NSUInteger userIndex;
        
        NSArray *existingMatrics = [usersToUpdate valueForKey:@"matricNumber"]; //array of matric as strings
        
        NSDictionary *lookupExisting = [NSDictionary dictionaryWithObjects:usersToUpdate forKeys:existingMatrics];
        
        for (NSDictionary *userDict in usersImport) {
            NSString *matricText = [userDict objectForKey:@"matric"];
            NSString *userNameText = [userDict objectForKey:@"userName"];
            NSString *fullNameText = [userDict objectForKey:@"fullName"];
            NSString *emailText = [userDict objectForKey:@"email"];
            NSString *courseText = [userDict objectForKey:@"course"];
            NSString *yearInt = [userDict objectForKey:@"year"];
            
            
            if ([existingMatrics containsObject:matricText]) { // found a match in existing data...so update rather than new
             //   NSLog(@"matches %@",matricText);
                
             //   NSLog(@"so update this object:%@",[lookupExisting objectForKey:matricText]);
                
                NSManagedObject *updateUser = [lookupExisting objectForKey:matricText];
                
                
                //commented out attributes that are unlikely to change...
                
              //  [updateUser setValue:userNameText forKey:@"UserName"];
              //  [updateUser setValue:fullNameText forKey:@"FullName"];
              //  [updateUser setValue:emailText forKey:@"EmailAddress"];
                
                //these below may change year to year....
                
                [updateUser setValue:courseText forKey:@"subjectOfStudy"];     
                
                NSNumber *yrofStudy = [NSNumber numberWithInteger:[yearInt integerValue]];  
                
                [updateUser setValue:yrofStudy forKey:@"CurrentYearofStudy"];

                //also re-enable user
                [updateUser setValue:[NSNumber numberWithBool:YES] forKey:@"enabledUser"];
                
                
            }
            
            else { //otherwise new entry...
                
                NSManagedObject *newUser = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:[[DataManager sharedInstance] managedObjectContext]];
                
                [newUser setValue:matricText forKey:@"MatricNumber"];
                [newUser setValue:userNameText forKey:@"UserName"];
                [newUser setValue:fullNameText forKey:@"FullName"];
                [newUser setValue:emailText forKey:@"EmailAddress"];
                [newUser setValue:courseText forKey:@"subjectOfStudy"];     
                
                NSNumber *yrofStudy = [NSNumber numberWithInteger:[yearInt integerValue]];  
                
                [newUser setValue:yrofStudy forKey:@"CurrentYearofStudy"];
                
                [newUser setValue:[NSNumber numberWithBool:YES] forKey:@"enabledUser"];

            }//end if..else..

            
        }//end for
    }//end if OK button from NSopenPanel 
}//end import




- (IBAction)importJSON:(id)sender {
    //open a file dialog, and import CVS plain text for parsing
    
    
    int result;
    NSArray *fileTypes = [NSArray arrayWithObject:@"json"];
    NSOpenPanel *openJSONpanel = [NSOpenPanel openPanel];
    result = [openJSONpanel runModalForDirectory:NSHomeDirectory()
                                           file:nil types:fileTypes];
    
    if (result == NSOKButton) {
        NSArray *filesToOpen = [openJSONpanel filenames];
        
        NSString *theFile = [filesToOpen objectAtIndex:0];
        
        
        NSLog(@"the file is: %@",theFile);
        // NSError * error = [[NSError alloc] init];
        NSError *error = NULL;
        
        NSString *theFileString = [NSString stringWithContentsOfFile:theFile encoding:NSUTF8StringEncoding error:&error];
        if (nil == theFileString) return;
        //    NSScanner *scanner = [NSScanner scannerWithString:theFileString];
        
        NSData *jsonData = [theFileString dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *importDict = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
        
        //   NSArray *theArray = [[CJSONDeserializer deserializer] deserializeAsArray:jsonData error:&error];
        
        
        NSArray *usersImport = [importDict objectForKey:@"users"];
        for (NSDictionary *userDict in usersImport) {
            NSString *matricText = [userDict objectForKey:@"matric"];
            NSString *userNameText = [userDict objectForKey:@"userName"];
            NSString *fullNameText = [userDict objectForKey:@"fullName"];
            NSString *emailText = [userDict objectForKey:@"email"];
            NSString *courseText = [userDict objectForKey:@"course"];
            NSString *yearInt = [userDict objectForKey:@"year"];
            
            NSManagedObject *newUser = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:[[DataManager sharedInstance] managedObjectContext]];
            
            [newUser setValue:matricText forKey:@"MatricNumber"];
            [newUser setValue:userNameText forKey:@"UserName"];
            [newUser setValue:fullNameText forKey:@"FullName"];
            [newUser setValue:emailText forKey:@"EmailAddress"];
            [newUser setValue:courseText forKey:@"subjectOfStudy"];     
            
            NSNumber *yrofStudy = [NSNumber numberWithInteger:[yearInt integerValue]];  
            
            [newUser setValue:yrofStudy forKey:@"CurrentYearofStudy"];
            
            
        }//end for
    }//end if OK button from NSopenPanel 
}//end import

- (IBAction)importWithCredit:(id)sender {
    int result;
    NSArray *fileTypes = [NSArray arrayWithObject:@"json"];
    NSOpenPanel *openJSONpanel = [NSOpenPanel openPanel];
    if ([sender tag]==1) { //with credits button
    [openJSONpanel setAccessoryView:studioCreditView];
    }//end if
    
    result = [openJSONpanel runModalForDirectory:NSHomeDirectory()
                                            file:nil types:fileTypes];
    
    if (result == NSOKButton) {
        NSArray *filesToOpen = [openJSONpanel filenames];
        
        NSString *theFile = [filesToOpen objectAtIndex:0];
        
        
        NSLog(@"the file is: %@",theFile);
        // NSError * error = [[NSError alloc] init];
        NSError *error = NULL;
        
        NSString *theFileString = [NSString stringWithContentsOfFile:theFile encoding:NSUTF8StringEncoding error:&error];
        if (nil == theFileString) return;
        //    NSScanner *scanner = [NSScanner scannerWithString:theFileString];
        
        NSData *jsonData = [theFileString dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *importDict = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
        
        //   NSArray *theArray = [[CJSONDeserializer deserializer] deserializeAsArray:jsonData error:&error];
        
        
        NSArray *usersImport = [importDict objectForKey:@"users"];
        for (NSDictionary *userDict in usersImport) {
            NSString *matricText = [userDict objectForKey:@"matric"];
            NSString *userNameText = [userDict objectForKey:@"userName"];
            NSString *fullNameText = [userDict objectForKey:@"fullName"];
            NSString *emailText = [userDict objectForKey:@"email"];
            NSString *courseText = [userDict objectForKey:@"course"];
            NSString *yearInt = [userDict objectForKey:@"year"];
            
            NSManagedObject *newUser = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:[[DataManager sharedInstance] managedObjectContext]];
            
            [newUser setValue:matricText forKey:@"MatricNumber"];
            [newUser setValue:userNameText forKey:@"UserName"];
            [newUser setValue:fullNameText forKey:@"FullName"];
            [newUser setValue:emailText forKey:@"EmailAddress"];
            [newUser setValue:courseText forKey:@"subjectOfStudy"];     
            
            NSNumber *yrofStudy = [NSNumber numberWithInteger:[yearInt integerValue]];  
            
            [newUser setValue:yrofStudy forKey:@"CurrentYearofStudy"];
            
            if (([studioCreditCheckBox state] == NSOnState) && ([sender tag]==1))    //with credits button and check box checked
                {
                [self addStudioCredit:[studioCreditAmount floatValue] forUser:newUser];
                }
            
            
            
        }//end for
    }//end if OK button from NSopenPanel 

    //TODO: should reset the studiocreditview contents to defaults
    studioCreditDescr.stringValue = @"Studio Credit";
    studioCreditAmount.objectValue = nil;
    studioCreditCheckBox.state = NSOnState;
    
    
    
}
    
    
    






- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {

    // Save changes in the application's managed object context before the application terminates.

    if (![[DataManager sharedInstance] managedObjectContext]) {
        return NSTerminateNow;
    }
    

    if (![[[DataManager sharedInstance] managedObjectContext] hasChanges]) {
        return NSTerminateNow;
    }

    
    if (![[DataManager sharedInstance] save]) {
        NSLog(@"unable to save");
        
        NSString *question = NSLocalizedString(@"Could not save changes while quitting. Quit anyway?", @"Quit without saves error question message");
        NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
        NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
        NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:question];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:quitButton];
        [alert addButtonWithTitle:cancelButton];
        
        NSInteger answer = [alert runModal];
        alert = nil;
        
        if (answer == NSAlertAlternateReturn) {
            return NSTerminateCancel;
        }

        return NSTerminateNow;
    }

    return NSTerminateNow;
}//end application should terminate




@end

//
//  PukkaAccountsAppDelegate.m
//  PukkaAccounts
//
//  Created by Paul Mackinnon on 10/10/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PukkaAccountsAppDelegate.h"

@implementation PukkaAccountsAppDelegate

@synthesize manageUsersWindow;
@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
   // _dataManager = [DataManager sharedInstance];
    
}

-(void)awakeFromNib {
    [window setExcludedFromWindowsMenu:YES];
    [manageUsersWindow setExcludedFromWindowsMenu:YES];
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

- (IBAction)activatePOSwindow:(id)sender {
    [window makeKeyAndOrderFront:self];
    
}

- (IBAction)activateManageUsersWin:(id)sender {
    [manageUsersWindow makeKeyAndOrderFront:self];

}



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
            
            //[newUser setValue:yearInt forKey:@"CurrentYearofStudy"];
            NSNumber *yrofStudy = [NSNumber numberWithInteger:[yearInt integerValue]];  
            
            [newUser setValue:yrofStudy forKey:@"CurrentYearofStudy"];
            
            
        }//end for
    }//end if OK button from NSopenPanel 
}//end import






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
        [alert release];
        alert = nil;
        
        if (answer == NSAlertAlternateReturn) {
            return NSTerminateCancel;
        }

        return NSTerminateNow;
    }

    return NSTerminateNow;
}//end application should terminate



- (void)dealloc
{
    [super dealloc];
}

@end

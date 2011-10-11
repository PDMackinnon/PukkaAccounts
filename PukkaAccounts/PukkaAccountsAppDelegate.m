//
//  PukkaAccountsAppDelegate.m
//  PukkaAccounts
//
//  Created by Paul Mackinnon on 10/10/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PukkaAccountsAppDelegate.h"

@implementation PukkaAccountsAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
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

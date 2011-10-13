//
//  PukkaAccountsAppDelegate.h
//  PukkaAccounts
//
//  Created by Paul Mackinnon on 10/10/2011.
//  Copyright 2011 DJCAD, Dundee University. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "CJSONSerializer.h"
#import "CJSONDeserializer.h"

#import "TodayDatePicker.h"

#import "DataManager.h"


@interface PukkaAccountsAppDelegate : NSObject <NSApplicationDelegate> {
@private
    NSWindow *window;
  // DataManager *_dataManager;
    NSWindow *manageUsersWindow;
}

@property (assign) IBOutlet NSWindow *window;
@property (readonly) DataManager *dataManager;
@property (assign) IBOutlet NSWindow *manageUsersWindow;

- (IBAction)saveAction:sender;
- (IBAction)activatePOSwindow:(id)sender;
- (IBAction)activateManageUsersWin:(id)sender;
- (IBAction)importJSON:(id)sender;

@end

//
//  PukkaAccountsAppDelegate.h
//  PukkaAccounts
//
//  Created by Paul Mackinnon on 10/10/2011.
//  Copyright 2011 DJCAD, Dundee University. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TodayDatePicker.h"

#import "DataManager.h"

@interface PukkaAccountsAppDelegate : NSObject <NSApplicationDelegate> {
@private
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;


- (IBAction)saveAction:sender;

@end

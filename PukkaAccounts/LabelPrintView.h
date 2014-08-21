//
//  LabelPrintView.h
//  PukkaAccounts
//
//  Created by Paul Mackinnon on 02/12/2011.
//  Copyright 2011 DJCAD, Dundee University. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "User.h"


@interface LabelPrintView : NSView {
@private
    
}

-(id) initWithUser:(id)user;


@property (strong) NSString *nameString;
@property (strong) NSString *courseString;
@property (strong) NSString *matricString;
@property (strong) NSString *emailString;
@property (strong) NSMutableDictionary *attributes;

@property (assign) float lineHeight;
@property (assign) NSRect pageRect;





@end

//
//  LabelPrintView.m
//  PukkaAccounts
//
//  Created by Paul Mackinnon on 02/12/2011.
//  Copyright 2011 DJCAD, Dundee University. All rights reserved.
//

#import "LabelPrintView.h"


@implementation LabelPrintView

@synthesize nameString =_nameString;
@synthesize courseString =_courseString;
@synthesize matricString = _matricString;
@synthesize emailString = _emailString;

@synthesize attributes = _attributes;
@synthesize lineHeight = _lineHeight;
@synthesize pageRect = _pageRect;




- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


-(id)initWithUser:(User*)user {
    self = [super initWithFrame:NSMakeRect(0,0, 550, 850)];
    if (self) {
        //init code
        
        self.nameString = [NSString stringWithFormat:@"%@",[user valueForKey:@"fullName"]];
        self.courseString = [NSString stringWithString:[user valueForKey:@"subjectOfStudy"]];
        self.matricString = [NSString stringWithString:[user valueForKey:@"matricNumber"]];
        self.emailString = [NSString stringWithString:[user valueForKey:@"emailAddress"]];
        
        
        _attributes = [[NSMutableDictionary alloc] init];
        
   
        NSFont *font = [NSFont fontWithName:@"Helvetica" size:16.0];
        self.lineHeight = [font capHeight] * 1.7;
        [self.attributes setObject:font forKey:NSFontAttributeName];
        
     
        
        
        
        NSMutableParagraphStyle *paragraph = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [paragraph setAlignment:NSCenterTextAlignment];
        
        
        [self.attributes setObject:paragraph forKey:NSParagraphStyleAttributeName];
        
        
        
    
        
        
        
    }//end if
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
    [_nameString release];
    [_courseString release];
    [_matricString release];
    [_emailString release];
    [_attributes release];
    
    

}


-(BOOL)knowsPageRange:(NSRangePointer)range {
    NSPrintOperation *po = [NSPrintOperation currentOperation];
    NSPrintInfo *printInfo = [po printInfo];
    
    self.pageRect = [printInfo imageablePageBounds];
    NSRect newFrame;
    newFrame.origin = NSZeroPoint;
    newFrame.size = [printInfo paperSize];
    [self setFrame:newFrame];
    
    range->location = 1; //1st page
    range->length = 1; //only one page
    
    return YES;
    
    
}//end knows page range method




-(NSRect)rectForPage:(NSInteger)page {
    return self.pageRect;
    
}


-(BOOL)isFlipped {
    return YES;
}





- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
    
    NSRect nameRect;
    NSRect courseRect;
    NSRect matricRect;
    NSRect emailRect;
    
    nameRect.size.height = courseRect.size.height = matricRect.size.height = emailRect.size.height = self.lineHeight;
    nameRect.size.width = courseRect.size.width = matricRect.size.width = emailRect.size.width = self.pageRect.size.width;
    
    nameRect.origin.x = courseRect.origin.x = matricRect.origin.x = emailRect.origin.x = self.pageRect.origin.x;
    
    nameRect.origin.y = self.pageRect.origin.y;
    courseRect.origin.y = nameRect.origin.y + self.lineHeight; 
    matricRect.origin.y = courseRect.origin.y + self.lineHeight;
    emailRect.origin.y = matricRect.origin.y + self.lineHeight;
    
    
    
    //    NSLog(@"page height = %f\nfirst block ends at %f\n",self.pageRect.size.height,emailRect.origin.y + emailRect.size.height);
    //    NSLog(@"\ny = %f,h = %f\n",self.pageRect.origin.y,self.pageRect.size.height);
    //    NSLog(@"y = %f,h = %f",self.frame.origin.y,self.frame.size.height);
    
    
    
    while (emailRect.origin.y + emailRect.size.height <= self.pageRect.origin.y + self.pageRect.size.height){
        
        [self.nameString drawInRect:nameRect withAttributes:self.attributes];
        [self.courseString drawInRect:courseRect withAttributes:self.attributes];
        [self.matricString drawInRect:matricRect withAttributes:self.attributes];
        [self.emailString drawInRect:emailRect withAttributes:self.attributes];
        
        
        
        nameRect.origin.y += 100;
        courseRect.origin.y += 100; 
        matricRect.origin.y += 100;
        emailRect.origin.y += 100;
        
    }
    
    
    
    
    
    
}


@end

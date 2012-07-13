//
//  ReportsController.m
//  PukkaAccounts
//
//  Created by Paul Mackinnon on 06/06/2012.
//  Copyright (c) 2012 Dundee University. All rights reserved.
//

#import "ReportsController.h"

@implementation ReportsController

- (IBAction)exportReportJSON:(id)sender {

  //  NSLog(@"export ARRAY...\n%@",[self selectedObjects] );


    NSMutableArray *exportData = [NSMutableArray array]; //empty mutable array
    
    
    NSDateFormatter *jsonDateFormat = [[NSDateFormatter alloc] init];
    [jsonDateFormat setFormatterBehavior:NSDateFormatterBehavior10_4];
    [jsonDateFormat setDateStyle:NSDateFormatterShortStyle];
    [jsonDateFormat setTimeStyle:NSDateFormatterNoStyle];
    
    
    
    //generate word data for visual word cloud...
    NSMutableString *wordCloud = [NSMutableString stringWithCapacity:90000];
    
    
    
     for (id trans in [self selectedObjects]) {
         
         User *theUser = [trans valueForKey:@"user"];
         
   //      NSLog(@"date:%@\t user:%@\t year group:%@\t subject:%@\t quantity:%@\t description:%@\t cost each:%@\t amount:%@ ",[trans valueForKey:@"date"],theUser.fullName,theUser.currentYearofStudy, theUser.subjectOfStudy,[trans valueForKey:@"saleQuantity"],[trans valueForKey:@"transDescription"],[trans valueForKey:@"itemCost"],[trans valueForKey:@"creditAmount"]);
         
         
         
         //gather this data into fresh array....
         
         
         NSDictionary *theTransaction = [NSDictionary dictionaryWithObjectsAndKeys:
                                         
                                         [jsonDateFormat stringFromDate:[trans valueForKey:@"date"]],@"date",
                                       //  [trans valueForKey:@"date"],@"date",
                                         theUser.fullName,@"fullName",
                                         theUser.currentYearofStudy,@"yearGroup",
                                         theUser.subjectOfStudy,@"subject",
                                         [trans valueForKey:@"saleQuantity"],@"quantity",
                                         [trans valueForKey:@"transDescription"],@"description",
                                         [trans valueForKey:@"itemCost"],@"itemCost",
                                         [trans valueForKey:@"creditAmount"],@"amount",
                                         
                                         
                                         
                                         
                                         nil];
         
       //  NSLog(@"data to export: %@\n\n",theTransaction);
         
         
         
    //     [wordCloud appendFormat:@" %@ ",[trans valueForKey:@"transDescription"]];
        // NSLog(@"\n\n%@\n\n",[trans valueForKey:@"transDescription"]);
         
         
         [exportData addObject:theTransaction];
         
         
         
     }
    
    NSLog(@"\n\n%@\n\n",wordCloud);
    
    
    
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
    
/*  ...sample code from apple ->
    [saveJSONpanel beginSheetModalForWindow:window completionHandler:^(NSInteger result){
        if (result == NSFileHandlingPanelOKButton)
        {
            NSURL*  theFile = [panel URL];
            
            // Write the contents in the new format.
        }
    }];
*/  
    
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

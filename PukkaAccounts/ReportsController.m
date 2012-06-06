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

    NSLog(@"export ARRAY...\n%@",[self selectedObjects] );


    
     for (id trans in [self selectedObjects]) {
         
         User *theUser = [trans valueForKey:@"user"];
         
         NSLog(@"date:%@\t user:%@\t year group:%@\t subject:%@\t quantity:%@\t description:%@\t cost each:%@\t amount:%@ ",[trans valueForKey:@"date"],theUser.fullName,theUser.currentYearofStudy, theUser.subjectOfStudy,[trans valueForKey:@"saleQuantity"],[trans valueForKey:@"transDescription"],[trans valueForKey:@"itemCost"],[trans valueForKey:@"creditAmount"]);
         
         
     }
    
    
    
    
    
    NSError *error = NULL;
    
    
    NSData *theJSONData = [[CJSONSerializer serializer] serializeArray:[self selectedObjects] error:&error];
    NSLog(@"Serialization Error: %@", error);
    
    // Change the data back to a string
    NSString* theStringObject = [[NSString alloc] initWithData:theJSONData encoding:NSUTF8StringEncoding];
    
    
    NSLog(@"export JSON...\n%@",theStringObject);

    
    
    
}


@end

//
//  PDTokenField.m
//  SproutedInterface
//
//  Created by Philip Dow on 8/20/07.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//
//	Note that PDTokenField does not require PDTokenFieldCell
//

#import <SproutedInterface/PDTokenField.h>


@implementation PDTokenField

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
    if ([super performDragOperation:sender])
    {
        //NSLog(@"perform custom drag operation");
		
        if ( [self delegate] != nil && [[self delegate] respondsToSelector:@selector(tokenField:didReadTokens:fromPasteboard:)] )
			[[self delegate] tokenField:self didReadTokens:[self objectValue] fromPasteboard:[sender draggingPasteboard]];
			
        return YES;
    }
	else
	{
		return NO;
	}
}

-(NSArray *)tokenFieldCell:(NSTokenFieldCell *)tokenFieldCell readFromPasteboard:(NSPasteboard *)pboard
{
	id tokens = [super tokenFieldCell:tokenFieldCell readFromPasteboard:pboard];
		
	if ( [self delegate] != nil && [[self delegate] respondsToSelector:@selector(tokenField:didReadTokens:fromPasteboard:)] )
		[[self delegate] tokenField:self didReadTokens:tokens fromPasteboard:pboard];
		
	return tokens;
}


@end

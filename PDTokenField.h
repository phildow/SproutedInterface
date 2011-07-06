//
//  PDTokenField.h
//  SproutedInterface
//
//  Created by Philip Dow on 8/20/07.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//
//	Note that PDTokenField does not require PDTokenFieldCell
//

#import <Cocoa/Cocoa.h>


@interface PDTokenField : NSTokenField {

}

@end

@interface NSObject (PDTokenFieldDelegate)

- (void)tokenField:(PDTokenField *)tokenField didReadTokens:(NSArray*)theTokens fromPasteboard:(NSPasteboard *)pboard;

@end
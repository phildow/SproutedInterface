//
//  PDTokenFieldCell.h
//  SproutedInterface
//
//  Created by Philip Dow on 7/16/07.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//
//	Note that PDTokenFieldCell does not require PDTokenField
//

#import <Cocoa/Cocoa.h>


@interface PDTokenFieldCell : NSTokenFieldCell {

}

@end

@interface NSTokenFieldCell (SuperImplemented)

- (id) _tokensFromPasteboard:(id)fp8;

@end

@interface NSObject (PDTokenFieldCellDelegate)

- (void)tokenFieldCell:(PDTokenFieldCell *)tokenFieldCell didReadTokens:(NSArray*)theTokens fromPasteboard:(NSPasteboard *)pboard;

@end
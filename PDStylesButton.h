//
//  PDStylesButton.h
//  SproutedInterface
//
//  Created by Philip Dow on 5/1/06.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <Cocoa/Cocoa.h>

@class PDStylesButtonCell;

@interface PDStylesButton : NSButton {

}

- (int) superscriptValue;
- (void) setSuperscriptValue:(int)offset;

@end

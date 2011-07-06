//
//  SproutedEmailer.h
//  SproutedUtilities
//
//  Created by Philip Dow on 4/17/08.
//  Copyright Sprouted. All rights reserved.
//	All inquiries should be directed to developer@journler.com
//

#import <Cocoa/Cocoa.h>
#import <Message/NSMailDelivery.h>

@interface SproutedEmailer : NSObject {

}

- (BOOL)sendRichMail:(NSAttributedString *)richBody 
		to:(NSString *)to 
		subject:(NSString *)subject 
		isMIME:(BOOL)isMIME 
		withNSMail:(BOOL)wM;

@end

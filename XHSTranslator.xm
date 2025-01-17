/*
 * Copyright (c) 2025 XHSTranslator
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "translateMgr.h"

static BOOL canConnectToGoogle = YES;

%hook XYPHNoteComment

- (void)setContent:(NSString *)arg1 {
    if (!arg1) {
        %orig;
        return;
    }
    
    if (!canConnectToGoogle) {
        // NSLog(@"can't connect to google");
        %orig(arg1);
        return;
    }

    NSString *cleanedText;
    [translateMgr extractSpecialMarks:arg1 cleanedText:&cleanedText];
    
    if ([[cleanedText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        %orig(arg1);
        return;
    }
    
    if ([translateMgr isChineseText:cleanedText] && ![translateMgr isEnglishText:cleanedText]) {
        %orig(arg1);
        return;
    }
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __block NSString *translatedText = cleanedText;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        translatedText = [translateMgr translateText:cleanedText];
        dispatch_semaphore_signal(semaphore);
    });
    
    if (dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC)) != 0) {
        canConnectToGoogle = NO;
        %orig(arg1);
        return;
    }
    
    NSString *finalText = [NSString stringWithFormat:@"原文：%@\n\n翻译：%@", arg1, translatedText];
    %orig(finalText);
}

%end
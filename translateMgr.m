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
#import "translateMgr.h"

@implementation translateMgr

+ (BOOL)isChineseText:(NSString *)text {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[\\u4e00-\\u9fa5]" options:0 error:nil];
    return [regex numberOfMatchesInString:text options:0 range:NSMakeRange(0, text.length)] > 0;
}

+ (BOOL)isEnglishText:(NSString *)text {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[a-zA-Z]" options:0 error:nil];
    return [regex numberOfMatchesInString:text options:0 range:NSMakeRange(0, text.length)] > 0;
}

+ (NSArray *)extractSpecialMarks:(NSString *)text cleanedText:(NSString **)cleanedText {
    NSMutableArray *specialMarks = [NSMutableArray array];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\[[^\\]]*\\]" options:0 error:nil];
    
    NSArray *matches = [regex matchesInString:text options:0 range:NSMakeRange(0, text.length)];
    for (NSTextCheckingResult *match in [matches reverseObjectEnumerator]) {
        NSString *mark = [text substringWithRange:match.range];
        [specialMarks insertObject:@{
            @"text": mark,
            @"range": [NSValue valueWithRange:match.range]
        } atIndex:0];
    }
    
    *cleanedText = [regex stringByReplacingMatchesInString:text options:0 range:NSMakeRange(0, text.length) withTemplate:@" "];
    return specialMarks;
}

+ (NSString *)translateText:(NSString *)text {

    if ([self isChineseText:text] && ![self isEnglishText:text]) {
        return text;
    }
    
    if (![self isChineseText:text] && [self isEnglishText:text]) {
        NSString *urlString = [NSString stringWithFormat:@"https://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl=zh-CN&dt=t&q=%@",
                              [text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        
        NSURL *url = [NSURL URLWithString:urlString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setValue:@"Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1" forHTTPHeaderField:@"User-Agent"];
        
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        __block NSString *translatedText = text;
        
        [[NSURLSession.sharedSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (!error && [(NSHTTPURLResponse *)response statusCode] == 200 && data) {
                NSArray *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                if ([jsonResponse isKindOfClass:[NSArray class]] && jsonResponse.count > 0) {
                    NSArray *translations = jsonResponse[0];
                    if ([translations isKindOfClass:[NSArray class]] && translations.count > 0) {
                        NSMutableString *fullTranslation = [NSMutableString string];
                        for (NSArray *translationPart in translations) {
                            if ([translationPart isKindOfClass:[NSArray class]] && translationPart.count > 0) {
                                NSString *part = translationPart[0];
                                if ([part isKindOfClass:[NSString class]]) {
                                    [fullTranslation appendString:part];
                                }
                            }
                        }
                        if (fullTranslation.length > 0) {
                            translatedText = fullTranslation;
                        }
                    }
                }
            }
            dispatch_semaphore_signal(semaphore);
        }] resume];
        
        dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)));
        return translatedText;
    }
    
    NSMutableString *result = [NSMutableString stringWithString:text];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[a-zA-Z]+" options:0 error:nil];
    NSArray *matches = [regex matchesInString:text options:0 range:NSMakeRange(0, text.length)];
    
    for (NSTextCheckingResult *match in [matches reverseObjectEnumerator]) {
        NSString *englishPart = [text substringWithRange:match.range];
        NSString *translatedPart = [self translateText:englishPart];
        [result replaceCharactersInRange:match.range withString:translatedPart];
    }
    
    return result;
}

@end
//
// Created by BENJAMIN LISBAKKEN on 10/12/17.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface GloboStore : NSObject
+ (void)setObject:(id)object atKeyPath:(NSString *)keyPath;
+ (id)getObjectAtKeyPath:(NSString *)keyPath;
+ (RACSignal *)listenAtKeyPath:(NSString *)keyPath;
@end


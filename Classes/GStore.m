//
// Created by BENJAMIN LISBAKKEN on 10/12/17.
//

#import "GStore.h"


@implementation GloboStore
static NSMutableDictionary *store;
static NSMutableDictionary *storeSignals;

+ (void)initialize {
  [super initialize];
  store = [@{} mutableCopy];
  storeSignals = [@{} mutableCopy];
}

+ (void)setObject:(id)object atKeyPath:(NSString *)keyPath {
  NSArray <NSString *> *paths = [keyPath componentsSeparatedByString:@"."];
  NSMutableDictionary *curStoreLevel = store;
  NSMutableDictionary *curSignalLevel = storeSignals;
  for (NSUInteger i = 0; i < paths.count - 1; i++) {
    NSString *singlePath = paths[i];
    if (!curStoreLevel[singlePath]) curStoreLevel[singlePath] = [@{} mutableCopy];
    if (!curSignalLevel[singlePath]) curSignalLevel[singlePath] = [@{} mutableCopy];
    curStoreLevel = curStoreLevel[singlePath];
    curSignalLevel = curSignalLevel[singlePath];
  }
  NSString *lastPath = paths[paths.count - 1];
  curStoreLevel[lastPath] = object;
  RACSubject *keyPathSignal = curSignalLevel[lastPath];
  if (!keyPathSignal) {
    RACSubject *newSubject = [RACReplaySubject replaySubjectWithCapacity:1];
    newSubject.name = keyPath;
    curSignalLevel[lastPath] = newSubject;
    keyPathSignal = newSubject;
  }
  [keyPathSignal sendNext:object];
}

+ (id)getObjectAtKeyPath:(NSString *)keyPath {
  NSArray <NSString *> *paths = [keyPath componentsSeparatedByString:@"."];
  NSMutableDictionary *curStoreLevel = store;
  for (NSUInteger i = 0; i < paths.count - 1; i++) {
    NSString *singlePath = paths[i];
    if (curStoreLevel[singlePath]) {
      curStoreLevel = curStoreLevel[singlePath];
    } else {
      return nil;
    }
  }
  NSString *lastPath = paths[paths.count - 1];
  return curStoreLevel[lastPath];
}

// Returns a RACSignal for a keypath. If it exists return it, otherwise create one and return it.
+ (RACSignal *)listenAtKeyPath:(NSString *)keyPath {
  NSArray <NSString *> *paths = [keyPath componentsSeparatedByString:@"."];
  NSMutableDictionary *curLevel = storeSignals;
  for (NSUInteger i = 0; i < paths.count - 1; i++) {
    NSString *singlePath = paths[i];
    if (!curLevel[singlePath]) curLevel[singlePath] = [@{} mutableCopy];
    curLevel = curLevel[singlePath];
  }
  NSString *finalPath = paths[paths.count - 1];
  RACSubject *keyPathSignal = curLevel[finalPath];

  if (!keyPathSignal) {
    RACSubject *newSubject = [RACReplaySubject replaySubjectWithCapacity:1];
    newSubject.name = keyPath;
    curLevel[finalPath] = newSubject;
    keyPathSignal = newSubject;
  }

  return [keyPathSignal logAll];
}

@end


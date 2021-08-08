class Cache {
  var _cacheMap = <String, dynamic>{};

  dynamic getObject(String key) {
    return _cacheMap[key];
  }

  void addObject(String key, dynamic object) {
    _cacheMap[key] = object;
  }

  void clearCache() {
    _cacheMap.clear();
  }
}

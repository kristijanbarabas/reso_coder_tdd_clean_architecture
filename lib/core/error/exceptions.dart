// repository will catch an Exception and it will transform it into Failures and return them from the left side of the Either type
// Failures map one to one to Exceptions

class ServerException implements Exception {}

class CacheException implements Exception {}

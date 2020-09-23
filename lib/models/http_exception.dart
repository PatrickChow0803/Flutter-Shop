// Implements = Forced to implement all functions Exception has
class HttpException implements Exception {
  final String message;

  HttpException(this.message);

  @override
  String toString() {
    return message;
//    return super.toString(); // Would normally return 'Instance of HttpException'
  }
}

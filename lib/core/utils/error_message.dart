import 'dart:async';
import 'dart:io';

String friendlyErrorMessage(Object error) {
  if (error is SocketException) {
    return 'No internet connection. Please check your network and try again.';
  }

  if (error is TimeoutException) {
    return 'The request is taking too long. Please try again.';
  }

  if (error is FormatException) {
    return "Something went wrong while reading the response.";
  }

  final message = error.toString();
  if (message.startsWith('Exception: ')) {
    return message.substring('Exception: '.length);
  }

  return 'Something went wrong. Please try again.';
}
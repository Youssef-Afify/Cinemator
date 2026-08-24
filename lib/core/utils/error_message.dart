import 'dart:async';
import 'dart:io';

// Converts a caught error into a short, user-friendly message.
//
// Without this, `errorMessage = e.toString()` leaks raw exception text
// straight into the UI — e.g. a dropped connection shows up as
// "SocketException: Failed host lookup: 'api.themoviedb.org' (OS Error:
// No address associated with hostname, errno = 7)". Repositories in this
// app already throw clean, short `Exception('...')` messages for HTTP-level
// failures (see MovieRepository/GenreRepository._handleError) — this only
// needs to catch the network/platform-level exceptions that bypass that
// and reach the provider's catch block raw.
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
sealed class Failure implements Exception {
  const Failure(this.message);

  final String message;

  @override
  String toString() => message;
}

final class RoomNotFoundFailure extends Failure {
  const RoomNotFoundFailure() : super('No room found with this code');
}

final class OfflineFailure extends Failure {
  const OfflineFailure() : super('You are offline. Connect to continue');
}

final class UnexpectedFailure extends Failure {
  const UnexpectedFailure() : super('Something went wrong. Try again');
}

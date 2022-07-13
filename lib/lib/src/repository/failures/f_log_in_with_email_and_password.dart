class LogInWithEmailAndPasswordFailure implements Exception {
  const LogInWithEmailAndPasswordFailure([
    this.message = 'An unknown error occurred.',
  ]);

  factory LogInWithEmailAndPasswordFailure.fromCode(String code) {
    final List<String> failureCodesList = <String>[
      'invalid-email',
      'user-not-found',
      'wrong-password'
    ];

    if (failureCodesList.contains(code)) {
      return const LogInWithEmailAndPasswordFailure(
        'Email or password is incorrect.',
      );
    } else {
      return const LogInWithEmailAndPasswordFailure();
    }
  }

  final String message;
}

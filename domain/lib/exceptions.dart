abstract class CleanTaskException implements Exception {}

class UseCaseException implements CleanTaskException {}

class UnexpectedException implements CleanTaskException {}

class UnknowStateException implements CleanTaskException {}

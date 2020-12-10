class ValueWrapper<T> {
  const ValueWrapper(this.value);

  final T value;
}

class ActiveTaskStorageUpdateStreamWrapper extends ValueWrapper<Stream<void>> {
  ActiveTaskStorageUpdateStreamWrapper(Stream<void> stream) : super(stream);
}

class ActiveTaskStorageUpdateSinkWrapper extends ValueWrapper<Sink<void>> {
  ActiveTaskStorageUpdateSinkWrapper(Sink<void> sink) : super(sink);
}

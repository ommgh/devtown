import 'package:fpdart/fpdart.dart';

import 'failure.dart';

typedef FuturEither<T> = Future<Either<Failure, T>>;
typedef FuturEitherVoid = FuturEither<void>;

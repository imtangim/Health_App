import 'package:fpdart/fpdart.dart';
import 'package:health_app/extra/failure.dart';


typedef FutureEither<T> = Future<Either<Failure, T>>;

typedef Futurevoid = FutureEither<void>;

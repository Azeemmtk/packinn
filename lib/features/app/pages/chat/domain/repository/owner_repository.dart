import 'package:dartz/dartz.dart';
import 'package:packinn/core/error/failures.dart';

abstract class OwnerRepository {
  Future<Either<Failure, Map<String, String>>> getOwnerDetails(String ownerId);
}
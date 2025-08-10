import 'package:dartz/dartz.dart';

import '../../../../../../core/error/failures.dart';
import '../../../home/domain/entity/hostel_entity.dart';

abstract class HostelSearchRepository {
  Future<Either<Failure, List<HostelEntity>>> searchHostels(String query);
}
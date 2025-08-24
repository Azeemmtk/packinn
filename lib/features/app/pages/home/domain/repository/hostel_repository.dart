import 'package:dartz/dartz.dart';
import '../../../../../../core/error/failures.dart';
import '../../../../../../core/entity/hostel_entity.dart';

abstract class HostelRepository{
  Future<Either<Failure, List<HostelEntity>>> getHostelData();

}
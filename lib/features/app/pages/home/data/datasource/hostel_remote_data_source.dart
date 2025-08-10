import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../../../../../core/error/failures.dart';
import '../../domain/entity/hostel_entity.dart';
import '../model/hostel_model.dart';

abstract class HostelRemoteDataSource {
  Future<Either<Failure, List<HostelEntity>>> getHostelData();
}

class HostelRemoteDataSourceImpl implements HostelRemoteDataSource {
  final FirebaseFirestore firestore;

  HostelRemoteDataSourceImpl(this.firestore);

  @override
  Future<Either<Failure, List<HostelEntity>>> getHostelData() async {
    try {
      final querySnapshot = await firestore.collection('hostels').get();
      final hostels = querySnapshot.docs
          .map((doc) => HostelModel.fromJson(doc.data()).toEntity())
          .toList();
      return Right(hostels);
    } catch (e) {
      return Left(ServerFailure('Failed to fetch hostels: $e'));
    }
  }

}

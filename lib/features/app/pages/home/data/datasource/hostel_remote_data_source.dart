import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../../../../../core/error/failures.dart';
import '../../../../../../core/entity/hostel_entity.dart';
import '../../../../../../core/model/hostel_model.dart';

abstract class HostelRemoteDataSource {
  Future<Either<Failure, List<HostelEntity>>> getHostelData();
}

class HostelRemoteDataSourceImpl implements HostelRemoteDataSource {
  final FirebaseFirestore firestore;

  HostelRemoteDataSourceImpl(this.firestore);

  @override
  Future<Either<Failure, List<HostelEntity>>> getHostelData() async {
    try {
      final querySnapshot = await firestore
          .collection('hostels')
          .where('status', isEqualTo: 'approved')
          .get();

      final hostels = querySnapshot.docs
          .map((doc) => HostelModel.fromJson(doc.data()).toEntity())
          .toList()
        ..sort((a, b) {
          // Handle null ratings by placing them at the end
          if (a.rating == null && b.rating == null) return 0;
          if (a.rating == null) return 1;
          if (b.rating == null) return -1;
          return b.rating!.compareTo(a.rating!);
        });

      return Right(hostels);
    } catch (e) {
      return Left(ServerFailure('Failed to fetch hostels: $e'));
    }
  }
}

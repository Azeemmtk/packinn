import 'package:dartz/dartz.dart';
import 'package:packinn/core/error/exceptions.dart';
import 'package:packinn/core/error/failures.dart';
import 'package:packinn/features/app/pages/wallet/data/datasourse/occupant_edit_remote_data_source.dart';
import '../../domain/repository/payment_repository.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final OccupantEditRemoteDataSource remoteDataSource;

  PaymentRepositoryImpl(this.remoteDataSource);



  @override
  Future<Either<Failure, void>> updateOccupant(String occupantId, String hostelId, String roomId) async {
    try {
      await remoteDataSource.updateOccupant(occupantId, hostelId, roomId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
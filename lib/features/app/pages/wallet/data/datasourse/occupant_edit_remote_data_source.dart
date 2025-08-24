import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../../core/error/exceptions.dart';

abstract class OccupantEditRemoteDataSource {
  Future<void> updateOccupant(String occupantId, String hostelId, String roomId);
}

class OccupantEditRemoteDataSourceImpl extends OccupantEditRemoteDataSource{

  final FirebaseFirestore firestore;

  OccupantEditRemoteDataSourceImpl(this.firestore);

  @override
  Future<void> updateOccupant(String occupantId, String hostelId, String roomId) async {
    try {
      await firestore.collection('occupants').doc(occupantId).update({
        'hostelId': hostelId,
        'roomId': roomId,
      });
    } catch (e) {
      throw ServerException('Failed to update occupant: $e');
    }
  }
  
}
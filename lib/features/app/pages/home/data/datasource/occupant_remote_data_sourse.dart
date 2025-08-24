import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:packinn/core/error/exceptions.dart';
import 'package:packinn/core/entity/occupant_entity.dart';

import '../../../../../../core/model/occupants_model.dart';

abstract class OccupantRemoteDataSource {
  Future<void> saveOccupant(OccupantEntity occupant);
  Future<List<OccupantEntity>> fetchOccupants(String userId);
  Future<void> deleteOccupant(String occupantId);
}

class OccupantRemoteDataSourceImpl extends OccupantRemoteDataSource {
  final FirebaseFirestore firestore;

  OccupantRemoteDataSourceImpl(this.firestore);

  @override
  Future<void> saveOccupant(OccupantEntity occupant) async {
    try {
      final occupantModel = OccupantModel.fromEntity(occupant);
      final data = occupantModel.toJson();
      if (occupant.id != null) {
        // Update existing document, preserving existing fields if not provided
        await firestore
            .collection('occupants')
            .doc(occupant.id)
            .set(data, SetOptions(merge: true));
      } else {
        // Create new document
        final docRef = await firestore.collection('occupants').add(data);
        await docRef.update({'id': docRef.id});
      }
    } catch (e) {
      throw ServerException('Failed to save occupant: $e');
    }
  }

  @override
  Future<List<OccupantEntity>> fetchOccupants(String userId) async {
    try {
      final querySnapshot = await firestore
          .collection('occupants')
          .where('userId', isEqualTo: userId)
          .get();
      return querySnapshot.docs
          .map((doc) => OccupantModel.fromJson({
        ...doc.data(),
        'id': doc.id,
      }).toEntity())
          .toList();
    } catch (e) {
      throw ServerException('Failed to fetch occupants: $e');
    }
  }

  @override
  Future<void> deleteOccupant(String occupantId) async {
    try {
      await firestore.collection('occupants').doc(occupantId).delete();
    } catch (e) {
      throw ServerException('Failed to delete occupant: $e');
    }
  }
}
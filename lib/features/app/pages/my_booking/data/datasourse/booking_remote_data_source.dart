import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:packinn/core/model/hostel_model.dart';

import '../../../../../../core/error/exceptions.dart';
import '../../../../../../core/model/occupants_model.dart'; // From hostel_model.dart

abstract class BookingRemoteDataSource {
  Future<List<OccupantModel>> getMyOccupants(String userId);
  Future<HostelModel> getHostelById(String hostelId);
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final FirebaseFirestore firestore;

  BookingRemoteDataSourceImpl(this.firestore);

  @override
  Future<List<OccupantModel>> getMyOccupants(String userId) async {
    final query = firestore.collection('occupants').where('userId', isEqualTo: userId);
    final snapshot = await query.get();
    return snapshot.docs.map((doc) {
      final model = OccupantModel.fromJson(doc.data());
      model.id = doc.id;
      return model;
    }).toList();
  }

  @override
  Future<HostelModel> getHostelById(String hostelId) async {
    final doc = await firestore.collection('hostels').doc(hostelId).get();
    if (!doc.exists) {
      throw const ServerException('Hostel not found');
    }
    return HostelModel.fromJson(doc.data()!);
  }
}
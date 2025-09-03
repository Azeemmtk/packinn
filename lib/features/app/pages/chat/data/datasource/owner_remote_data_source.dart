import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:packinn/core/error/exceptions.dart';


abstract class OwnerRemoteDataSource {
  Future<Map<String, String>> getOwnerDetails(String ownerId);
}

class OwnerRemoteDataSourceImpl implements OwnerRemoteDataSource {
  final FirebaseFirestore firestore;

  OwnerRemoteDataSourceImpl(this.firestore);

  @override
  Future<Map<String, String>> getOwnerDetails(String ownerId) async {
    try {
      final ownerDoc = await firestore.collection('hostel_owners').doc(ownerId).get();
      if (!ownerDoc.exists) {
        throw ServerException('Hostel owner not found');
      }
      // Use exact field names from Firestore and provide fallbacks
      final data = ownerDoc.data() as Map<String, dynamic>;
      return {
        'displayName': data['displayName']?.toString() ?? 'Unknown',
        'photoURL': data['photoURL']?.toString() ?? '', // Correct field name: photoURL
      };
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
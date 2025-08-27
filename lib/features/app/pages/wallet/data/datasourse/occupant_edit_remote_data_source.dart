import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../../core/error/exceptions.dart';

abstract class OccupantEditRemoteDataSource {
  Future<void> updateOccupant(
      String occupantId, String hostelId, String roomId, String roomType);
}

class OccupantEditRemoteDataSourceImpl extends OccupantEditRemoteDataSource {
  final FirebaseFirestore firestore;

  OccupantEditRemoteDataSourceImpl(this.firestore);

  @override
  Future<void> updateOccupant(String occupantId, String hostelId, String roomId,
      String roomType) async {
    try {
      // Step 1: Update occupant data
      await firestore.collection('occupants').doc(occupantId).update({
        'hostelId': hostelId,
        'roomId': roomId,
        'roomType': roomType,
      });

      // Step 2: Add occupantId to hostel
      await firestore.collection('hostels').doc(hostelId).update({
        'occupantsId': FieldValue.arrayUnion([occupantId]),
      });

      // Step 3: Fetch hostel document
      final hostelDoc =
          await firestore.collection('hostels').doc(hostelId).get();

      if (!hostelDoc.exists) {
        throw Exception('Hostel not found');
      }

      final data = hostelDoc.data() as Map<String, dynamic>;
      List<dynamic> rooms = data['rooms'] ?? [];

      // Step 4: Find the room and decrement count
      List<Map<String, dynamic>> updatedRooms = rooms.map((room) {
        if (room['roomId'] == roomId) {
          int currentCount = room['count'] ?? 0;
          if (currentCount > 0) {
            room['count'] = currentCount - 1;
          }
        }
        return Map<String, dynamic>.from(room);
      }).toList();

      // Step 5: Update the rooms array back to Firestore
      await firestore.collection('hostels').doc(hostelId).update({
        'rooms': updatedRooms,
      });
    } catch (e) {
      throw ServerException('Failed to update occupant: $e');
    }
  }
}

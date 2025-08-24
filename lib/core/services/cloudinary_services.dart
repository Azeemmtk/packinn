import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import '../constants/cloudinary.dart';
import '../error/exceptions.dart';

class CloudinaryService{

  final CloudinaryPublic _cloudinary;
  CloudinaryService() : _cloudinary = CloudinaryPublic(cloudName, uploadPreset);

  Future<List<Map<String , String>>> uploadImage(List<File?> images) async{
    try{
      final List<Map<String, String>> result= [];
      for(final image in images.where((im) => im != null,)){
        final response= await _cloudinary.uploadFile(CloudinaryFile.fromFile(
          image!.path,
          resourceType: CloudinaryResourceType.Image,
          folder: 'hostels',
        ));
        result.add({
          'secureUrl': response.secureUrl,
          'publicId':response.publicId,
        }
        );
      }
      return result;
    } catch (e){
      throw ServerException('Failed to upload image to cloudinary: $e');
    }
  }
}
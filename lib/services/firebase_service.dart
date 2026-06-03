import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../models/story_model.dart';
import '../models/video_project_model.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> saveStory(String userId, StoryModel story) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('stories')
        .doc(story.id)
        .set(story.toJson());
  }

  Future<List<StoryModel>> getUserStories(String userId) async {
    final snapshot = await _db
        .collection('users')
        .doc(userId)
        .collection('stories')
        .orderBy('createdAt', descending: true)
        .limit(20)
        .get();

    return snapshot.docs
        .map((doc) => StoryModel.fromJson(doc.data()))
        .toList();
  }

  Future<String> uploadVideo(String userId, String localPath) async {
    final file = File(localPath);
    final fileName = localPath.split('/').last;
    final ref = _storage.ref('users/$userId/videos/$fileName');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  Future<void> saveVideoProject(VideoProjectModel project) async {
    await _db
        .collection('videos')
        .doc(project.id)
        .set(project.toJson());
  }
}

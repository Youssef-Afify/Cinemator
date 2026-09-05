import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task/features/admin/data/admin_movie_model.dart';

/// Data-access layer for the `movies` Firestore collection.
class AdminMovieRepository {
  final CollectionReference<Map<String, dynamic>> _col =
      FirebaseFirestore.instance.collection('movies');

  Stream<List<AdminMovieModel>> watchMovies() {
    return _col
        .orderBy('id', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map(
                (doc) => AdminMovieModel.fromFirestore(
                  doc as DocumentSnapshot<Map<String, dynamic>>,
                ),
              )
              .toList(),
        );
  }

  Future<void> addMovie(AdminMovieModel movie) async {
    final docRef = _col.doc(); // auto-generated ID
    final data = movie.toFirestore();
    data['id'] = DateTime.now().millisecondsSinceEpoch;
    await docRef.set(data);
  }

  /// Updates an existing movie document (identified by [AdminMovieModel.docId]).
  Future<void> updateMovie(AdminMovieModel movie) async {
    await _col.doc(movie.docId).update(movie.toFirestore());
  }

  /// Deletes a movie document.
  Future<void> deleteMovie(String docId) async {
    await _col.doc(docId).delete();
  }
}

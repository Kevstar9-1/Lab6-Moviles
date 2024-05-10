import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_admin_dashboard/models/recent_user_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Método para obtener todos los usuarios recientes
  Future<List<RecentUser>> getAllRecentUsers() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('Users').get();
      return querySnapshot.docs.map((doc) {
        return RecentUser(
          name: doc['name'],
          email: doc['email'],
          date: doc['date'],
          posts: doc['status'],
        );
      }).toList();
    } catch (e) {
      // Manejo de errores si es necesario
      print("Error al obtener usuarios recientes: $e");
      return []; // Retorna una lista vacía en caso de error
    }
  }
}

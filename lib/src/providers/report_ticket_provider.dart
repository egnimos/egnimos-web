import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egnimos/main.dart';
import 'package:egnimos/src/models/report_ticket.dart';
import 'package:flutter/cupertino.dart';

class ReportTicketProvider with ChangeNotifier {
  List<ReportTicket> _tickets = [];
  List<ReportTicket> get tickets => _tickets;

  static const ticketCollection = "ticket_collection";

  //report ticket
  Future<void> reportTicket(ReportTicket ticket) async {
    try {
      await firestoreInstance
          .collection(ticketCollection)
          .doc(ticket.id)
          .set(ticket.toJson());
      _tickets.add(ticket);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  //delete ticket
  Future<void> deleteTicket(String ticketId) async {
    try {
      await firestoreInstance
          .collection(ticketCollection)
          .doc(ticketId)
          .delete();
      _tickets.removeWhere((e) => e.id == ticketId);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  //get tickets
  Future<void> getTickets(DocumentSnapshot? lastDoc) async {
    try {
      final response = lastDoc != null
          ? await firestoreInstance
              .collection(ticketCollection)
              .orderBy("created_at", descending: true)
              .startAfterDocument(lastDoc)
              .limit(40)
              .get()
          : await firestoreInstance
              .collection(ticketCollection)
              .orderBy("created_at", descending: true)
              .limit(40)
              .get();
      List<ReportTicket> result = [..._tickets];
      for (var doc in response.docs) {
        result.add(ReportTicket.fromJson(
          doc.data(),
        ));
      }
      _tickets = result;
      notifyListeners();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  //get user tickets
  Future<void> getUserTickets(DocumentSnapshot? lastDoc, String userId) async {
    try {
      final response = lastDoc != null
          ? await firestoreInstance
              .collection(ticketCollection)
              .where(
                "user_info.id",
                isEqualTo: userId,
              )
              .orderBy("created_at", descending: true)
              .startAfterDocument(lastDoc)
              .limit(40)
              .get()
          : await firestoreInstance
              .collection(ticketCollection)
              .where(
                "user_info.id",
                isEqualTo: userId,
              )
              .orderBy("created_at", descending: true)
              .limit(40)
              .get();
      List<ReportTicket> result = [..._tickets];
      for (var doc in response.docs) {
        result.add(ReportTicket.fromJson(
          doc.data(),
        ));
      }
      _tickets = result;
      notifyListeners();
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}

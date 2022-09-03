public without sharing class ExternalSystemService {
  public static void registerAttendees(Case reservation) {
    for (Account account : [
      SELECT id, (SELECT Name, Email FROM Contacts)
      FROM Account
      WHERE id = :reservation.AccountId
    ]) {
      for (Contact contact : account.Contacts) {
        HttpService.registerAttendee(contact.Name, contact.Email);
      }
    }
  }
}

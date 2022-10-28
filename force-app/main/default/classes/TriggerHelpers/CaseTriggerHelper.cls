public class CaseTriggerHelper {
  private static final String CLOSED = 'Closed';

  public static void updateRelatedContacts(List<Case> reservations) {
    Set<Id> accountIds = getAccountIdsForClosedReservations(reservations);
    List<Contact> contacts = [
      SELECT Name, Email
      FROM Contact
      WHERE AccountId IN :accountIds
    ];
    for (Contact contact : contacts) {
      contact.NotifyExternalSystem__c = true;
    }
    update contacts;
  }

  public static void validateReservation(List<Case> reservations) {
    Map<Id, Set<Case>> accoutIdToCases = getAccountIdToCases(reservations);
    Set<Id> accountIds = accoutIdToCases.keySet();
    List<Account> accounts = [
      SELECT Id, Name, (SELECT id FROM Contacts)
      FROM Account
      WHERE Id IN :accountIds
    ];
    for (Account account : accounts) {
      Integer numberOfContacts = account.Contacts.size();
      Set<Case> accountReservations = accoutIdToCases.get(account.Id);
      if (numberOfContacts == 0) {
        for (Case reservation : accountReservations) {
          reservation.addError(
            Label.YouCanNotCreateARequestForAccountWithoutAccount
          );
        }
      } else {
        for (Case reservation : accountReservations) {
          if ('Web'.equals(reservation.Origin) && numberOfContacts >= 2) {
            reservation.addError(
              Label.WebRequestAreOnlyAllowedToHaveOneAttendee
            );
          } else if (
            'Phone'.equals(reservation.Origin) && numberOfContacts >= 4
          ) {
            reservation.addError(
              Label.PhoneRequestAreOnlyAllowedToHaveThreeAttendee
            );
          }
        }
      }
    }
  }

  private static Map<Id, Set<Case>> getAccountIdToCases(
    List<Case> reservations
  ) {
    Map<Id, Set<Case>> accountIdToCases = new Map<Id, Set<Case>>();
    for (Case reservation : reservations) {
      if (reservation.AccountId != null) {
        Id accountId = reservation.AccountId;
        if (accountIdToCases.containsKey(accountId)) {
          accountIdToCases.get(accountId).add(reservation);
        } else {
          accountIdToCases.put(accountId, new Set<Case>{ reservation });
        }
      } else {
        reservation.addError(
          Label.YouCannotCreateARequestWithoutAttachingAnAccount
        );
      }
    }
    return accountIdToCases;
  }

  private static Set<Id> getAccountIdsForClosedReservations(
    List<Case> reservations
  ) {
    Set<Id> accountsIds = new Set<Id>();
    for (Case reservation : reservations) {
      if (CLOSED.equals(reservation.Status)) {
        if (reservation.AccountId != null) {
          accountsIds.add(reservation.AccountId);
        }
      }
    }
    return accountsIds;
  }
}

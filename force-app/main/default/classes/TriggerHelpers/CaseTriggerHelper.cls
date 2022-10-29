public class CaseTriggerHelper {
  private static final String WEB = 'Web';
  private static final String PHONE = 'Phone';

  public static void updateRelatedContacts(
    Map<Id, Case> oldIdToCase,
    List<Case> updatedCases
  ) {
    Set<Id> accountsIds = CaseUtils.getAccountsIdsForClosedCases(
      oldIdToCase,
      updatedCases
    );
    List<Contact> contacts = [
      SELECT Name, Email
      FROM Contact
      WHERE AccountId IN :accountsIds
    ];
    if (!contacts.isEmpty()) {
      for (Contact contact : contacts) {
        contact.NotifyExternalSystem__c = true;
      }
      update contacts;
    }
  }

  public static void validateCases(List<Case> cases) {
    Map<Id, Set<Case>> accoutIdToCases = CaseUtils.getAccountIdToCases(cases);
    Set<Id> accountIds = accoutIdToCases.keySet();
    List<Account> accounts = [
      SELECT Id, Name, (SELECT id FROM Contacts)
      FROM Account
      WHERE Id IN :accountIds
    ];
    for (Account account : accounts) {
      Integer numberOfContacts = account.Contacts.size();
      Set<Case> accountCases = accoutIdToCases.get(account.Id);
      for (Case accountCase : accountCases) {
        if (numberOfContacts == 0) {
          accountCase.addError(
            Label.YouCanNotCreateARequestForAccountWithoutAccount
          );
        } else if (WEB.equals(accountCase.Origin) && numberOfContacts >= 2) {
          accountCase.addError(Label.WebRequestAreOnlyAllowedToHaveOneAttendee);
        } else if (PHONE.equals(accountCase.Origin) && numberOfContacts >= 4) {
          accountCase.addError(
            Label.PhoneRequestAreOnlyAllowedToHaveThreeAttendee
          );
        }
      }
    }
  }
}

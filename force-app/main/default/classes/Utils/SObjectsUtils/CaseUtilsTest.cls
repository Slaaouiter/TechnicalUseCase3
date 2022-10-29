@isTest
private class CaseUtilsTest {
  @isTest
  public static void getAccountIdToCases() {
    //Given
    Account salesforce = (Account) TestDataFactory.createSObject(
      'Account',
      new Map<String, Object>{ 'Name' => 'Salesforce' }
    );
    Account altice = (Account) TestDataFactory.createSObject(
      'Account',
      new Map<String, Object>{ 'Name' => 'Altice' }
    );

    Case salesforce1Case = new Case(
      Origin = 'Phone',
      Subject = 'Event Booking',
      Description = 'Book Spots for Salesforce Company & their employees',
      AccountId = salesforce.Id
    );
    Case caseWithoutAccount = new Case(
      Origin = 'Phone',
      Subject = 'Event Booking',
      Description = 'Book Spots for employees'
    );
    Case altice1Case = new Case(
      Origin = 'Web',
      Subject = 'Event Booking',
      Description = 'Book Spots for Altice Company & their employees',
      AccountId = altice.Id
    );
    Case altice2Case = new Case(
      Origin = 'Phone',
      Subject = 'Event Booking',
      Description = 'Book Spots for Altice Company & their employees',
      AccountId = altice.Id
    );

    //When
    Map<Id, Set<Case>> accountIdToCases = CaseUtils.getAccountIdToCases(
      new List<Case>{
        altice1Case,
        altice2Case,
        salesforce1Case,
        caseWithoutAccount
      }
    );

    //Then
    Set<Id> accountsIds = accountIdToCases.keySet();
    System.assert(accountsIds.size() == 2);
    System.assert(accountsIds.contains(salesforce.Id));
    System.assert(accountsIds.contains(altice.Id));

    Set<Case> salesforceCases = accountIdToCases.get(salesforce.Id);
    System.assert(salesforceCases.size() == 1);
    System.assert(salesforceCases.contains(salesforce1Case));

    Set<Case> alticeCases = accountIdToCases.get(altice.Id);
    System.assert(alticeCases.size() == 2);
    System.assert(alticeCases.contains(altice1Case));
    System.assert(alticeCases.contains(altice2Case));

    System.assert(caseWithoutAccount.getErrors().size() > 0);
    Database.Error error = caseWithoutAccount.getErrors().get(0);
    System.assert(
      Label.YouCannotCreateARequestWithoutAttachingAnAccount.equals(
        error.message
      )
    );
  }

  @isTest
  public static void getAccountsIdsForClosedCases() {
    //Given
    Account salesforce = (Account) TestDataFactory.createSObject(
      'Account',
      new Map<String, Object>{ 'Name' => 'Salesforce' }
    );
    Account altice = (Account) TestDataFactory.createSObject(
      'Account',
      new Map<String, Object>{ 'Name' => 'Altice' }
    );
    Account inwi = (Account) TestDataFactory.createSObject(
      'Account',
      new Map<String, Object>{ 'Name' => 'Inwi' }
    );

    Case salesforce1Case = new Case(
      Origin = 'Phone',
      Subject = 'Event Booking',
      Description = 'Book Spots for Salesforce Company & their employees',
      AccountId = salesforce.Id,
      Status = 'Escalated'
    );
    Case altice1Case = new Case(
      Origin = 'Web',
      Subject = 'Event Booking',
      Description = 'Book Spots for Salesforce Company & their employees',
      AccountId = altice.Id,
      Status = 'Escalated'
    );
    Case altice2Case = new Case(
      Origin = 'Phone',
      Subject = 'Event Booking',
      Description = 'Book Spots for Altice Company & their employees',
      AccountId = altice.Id,
      Status = 'Working'
    );
    Case inwi1Case = new Case(
      Origin = 'Phone',
      Subject = 'Event Booking',
      Description = 'Book Spots for Inwi Company & their employees',
      AccountId = inwi.Id,
      Status = 'Working'
    );

    //When
    Case altice1CaseUpdated = altice1Case.clone();
    altice1CaseUpdated.Status = 'Closed';

    Case altice2CaseUpdated = altice2Case.clone();
    altice2CaseUpdated.Status = 'Closed';

    Case salesforce1CaseUpdated = salesforce1Case.clone();
    salesforce1CaseUpdated.Status = 'Closed';

    Case inwi1CaseUpdated = inwi1Case.clone();
    inwi1CaseUpdated.Description = 'VIP CLIENT';

    Map<Id, Case> oldIdToCase = new Map<Id, Case>();
    oldIdToCase.put(altice1Case.Id, altice1Case);
    oldIdToCase.put(altice2Case.Id, altice2Case);
    oldIdToCase.put(salesforce1Case.Id, salesforce1Case);
    oldIdToCase.put(inwi1Case.Id, inwi1Case);

    List<Case> updatedCases = new List<Case>{
      altice1CaseUpdated,
      altice2CaseUpdated,
      salesforce1CaseUpdated,
      inwi1CaseUpdated
    };

    Set<Id> accountsIds = CaseUtils.getAccountsIdsForClosedCases(
      oldIdToCase,
      updatedCases
    );

    //Then
    System.assert(accountsIds.size() == 2);
    System.assert(accountsIds.contains(altice.Id));
    System.assert(accountsIds.contains(salesforce.Id));
    System.assert(!accountsIds.contains(inwi.Id));
  }
}

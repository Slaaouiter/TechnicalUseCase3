@isTest
private without sharing class EmailServiceTest {
  @isTest
  public static void sendEmail() {
    //Given
    String name = 'Ahmed';
    String email = 'oualidslaaouiter@gmail.com';

    //When
    Test.startTest();
    EmailService.sendEmail(name, email);
    Integer invocations = Limits.getEmailInvocations();
    Test.stopTest();

    //Then
    System.assert(invocations == 1, 'An email should be sent to the contact');
  }
}

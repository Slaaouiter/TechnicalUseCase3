@isTest
private without sharing class HttpServiceTest {
  @isTest
  public static void registerAttendee() {
    //Given
    Test.setMock(HttpCalloutMock.class, new ReservationCalloutMock(200));
    String name = 'Asmae';
    String email = 'asmae@test.com';

    //When
    Test.startTest();
    HttpResponse response = HttpService.callExternalReservationSystem(
      name,
      email
    );
    Test.stopTest();

    //Then
    System.assertEquals(
      200,
      response.getStatusCode(),
      'Should return 200 same as the mock'
    );
  }
}

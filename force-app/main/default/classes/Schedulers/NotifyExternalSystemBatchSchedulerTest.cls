@isTest
private class NotifyExternalSystemBatchSchedulerTest {
  @isTest
  public static void testNotifyExternalSystemBatchScheduler() {
    //Given
    String CRON_EXP = '0 0 0 1 8 ? 2023';

    Test.startTest();

    //When
    String jobId = System.schedule(
      'Notify External System',
      CRON_EXP,
      new NotifyExternalSystemBatchScheduler()
    );

    //Then
    CronTrigger cronTrigger = [
      SELECT Id, CronExpression, TimesTriggered, NextFireTime
      FROM CronTrigger
      WHERE id = :jobId
    ];
    System.assertEquals(CRON_EXP, cronTrigger.CronExpression);
    System.assertEquals(
      '2023-08-01 00:00:00',
      String.valueOf(cronTrigger.NextFireTime)
    );
    Test.stopTest();
  }
}

public class NotifyExternalSystemBatchJob implements Database.Batchable<sObject>, Database.AllowsCallouts {
  public Database.QueryLocator start(Database.BatchableContext BC) {
    String soqlQuery = 'Select Name, Email From Contact Where NotifyExternalSystem__c = true';
    return Database.getQueryLocator(soqlQuery);
  }
  public void execute(Database.BatchableContext BC, List<Contact> contacts) {
    HttpUtils.notifyExternalSystem(contacts);
    update contacts;
  }
  public void finish(Database.BatchableContext BC) {
    SendEmailBatchJob batch = new SendEmailBatchJob();
    Id jobId = Database.executeBatch(batch, 100);
  }
}

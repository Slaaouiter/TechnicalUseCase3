public class SendEmailBatchJob implements Database.Batchable<sObject> {
  public Database.QueryLocator start(Database.BatchableContext BC) {
    String soqlQuery = 'Select Name, Email From Contact Where SendEmail__c = true';
    return Database.getQueryLocator(soqlQuery);
  }
  public void execute(Database.BatchableContext BC, List<Contact> contacts) {
    EmailUtils.sendEmails(contacts);
    update contacts;
  }
  public void finish(Database.BatchableContext BC) {
  }
}

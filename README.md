For avoiding many callout while updating case records.

2 new fields were added to the Contact Object

- SendEmail__c
- NotifyExternalSystem__c

For this to work, the NotifyExternalSystemBatchJob need to be scheduled every x minutes.

- Example : System.schedule('NotifyExternalSystemBatchScheduler every 10 minutes', '0 10 \* \* \* ?', new NotifyExternalSystemBatchScheduler());

The nominal scenario workflow is as follows :
1)Trigger after update will set NotifyExternalSystem__c to true if case was closed.
2)NotifyExternalSystemBatchJob will notify external system via callout, set NotifyExternalSystem__c to false, set SendEmail__c to true and execute SendEmailBatchJob.
3)SendEmailBatchJob will send email to attendees and set SendEmail__c to false.

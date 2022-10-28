public class NotifyExternalSystemBatchScheduler implements Schedulable {
  public void execute(SchedulableContext sc) {
    NotifyExternalSystemBatchJob notifyExternalSystemBatchJob = new NotifyExternalSystemBatchJob();
    database.executebatch(notifyExternalSystemBatchJob);
  }
}

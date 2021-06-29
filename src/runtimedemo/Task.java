package runtimedemo;

public class Task {

  private volatile Thread workingThread;

  public Task() {
    this.workingThread = null;
  }

  public void run() {

    this.workingThread = Thread.currentThread();

    while (!this.workingThread.isInterrupted()) {
      try {
        System.out.println("The available processors are: "+Runtime.getRuntime().availableProcessors());
        Thread.sleep(2000);
      } catch (InterruptedException ex) {
        this.workingThread.interrupt();
      }
    }
  }
}

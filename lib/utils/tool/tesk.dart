import 'dart:async';
import 'dart:math';

// 任务分配函数
List<Map<String, String>> assignTasks(Map<String, List<String>> input) {
  List<Map<String, String>> assignments = [];
  List<String> users = input['user'] ?? [];
  List<String> tasks = input['task'] ?? [];
  int userCount = users.length;
  int taskCount = tasks.length;
  if (userCount == 0 || taskCount == 0) {
    return assignments;
  }
  int baseTaskCount = taskCount ~/ userCount;
  int remainingTasks = taskCount % userCount;
  int taskIndex = 0;
  for (int i = 0; i < userCount; i++) {
    for (int j = 0; j < baseTaskCount; j++) {
      assignments.add({'user': users[i], 'task': tasks[taskIndex]});
      taskIndex++;
    }
  }
  Random random = Random();
  while (remainingTasks > 0) {
    int randomUserIndex = random.nextInt(userCount);
    assignments.add({'user': users[randomUserIndex], 'task': tasks[taskIndex]});
    taskIndex++;
    remainingTasks--;
  }
  return assignments;
}

Future<int> randomDelay(int minSeconds, int maxSeconds) async {
  int minMilliseconds = minSeconds * 1000;
  int maxMilliseconds = maxSeconds * 1000;
  final random = Random();
  int delayMilliseconds =
      minMilliseconds + random.nextInt(maxMilliseconds - minMilliseconds + 1);
  await Future.delayed(Duration(milliseconds: delayMilliseconds));
  return (delayMilliseconds / 1000).round();
}

// ValueNotifier 用于外部终止控制
class ValueNot<T> {
  T value;
  ValueNot(this.value);
}

// 任务通用处理函数
Future<void> processTasks({
  required List<Map<String, String>> taskList,
  required Function(int index, Map<String, String>) doSomething,
  required Function() onTerminate,
  required Function() onFinish,
  required Function(int t) onAwait,
  required Function(Exception) onError, // 异常处理回调
  required int minDelaySeconds,
  required int maxDelaySeconds,
  required ValueNot<bool> terminateNotifier,
}) async {
  try {
    for (int i = 0; i < taskList.length; i++) {
      if (terminateNotifier.value) {
        onTerminate();
        return;
      }
      var assignment = taskList[i];
      doSomething(i, assignment);
      if (i < taskList.length - 1) {
        int time = await randomDelay(minDelaySeconds, maxDelaySeconds);
        onAwait(time);
      }
    }
    onFinish();
  } catch (e) {
    onError(e as Exception);
  }
}

[] retry
Future<void> getFcmToken() async {
  int retryCount = 0;
  while (retryCount < 3) {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        print('FCM Token: $token');
        return;
      }
    } catch (e) {
      print('Failed to get token: $e');
      await Future.delayed(Duration(seconds: 2));
    }
    retryCount++;
  }
}


import 'dart:convert';
import 'package:bill_payment/screens/auth/signin_screen.dart';
import 'package:bill_payment/screens/notification/notification_service.dart';
import 'package:bill_payment/utils/app_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PusherController extends GetxController {
  bool isLoading = false;
  bool isScreenLoading = true;
  bool isError = false;
  String errorMessage = '';

  // push notification -------------------------------------------------------------------------------------------------
  List<Message> notificationList = [];
  final box = GetStorage();
  PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
  NotificationService notificationService = NotificationService();
  PusherConfig? pusherConfig;

  bool isNotificationVisible = true;

  @override
  void onInit() {
    super.onInit();
    fetchPusherConfig();
    List<dynamic> storedMessages = box.read('messages') ?? [];
    notificationList = storedMessages.map((map) => Message.fromMap(map)).toList();
  }

  Future<void> loadNotificationVisibility() async {
    final prefs = await SharedPreferences.getInstance();
    isNotificationVisible = prefs.getBool('isNotificationVisible') ?? false;
    update();
  }

  Future<void> saveNotificationVisibility(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isNotificationVisible', value);
    update();
  }

  // getting payment options and bill preview data
  Future<void> fetchPusherConfig() async {
    final prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString(AppConstants.token);
    isScreenLoading = true;
    isLoading = true;
    update();

    try {
      String apiUrl = '${AppConstants.baseUri}${AppConstants.pusherConfigUri}';
      Uri uri = Uri.parse(apiUrl);
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $authToken', // Assuming it's a Bearer token
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        pusherConfig = PusherConfig.fromJson(responseBody);
        update();
      } else if (response.statusCode == 401) {
        Get.offAllNamed(SignInScreen.routeName);
      } else {
        if (kDebugMode) {
          print('Failed to laod pusher config. Status code: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
      }
    } catch (e) {
      errorMessage = 'Failed to laod pusher config!';
      if (kDebugMode) {
        print("$e");
      }
      isLoading = false;
      isScreenLoading = false;
      update();
    } finally {
      isLoading = false;
      isScreenLoading = false;
    }
  }

  void onConnectPressed() async {
    try {
      if (pusherConfig != null) {
        await pusher.init(
          apiKey: pusherConfig!.apiKey, // API_KEY
          cluster: pusherConfig!.cluster, // API_CLUSTER
          onConnectionStateChange: onConnectionStateChange,
          onError: onError,
          onSubscriptionSucceeded: onSubscriptionSucceeded,
          onEvent: onEvent,
          onSubscriptionError: onSubscriptionError,
          onDecryptionFailure: onDecryptionFailure,
          onMemberAdded: onMemberAdded,
          onMemberRemoved: onMemberRemoved,
        );
        await pusher.subscribe(channelName: pusherConfig!.channel);
        await pusher.connect();
      }
    } catch (e) {
      if (kDebugMode) {
        print("ERROR: $e");
      }
    }
  }

  void onConnectionStateChange(dynamic currentState, dynamic previousState) {
    if (kDebugMode) {
      print("Connection: $currentState");
    }
  }

  void onError(String message, int? code, dynamic e) {
    if (kDebugMode) {
      print("onError: $message code: $code exception: $e");
    }
  }

  void onSubscriptionSucceeded(String channelName, dynamic data) {
    if (kDebugMode) {
      print("onSubscriptionSucceeded: $channelName data: $data");
    }
  }

  void onEvent(PusherEvent event) {
    if (kDebugMode) {
      print("onEvent: $event");
    }
    if (event.eventName == "App\\Events\\UserNotification") {
      saveNotificationVisibility(true);
    }
    loadNotificationVisibility();

    final eventData = event.data.toString();
    final parsedData = jsonDecode(eventData); // Parse the event data JSON
    final text = parsedData["message"]["description"]["text"] as String; // Extract the "text" field
    final cleanedText = text.replaceAll(RegExp(r'\s+'), ' '); // Remove all line breaks and replace with a space
    String formattedDate = DateFormat.yMMMMd().add_jm().format(DateTime.now());

    // send to push notification
    notificationService.sendNotification(cleanedText, formattedDate);

    // store message to the list
    final item = Message(text: cleanedText, formattedDate: formattedDate);
    notificationList.add(item);
    // Save the updated message list to storage
    box.write('messages', notificationList.map((message) => message.toMap()).toList());
    update();
  }

  void onSubscriptionError(String message, dynamic e) {
    if (kDebugMode) {
      print("onSubscriptionError: $message Exception: $e");
    }
  }

  void onDecryptionFailure(String event, String reason) {
    if (kDebugMode) {
      print("onDecryptionFailure: $event reason: $reason");
    }
  }

  void onMemberAdded(String channelName, PusherMember member) {
    if (kDebugMode) {
      print("onMemberAdded: $channelName member: $member");
    }
  }

  void onMemberRemoved(String channelName, PusherMember member) {
    if (kDebugMode) {
      print("onMemberRemoved: $channelName member: $member");
    }
  }

  void triggerEventAutomatically() async {
    try {
      if (pusherConfig != null) {
        await Future.delayed(const Duration(seconds: 2)); // Delay for 2 seconds before triggering the event
        pusher.trigger(PusherEvent(
          channelName: pusherConfig!.channel,
          eventName: pusherConfig!.event,
        ));
      }
    } catch (e) {
      if (kDebugMode) {
        print("ERROR: $e");
      }
    }
  }

  // Clear the messageList and update storage
  void clearNotifications() {
    notificationList.clear();
    box.remove('messages');
    update();
  }
}

class Message {
  final String text;
  final String formattedDate;

  Message({
    required this.text,
    required this.formattedDate,
  });

  // Convert the Message object to a map for storage
  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'formattedDate': formattedDate,
    };
  }

  // Create a Message object from a map retrieved from storage
  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      text: map['text'],
      formattedDate: map['formattedDate'],
    );
  }
}

class PusherConfig {
  final String apiKey;
  final String cluster;
  final String channel;
  final String event;

  PusherConfig({
    required this.apiKey,
    required this.cluster,
    required this.channel,
    required this.event,
  });

  factory PusherConfig.fromJson(Map<String, dynamic> json) {
    final message = json['message'];
    return PusherConfig(
      apiKey: message['apiKey'],
      cluster: message['cluster'],
      channel: message['channel'],
      event: message['event'],
    );
  }
}

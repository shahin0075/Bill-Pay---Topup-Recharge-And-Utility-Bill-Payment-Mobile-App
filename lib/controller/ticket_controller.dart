import 'dart:convert';
import 'dart:io';
import 'package:bill_payment/models/ticket_model.dart';
import 'package:bill_payment/screens/auth/signin_screen.dart';
import 'package:bill_payment/screens/profile/email_verification.dart';
import 'package:bill_payment/screens/profile/sms_verification.dart';
import 'package:bill_payment/screens/support/support_ticket_screen.dart';
import 'package:bill_payment/utils/app_colors.dart';
import 'package:bill_payment/utils/app_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';

class TicketController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController messageController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  List<File> selectedFiles = [];

  final ScrollController scrollController = ScrollController();
  List<Ticket> ticketLists = [];
  List<TicketMessage> ticketMessages = [];
  // List<TicketAttachment> ticketAttachments = [];
  int currentPage = 1;
  int lastPage = 1;
  bool isLoading = true;
  bool isScreenLoading = false;
  bool isError = false;
  String errorMessage = '';
  final box = GetStorage();

  dynamic messageId;
  dynamic ticketStatus;

  // load ticket list
  Future<void> fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString(AppConstants.token);

    try {
      String apiUrl = '${AppConstants.baseUri}${AppConstants.ticketListUri}?page=$currentPage';
      Uri uri = Uri.parse(apiUrl);

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $authToken',
        },
      );

      // Check values from GetStorage
      dynamic storedEmail = box.read('isEmailVerified');
      dynamic storedSms = box.read('isSmsVerified');
      dynamic storedStatus = box.read('isStatusVerified');

      if (storedEmail != 1) {
        Get.offAllNamed(EmailVerification.routeName);
      } else if (storedSms != 1) {
        Get.offAllNamed(SmsVerification.routeName);
      } else if (storedStatus != 1) {
        Get.offAllNamed(SignInScreen.routeName);
      }

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> ticketData = data['message']['data'];
        ticketLists.addAll(ticketData.map((json) => Ticket.fromJson(json)));
        currentPage = data['message']['current_page'];
        lastPage = data['message']['last_page'];

        isLoading = false;
        update();
      } else if (response.statusCode == 401) {
        Get.offAllNamed(SignInScreen.routeName);
      } else {
        isLoading = false;
        isError = true;
        update();
        if (kDebugMode) {
          print('Failed to load data. Status Code: ${response.statusCode}');
        }
        throw Exception('Failed to load data. Status Code: ${response.statusCode}');
      }
    } catch (error) {
      isLoading = false;
      isError = true;
      update();
      if (kDebugMode) {
        print('Error fetching data: $error');
      }
    } finally {
      isLoading = false;
    }
  }

  Future<void> loadMoreData() async {
    if (currentPage < lastPage) {
      currentPage++;
      await fetchData();
    }
  }

  Future<void> pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: true,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result != null) {
        selectedFiles = result.files.map((file) => File(file.path!)).toList();
        update();
      } else {
        // User canceled the picker
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error picking files: $e');
      }
    }
  }

  // remove file from create ticket attachment list
  void removeFile(int index) {
    selectedFiles.removeAt(index);
    update();
  }

  // create ticket
  Future<void> createTicket() async {
    final prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString(AppConstants.token);
    isLoading = true;
    update();

    try {
      String apiUrl = '${AppConstants.baseUri}${AppConstants.createTicketUri}';
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      Map<String, dynamic> formData = {
        'subject': subjectController.text,
        'message': messageController.text,
        // Add more form data fields as needed
      };

      // Add text fields to the request
      formData.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      // Add files to the request with 'attachments[]' as the field name
      for (var i = 0; i < selectedFiles.length; i++) {
        final file = selectedFiles[i];
        request.files.add(await http.MultipartFile.fromPath('attachments[]', file.path, filename: 'file$i'));
      }

      // Send the request
      request.headers['Authorization'] = 'Bearer $authToken';
      var response = await request.send();

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(await response.stream.bytesToString());
        String status = data['status'];
        String message = data['message'];

        if (data['status'].toLowerCase() == "success") {
          Get.offNamed(SupportTicketScreen.routeName);
          await fetchData();
        }

        Get.snackbar(
          status,
          message,
          duration: const Duration(seconds: 2),
          backgroundColor: CustomColors.getContainerColor(),
        );

        subjectController.clear();
        messageController.clear();
        selectedFiles.clear();
        isLoading = false;
        update();
        if (kDebugMode) {
          print('Response: $data');
        }
      } else if (response.statusCode == 401) {
        Get.offAllNamed(SignInScreen.routeName);
      } else {
        Get.snackbar(
          "Failed",
          "Failed to create ticket",
          duration: const Duration(seconds: 2),
          backgroundColor: CustomColors.getContainerColor(),
        );
        if (kDebugMode) {
          print("Failed to create ticket. Status code: ${response.statusCode}");
        }
        throw ("Failed to create ticket");
      }
    } catch (error) {
      isLoading = false;
      isError = true;
      update();
      if (kDebugMode) {
        print('Failed to create ticket: $error');
      }
    } finally {
      isLoading = false;
    }
  }

  // load ticket message
  Future<void> fetchTicketMessage(dynamic id) async {
    final prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString(AppConstants.token);

    try {
      String apiUrl = '${AppConstants.baseUri}${AppConstants.ticketViewUri}$id';
      Uri uri = Uri.parse(apiUrl);

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $authToken',
        },
      );

      // Check values from GetStorage
      dynamic storedEmail = box.read('isEmailVerified');
      dynamic storedSms = box.read('isSmsVerified');
      dynamic storedStatus = box.read('isStatusVerified');

      if (storedEmail != 1) {
        Get.offAllNamed(EmailVerification.routeName);
      } else if (storedSms != 1) {
        Get.offAllNamed(SmsVerification.routeName);
      } else if (storedStatus != 1) {
        Get.offAllNamed(SignInScreen.routeName);
      }

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        // template
        final List<dynamic> template = data['message']['messages'];
        ticketMessages = template.map((template) => TicketMessage.fromJson(template)).toList();

        messageId = data['message']['id'];
        ticketStatus = data['message']['status'];

        // stored active email permission
        // List<dynamic> attachmentData = data['message']['messages']['attachments'];
        // ticketAttachments = List<TicketAttachment>.from(attachmentData);

        isScreenLoading = false;
        update();
      } else if (response.statusCode == 401) {
        Get.offAllNamed(SignInScreen.routeName);
      } else {
        isScreenLoading = false;
        isError = true;
        update();
        if (kDebugMode) {
          print('Failed to load data. Status Code: ${response.statusCode}');
        }
        throw Exception('Failed to load data. Status Code: ${response.statusCode}');
      }
    } catch (error) {
      isScreenLoading = false;
      isError = true;
      update();
      if (kDebugMode) {
        print('Error fetching data: $error');
      }
    } finally {
      isScreenLoading = false;
    }
  }

  // download file
  void downloadFile(String fileUrl, String fileName) async {
    try {
      var response = await http.get(Uri.parse(fileUrl));

      if (response.statusCode == 200) {
        var tempDir = await getTemporaryDirectory();
        String savePath = '${tempDir.path}/$fileName';

        await File(savePath).writeAsBytes(response.bodyBytes);

        if (kDebugMode) {
          print('File downloaded to: $savePath');
        }

        // Open the downloaded file with its associated application
        OpenFile.open(savePath);
      } else if (response.statusCode == 401) {
        Get.offAllNamed(SignInScreen.routeName);
      } else {
        if (kDebugMode) {
          print('Error downloading file. Status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error downloading file: $e');
      }
    }
  }

  // reply ticket
  Future<void> messageReply(String message, dynamic id, String status) async {
    final prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString(AppConstants.token);
    isLoading = true;
    update();

    try {
      String apiUrl = '${AppConstants.baseUri}${AppConstants.ticketReplyUri}';
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // Create a map with the data you want to send
      final Map<String, dynamic> formData = {
        'message': message,
        'replayTicket': status,
        'id': id,
        // Add other fields as needed
      };

      // Add text fields to the request
      formData.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      // Add files to the request with 'attachments[]' as the field name
      for (var i = 0; i < selectedFiles.length; i++) {
        final file = selectedFiles[i];
        request.files.add(await http.MultipartFile.fromPath('attachments[]', file.path, filename: 'file$i'));
      }

      // Send the request
      request.headers['Authorization'] = 'Bearer $authToken';
      var response = await request.send();

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(await response.stream.bytesToString());

        if (data['status'].toLowerCase() != 'success') {
          Get.snackbar(
            data['status'],
            data['message'],
            duration: const Duration(seconds: 2),
          );
        }

        selectedFiles.clear();
        isLoading = false;
        update();
        if (kDebugMode) {
          print('Response: $data');
        }
      } else if (response.statusCode == 401) {
        Get.offAllNamed(SignInScreen.routeName);
      } else {
        Get.snackbar(
          "Failed",
          "Failed to reply",
          duration: const Duration(seconds: 2),
          backgroundColor: CustomColors.getContainerColor(),
        );
        if (kDebugMode) {
          print("Failed to reply. Status code: ${response.statusCode}");
        }
        throw ("Failed to reply");
      }
    } catch (error) {
      isLoading = false;
      isError = true;
      update();
      if (kDebugMode) {
        print('Failed to reply: $error');
      }
    } finally {
      isLoading = false;
    }
  }
}

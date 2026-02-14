import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../core/constants/app_constants.dart';
import '../core/helpers/date_time_helpers.dart';
import '../core/helpers/notification_helpers.dart';
import '../controllers/log_controller.dart';
import '../data/models/medicine_log.dart';
import '../data/models/medicine.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );

    const androidChannel = AndroidNotificationChannel(
      AppConstants.notificationChannelId,
      AppConstants.notificationChannelName,
      description: AppConstants.notificationChannelDesc,
      importance: Importance.max,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }

  Future<bool> requestPermission() async {
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    final iosPlugin =
        _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();

    final androidGranted = await androidPlugin?.requestNotificationsPermission() ?? true;
    final iosGranted = await iosPlugin?.requestPermissions(alert: true, badge: true, sound: true) ??
        true;

    return androidGranted && iosGranted;
  }

  Future<bool> areNotificationsEnabled() async {
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    final iosPlugin =
        _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();

    final androidEnabled = await androidPlugin?.areNotificationsEnabled() ?? true;
    final iosEnabled = await iosPlugin?.checkPermissions().then((value) => value?.isEnabled) ?? true;
    return androidEnabled && iosEnabled;
  }

  Future<void> scheduleMedicine(Medicine medicine) async {
    for (final time in medicine.times) {
      final timeLabel = DateTimeHelpers.formatTimeOfDay(time);
      final payload = _buildPayload(
        medicineId: medicine.id ?? 0,
        medicineName: medicine.name,
        dosage: medicine.dosage,
        scheduledTime: timeLabel,
      );
      if (medicine.frequency == 'Specific Days' && medicine.days.isNotEmpty) {
        for (final day in medicine.days) {
          final id = NotificationHelpers.buildNotificationId(
            medicine.id ?? 0,
            '$timeLabel-$day',
          );
          final scheduled = _nextInstanceForWeekday(time, day);
          try {
            await _plugin.zonedSchedule(
              id,
              medicine.name,
              'Time to take ${medicine.dosage}',
              scheduled,
              _notificationDetails(),
              androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
              matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
              payload: payload,
            );
          } catch (e) {
            // Fall back to inexact scheduling if exact alarms permission is denied
            await _plugin.zonedSchedule(
              id,
              medicine.name,
              'Time to take ${medicine.dosage}',
              scheduled,
              _notificationDetails(),
              androidScheduleMode: AndroidScheduleMode.inexact,
              matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
              payload: payload,
            );
          }
        }
      } else {
        final id = NotificationHelpers.buildNotificationId(medicine.id ?? 0, timeLabel);
        final scheduled = _nextInstance(time);
        try {
          await _plugin.zonedSchedule(
            id,
            medicine.name,
            'Time to take ${medicine.dosage}',
            scheduled,
            _notificationDetails(),
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            matchDateTimeComponents: DateTimeComponents.time,
            payload: payload,
          );
        } catch (e) {
          // Fall back to inexact scheduling if exact alarms permission is denied
          await _plugin.zonedSchedule(
            id,
            medicine.name,
            'Time to take ${medicine.dosage}',
            scheduled,
            _notificationDetails(),
            androidScheduleMode: AndroidScheduleMode.inexact,
            matchDateTimeComponents: DateTimeComponents.time,
            payload: payload,
          );
        }
      }
    }
  }

  Future<void> cancelMedicine(Medicine medicine) async {
    for (final time in medicine.times) {
      final timeLabel = DateTimeHelpers.formatTimeOfDay(time);
      if (medicine.frequency == 'Specific Days' && medicine.days.isNotEmpty) {
        for (final day in medicine.days) {
          final id = NotificationHelpers.buildNotificationId(
            medicine.id ?? 0,
            '$timeLabel-$day',
          );
          await _plugin.cancel(id);
        }
      } else {
        final id = NotificationHelpers.buildNotificationId(medicine.id ?? 0, timeLabel);
        await _plugin.cancel(id);
      }
    }
  }

  Future<void> scheduleSnooze({
    required int medicineId,
    required String title,
    required String body,
    required int minutes,
  }) async {
    final scheduled = tz.TZDateTime.now(tz.local).add(Duration(minutes: minutes));
    final id = NotificationHelpers.buildNotificationId(medicineId, 'snooze-$minutes-$scheduled');

    try {
      await _plugin.zonedSchedule(
        id,
        title,
        body,
        scheduled,
        _notificationDetails(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } catch (e) {
      // Fall back to inexact scheduling if exact alarms permission is denied
      await _plugin.zonedSchedule(
        id,
        title,
        body,
        scheduled,
        _notificationDetails(),
        androidScheduleMode: AndroidScheduleMode.inexact,
      );
    }
  }

  tz.TZDateTime _nextInstance(TimeOfDay time) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  tz.TZDateTime _nextInstanceForWeekday(TimeOfDay time, int weekday) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    while (scheduled.weekday != weekday || scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  NotificationDetails _notificationDetails() {
    const androidDetails = AndroidNotificationDetails(
      AppConstants.notificationChannelId,
      AppConstants.notificationChannelName,
      channelDescription: AppConstants.notificationChannelDesc,
      importance: Importance.max,
      priority: Priority.high,
      actions: [
        AndroidNotificationAction(
          AppConstants.actionTaken,
          'Taken',
          showsUserInterface: true,
        ),
        AndroidNotificationAction(
          AppConstants.actionSnooze,
          'Snooze',
          showsUserInterface: true,
        ),
      ],
    );
    const iosDetails = DarwinNotificationDetails();
    return const NotificationDetails(android: androidDetails, iOS: iosDetails);
  }

  Future<void> _onDidReceiveNotificationResponse(
    NotificationResponse response,
  ) async {
    final payload = response.payload;
    if (payload == null || payload.isEmpty) return;

    final data = _parsePayload(payload);
    final medicineId = data['medicineId'] as int? ?? 0;
    final medicineName = data['medicineName'] as String? ?? 'Medicine';
    final dosage = data['dosage'] as String? ?? '';
    final scheduledTime = data['scheduledTime'] as String? ?? '';

    if (response.actionId == AppConstants.actionSnooze) {
      await scheduleSnooze(
        medicineId: medicineId,
        title: medicineName,
        body: 'Time to take $dosage',
        minutes: AppConstants.snoozeMinutesDefault,
      );
      await _addLog(medicineId, scheduledTime, 'Snoozed');
      return;
    }

    if (response.actionId == AppConstants.actionTaken) {
      await _addLog(medicineId, scheduledTime, 'Taken');
      return;
    }
  }

  Future<void> _addLog(int medicineId, String scheduledTime, String status) async {
    if (!Get.isRegistered<LogController>()) return;
    final controller = Get.find<LogController>();
    await controller.addLog(MedicineLog(
      medicineId: medicineId,
      scheduledTime: scheduledTime,
      status: status,
      date: DateTime.now(),
    ));
  }

  String _buildPayload({
    required int medicineId,
    required String medicineName,
    required String dosage,
    required String scheduledTime,
  }) {
    return jsonEncode({
      'medicineId': medicineId,
      'medicineName': medicineName,
      'dosage': dosage,
      'scheduledTime': scheduledTime,
    });
  }

  Map<String, Object?> _parsePayload(String payload) {
    try {
      return Map<String, Object?>.from(jsonDecode(payload) as Map);
    } catch (_) {
      return <String, Object?>{};
    }
  }
}

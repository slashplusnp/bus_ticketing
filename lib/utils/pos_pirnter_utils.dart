import 'dart:io';

import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';

import '../data/requests/ticket_report/ticket_report_request.dart';
import '../data/responses/hardware_data/hardware_data_response.dart';
import '../extensions/extensions.dart';

class BluetoothPrinter {
  int? id;
  String? deviceName;
  String? address;
  String? port;
  String? vendorId;
  String? productId;
  bool? isBle;

  PrinterType typePrinter;
  bool? state;

  BluetoothPrinter({
    this.deviceName,
    this.address,
    this.port,
    this.state,
    this.vendorId,
    this.productId,
    this.typePrinter = PrinterType.bluetooth,
    this.isBle = false,
  });
}

class PosPrinterUtils {
  const PosPrinterUtils._internal();
  static const _instance = PosPrinterUtils._internal();
  factory PosPrinterUtils() => _instance;

  static var defaultPrinterType = PrinterType.bluetooth;
  static const _isBle = false;
  static const _reconnect = false;
  static var printerManager = PrinterManager.instance;
  static const BTStatus _currentStatus = BTStatus.none;
  static List<int>? pendingTask;

  static late BluetoothPrinter bluetoothPrinter;

  static Future<bool> _scan() async {
    printerManager.discovery(type: defaultPrinterType, isBle: _isBle).listen((device) {
      bluetoothPrinter = BluetoothPrinter(
        deviceName: device.name,
        address: device.address,
        isBle: _isBle,
        vendorId: device.vendorId,
        productId: device.productId,
        typePrinter: defaultPrinterType,
      );
    });
    await Future<void>.delayed(const Duration(seconds: 2));
    return true;
  }

  static void _printEscPos(List<int> bytes, Generator generator) async {
    await _scan();

    bytes += generator.cut();
    await printerManager.connect(
      type: PrinterType.bluetooth,
      model: BluetoothPrinterInput(
        name: bluetoothPrinter.deviceName,
        address: bluetoothPrinter.address!,
        isBle: bluetoothPrinter.isBle ?? false,
        autoConnect: _reconnect,
      ),
    );
    pendingTask = null;
    if (Platform.isAndroid) pendingTask = bytes;

    if (bluetoothPrinter.typePrinter == PrinterType.bluetooth && Platform.isAndroid) {
      if (_currentStatus == BTStatus.connected) {
        printerManager.send(type: bluetoothPrinter.typePrinter, bytes: bytes);
        pendingTask = null;
      }
    } else {
      printerManager.send(type: bluetoothPrinter.typePrinter, bytes: bytes);
    }
  }

  static Future<void> printTicket({
    required final TicketReportRequest reportRequest,
    required final HardwareData? hardwareData,
    required final int totalPassengers,
  }) async {
    List<int> bytes = [];

    // Xprinter XP-N160I
    final profile = await CapabilityProfile.load(name: 'XP-N160I');
    // PaperSize.mm80 or PaperSize.mm58
    final generator = Generator(PaperSize.mm58, profile)
      ..setGlobalCodeTable('CP1252')
      ..clearStyle();

    // company details
    bytes += generator.hr(ch: ' ');
    bytes += generator.text(
      'Sajha Yatayat',
      styles: const PosStyles(
        align: PosAlign.center,
        bold: true,
        height: PosTextSize.size2,
      ),
    );
    bytes += generator.text(
      'Bus No.: ${hardwareData?.busNumber}',
      styles: const PosStyles(
        align: PosAlign.left,
        bold: true,
        height: PosTextSize.size1,
      ),
    );
    bytes += generator.hr();
    for (final ticketCategory in (reportRequest.category).orEmpty()) {
      bytes += generator.text(
        '${ticketCategory.name} (${ticketCategory.count}): ${ticketCategory.total}',
        styles: const PosStyles(
          align: PosAlign.left,
          bold: true,
          height: PosTextSize.size1,
        ),
      );
    }
    bytes += generator.text(
      'Total Fare ($totalPassengers): ${reportRequest.total}',
      styles: const PosStyles(
        align: PosAlign.left,
        bold: true,
        height: PosTextSize.size1,
      ),
    );
    bytes += generator.hr();
    bytes += generator.text(
      'Printed at: ${reportRequest.date}',
      styles: const PosStyles(
        align: PosAlign.left,
        bold: true,
        height: PosTextSize.size1,
      ),
    );
    bytes += generator.hr();

    // prepared by
    bytes += generator.text(
      'Thank you for choosing sajha',
      styles: const PosStyles(
        align: PosAlign.center,
        bold: true,
      ),
    );

    _printEscPos(bytes, generator);
  }
}

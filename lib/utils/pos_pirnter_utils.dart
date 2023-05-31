import 'dart:async';

import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';

import '../app/constants.dart';
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
  static final _printerManager = PrinterManager.instance;

  static Future<bool> _printEscPos(
    List<int> bytes,
    Generator generator, {
    required BluetoothPrinter bluetoothPrinter,
  }) async {
    bytes += generator.cut();
    await _printerManager.connect(
      type: bluetoothPrinter.typePrinter,
      model: BluetoothPrinterInput(
        name: bluetoothPrinter.deviceName,
        address: bluetoothPrinter.address!,
        isBle: bluetoothPrinter.isBle ?? false,
        autoConnect: true,
      ),
    );
    return _printerManager.send(type: bluetoothPrinter.typePrinter, bytes: bytes);
  }

  static Future<(List<int> bytes, Generator)> _convertDataToPrinter({
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
    bytes += generator.text(
      'Bus No.: ${hardwareData?.routeName}',
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

    return (bytes, generator);
  }

  static void printTicket({
    required final TicketReportRequest reportRequest,
    required final HardwareData? hardwareData,
    required final int totalPassengers,
  }) async {
    BluetoothPrinter? bluetoothPrinter;

    _printerManager
        .discovery(
      type: PrinterType.bluetooth,
      isBle: false,
    )
        .listen((device) async {
      if (AppDefaults.printerName.map((name) => name.toLowerCase()).contains(device.name.toLowerCase())) {
        bluetoothPrinter = BluetoothPrinter(
          deviceName: device.name,
          address: device.address,
          isBle: false,
          vendorId: device.vendorId,
          productId: device.productId,
          typePrinter: PrinterType.bluetooth,
        );

        final (List<int> bytes, Generator generator) = await _convertDataToPrinter(
          reportRequest: reportRequest,
          hardwareData: hardwareData,
          totalPassengers: totalPassengers,
        );

        _printEscPos(
          bytes,
          generator,
          bluetoothPrinter: bluetoothPrinter!,
        );
      }
    });
  }
}

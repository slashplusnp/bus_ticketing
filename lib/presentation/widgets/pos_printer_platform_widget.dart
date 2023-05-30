import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';

import '../../data/requests/ticket_report/ticket_report_request.dart';
import '../../data/responses/hardware_data/hardware_data_response.dart';
import '../../extensions/extensions.dart';

class PosPrinterPlatformWidget extends StatefulWidget {
  const PosPrinterPlatformWidget({
    super.key,
    required this.reportRequest,
    required this.hardwareData,
    required this.totalPassengers,
  });

  final TicketReportRequest reportRequest;
  final HardwareData? hardwareData;
  final int totalPassengers;

  @override
  State<PosPrinterPlatformWidget> createState() => _MyAppState();
}

class _MyAppState extends State<PosPrinterPlatformWidget> {
  // Printer Type [bluetooth, usb, network]
  var defaultPrinterType = PrinterType.bluetooth;
  final _isBle = false;
  final _reconnect = false;
  // ignore: unused_field
  var _isConnected = false;
  var printerManager = PrinterManager.instance;
  var devices = <BluetoothPrinter>[];
  StreamSubscription<PrinterDevice>? _subscription;
  StreamSubscription<BTStatus>? _subscriptionBtStatus;
  StreamSubscription<USBStatus>? _subscriptionUsbStatus;
  BTStatus _currentStatus = BTStatus.none;
  // _currentUsbStatus is only supports on Android
  // ignore: unused_field
  USBStatus _currentUsbStatus = USBStatus.none;
  List<int>? pendingTask;
  String _ipAddress = '';
  String _port = '9100';
  final _ipController = TextEditingController();
  final _portController = TextEditingController();
  BluetoothPrinter? selectedPrinter;

  @override
  void initState() {
    if (Platform.isWindows) defaultPrinterType = PrinterType.usb;
    super.initState();
    _portController.text = _port;
    _scan();

    // subscription to listen change status of bluetooth connection
    _subscriptionBtStatus = PrinterManager.instance.stateBluetooth.listen((status) {
      log(' ----------------- status bt $status ------------------ ');
      _currentStatus = status;
      if (status == BTStatus.connected) {
        setState(() {
          _isConnected = true;
        });
      }
      if (status == BTStatus.none) {
        setState(() {
          _isConnected = false;
        });
      }
      if (status == BTStatus.connected && pendingTask != null) {
        if (Platform.isAndroid) {
          Future.delayed(const Duration(milliseconds: 1000), () {
            PrinterManager.instance.send(type: PrinterType.bluetooth, bytes: pendingTask!);
            pendingTask = null;
          });
        } else if (Platform.isIOS) {
          PrinterManager.instance.send(type: PrinterType.bluetooth, bytes: pendingTask!);
          pendingTask = null;
        }
      }
    });
    //  PrinterManager.instance.stateUSB is only supports on Android
    _subscriptionUsbStatus = PrinterManager.instance.stateUSB.listen((status) {
      log(' ----------------- status usb $status ------------------ ');
      _currentUsbStatus = status;
      if (Platform.isAndroid) {
        if (status == USBStatus.connected && pendingTask != null) {
          Future.delayed(const Duration(milliseconds: 1000), () {
            PrinterManager.instance.send(type: PrinterType.usb, bytes: pendingTask!);
            pendingTask = null;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _subscriptionBtStatus?.cancel();
    _subscriptionUsbStatus?.cancel();
    _portController.dispose();
    _ipController.dispose();
    super.dispose();
  }

  // method to scan devices according PrinterType
  void _scan() {
    devices.clear();
    _subscription = printerManager.discovery(type: defaultPrinterType, isBle: _isBle).listen((device) {
      devices.add(
        BluetoothPrinter(
          deviceName: device.name,
          address: device.address,
          isBle: _isBle,
          vendorId: device.vendorId,
          productId: device.productId,
          typePrinter: defaultPrinterType,
        ),
      );
      setState(() {});
    });
  }

  void setPort(String value) {
    if (value.isEmpty) value = '9100';
    _port = value;
    var device = BluetoothPrinter(
      deviceName: value,
      address: _ipAddress,
      port: _port,
      typePrinter: PrinterType.network,
      state: false,
    );
    selectDevice(device);
  }

  void setIpAddress(String value) {
    _ipAddress = value;
    var device = BluetoothPrinter(
      deviceName: value,
      address: _ipAddress,
      port: _port,
      typePrinter: PrinterType.network,
      state: false,
    );
    selectDevice(device);
  }

  void selectDevice(BluetoothPrinter device) async {
    if (selectedPrinter != null) {
      if ((device.address != selectedPrinter!.address) || (device.typePrinter == PrinterType.usb && selectedPrinter!.vendorId != device.vendorId)) {
        await PrinterManager.instance.disconnect(type: selectedPrinter!.typePrinter);
      }
    }

    selectedPrinter = device;
    setState(() {});
  }

  Future<void> _printReceiveTest() async {
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
      'Bus No.: ${widget.hardwareData?.busNumber}',
      styles: const PosStyles(
        align: PosAlign.left,
        bold: true,
        height: PosTextSize.size1,
      ),
    );
    bytes += generator.hr();
    for (final ticketCategory in (widget.reportRequest.category).orEmpty()) {
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
      'Total Fare (${widget.totalPassengers}): ${widget.reportRequest.total}',
      styles: const PosStyles(
        align: PosAlign.left,
        bold: true,
        height: PosTextSize.size1,
      ),
    );
    bytes += generator.hr();
    bytes += generator.text(
      'Printed at: ${widget.reportRequest.date}',
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

  /// print ticket
  void _printEscPos(List<int> bytes, Generator generator) async {
    if (selectedPrinter == null) return;
    var bluetoothPrinter = selectedPrinter!;

    switch (bluetoothPrinter.typePrinter) {
      case PrinterType.usb:
        bytes += generator.feed(2);
        bytes += generator.cut();
        await printerManager.connect(
          type: bluetoothPrinter.typePrinter,
          model: UsbPrinterInput(
            name: bluetoothPrinter.deviceName,
            productId: bluetoothPrinter.productId,
            vendorId: bluetoothPrinter.vendorId,
          ),
        );
        pendingTask = null;
        break;
      case PrinterType.bluetooth:
        bytes += generator.cut();
        await printerManager.connect(
          type: bluetoothPrinter.typePrinter,
          model: BluetoothPrinterInput(
            name: bluetoothPrinter.deviceName,
            address: bluetoothPrinter.address!,
            isBle: bluetoothPrinter.isBle ?? false,
            autoConnect: _reconnect,
          ),
        );
        pendingTask = null;
        if (Platform.isAndroid) pendingTask = bytes;
        break;
      case PrinterType.network:
        bytes += generator.feed(2);
        bytes += generator.cut();
        await printerManager.connect(
          type: bluetoothPrinter.typePrinter,
          model: TcpPrinterInput(ipAddress: bluetoothPrinter.address!),
        );
        break;
      default:
    }
    if (bluetoothPrinter.typePrinter == PrinterType.bluetooth && Platform.isAndroid) {
      if (_currentStatus == BTStatus.connected) {
        printerManager.send(type: bluetoothPrinter.typePrinter, bytes: bytes);
        pendingTask = null;
      }
    } else {
      printerManager.send(type: bluetoothPrinter.typePrinter, bytes: bytes);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Printer'),
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            height: double.infinity,
            constraints: const BoxConstraints(maxWidth: 400),
            child: SingleChildScrollView(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  Column(
                    children: devices
                        .map(
                          (device) => ListTile(
                            title: Text('${device.deviceName}'),
                            subtitle: Platform.isAndroid && defaultPrinterType == PrinterType.usb
                                ? null
                                : Visibility(
                                    visible: !Platform.isWindows,
                                    child: Text('${device.address}'),
                                  ),
                            onTap: () {
                              // do something
                              selectDevice(device);
                            },
                            leading: selectedPrinter != null &&
                                    ((device.typePrinter == PrinterType.usb && Platform.isWindows
                                            ? device.deviceName == selectedPrinter!.deviceName
                                            : device.vendorId != null && selectedPrinter!.vendorId == device.vendorId) ||
                                        (device.address != null && selectedPrinter!.address == device.address))
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.green,
                                  )
                                : null,
                            trailing: OutlinedButton(
                              onPressed: selectedPrinter == null || device.deviceName != selectedPrinter?.deviceName
                                  ? null
                                  : () async {
                                      _printReceiveTest().then(
                                        (value) {
                                          Navigator.of(context).pop();
                                        },
                                      );
                                    },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 2,
                                  horizontal: 20,
                                ),
                                child: Text('Print', textAlign: TextAlign.center),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

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

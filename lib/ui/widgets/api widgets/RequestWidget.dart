import 'package:flutter/material.dart';
import 'package:rfid_system/services/response_wrapper.dart';

import '../alerts/error_dialog.dart';

class RequestWidget<T> extends StatefulWidget {
  Future<FirebaseResponseWrapper<T>> Function() request;
  final Widget Function(T data) successWidgetBuilder;
  final Widget Function(String error)? failWidgetBuilder;
  final Widget Function(double progress, bool retrying)? loadingWidgetBuilder;
  final bool? showErrorDialog;
  final List<ErrorActionType>? errorActions;

  RequestWidget({
    Key? key,
    required this.request,
    required this.successWidgetBuilder,
    this.failWidgetBuilder,
    this.loadingWidgetBuilder,
    this.showErrorDialog,
    this.errorActions,
  }) : super(key: key);

  @override
  State<RequestWidget> createState() => _RequestWidgetState<T>();
}

class _RequestWidgetState<T> extends State<RequestWidget<T>> {
  final bool _isRetrying = false;
  late Future<FirebaseResponseWrapper<T>> _request;

  @override
  Widget build(BuildContext context) {
    _request = widget.request();
    return FutureBuilder<FirebaseResponseWrapper<T>>(
      future: _request,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: widget.loadingWidgetBuilder?.call(0, _isRetrying) ?? const CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          if (widget.showErrorDialog ?? true) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog(
                context: context,
                builder: (context) => ErrorDialog(
                  message: snapshot.error.toString(),
                ),
              );
            });
          }

          if (widget.errorActions != null && widget.errorActions!.contains(ErrorActionType.autoRetry)) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                _request = widget.request();
              });
            });
          }

          return widget.failWidgetBuilder != null ? widget.failWidgetBuilder!(snapshot.error.toString()) : const SizedBox();
        } else if (snapshot.hasData) {
          final T? data = snapshot.data?.data;
          if (data == null) {
            return widget.failWidgetBuilder != null ? widget.failWidgetBuilder!('An unknown error occurred.') : const SizedBox();
          }
          return widget.successWidgetBuilder(data);
        } else {
          return const SizedBox();
        }
      },
    );
  }
}

class ErrorAction {
  final ErrorActionType type;
  final void Function()? action;

  const ErrorAction({
    required this.type,
    this.action,
  });

  void _action() {
    if (action != null) {
      action!();
      return;
    }

    switch (type) {
      case ErrorActionType.openWifiSettings:
        _openWifiSettings();
        break;
      case ErrorActionType.contactSupport:
        _contactSupport();
        break;
      case ErrorActionType.sendLogs:
        _sendLogs();
        break;
      case ErrorActionType.close:
        break;
      case ErrorActionType.retry:
        break;
      case ErrorActionType.autoRetry:
        break;
    }
  }

  void _openWifiSettings() {
    // TODO: Implement open wifi settings
  }

  void _contactSupport() {
    // TODO: Implement contact support
  }

  void _sendLogs() {
    // TODO: Implement send logs
  }
}

enum ErrorActionType {
  retry, // Renders on fail widget and dialog
  autoRetry, // Doesn't render
  openWifiSettings, // Renders on fail widget and dialog
  contactSupport, // Renders on fail widget and dialog
  sendLogs, // Doesn't render
  close, // Renders on dialog
}

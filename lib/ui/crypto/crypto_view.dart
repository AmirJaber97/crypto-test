import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show NumberFormat;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rec_tasl/core/base_provider.dart';
import 'package:rec_tasl/models/ExrateResponse.dart';
import 'package:rec_tasl/providers/crypto_provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CryptoView extends StatefulWidget {
  const CryptoView({Key? key}) : super(key: key);

  @override
  _CryptoViewState createState() => _CryptoViewState();
}

class _CryptoViewState extends State<CryptoView> {
  TextEditingController _cryptoInput = TextEditingController();
  late CryptoProvider cp;
  late List<ExrateResponse> _chartData;
  late ChartSeriesController _chartSeriesController;
  String _dataInput = "";

  @override
  void initState() {
    super.initState();
    cp = context.read<CryptoProvider>();
    cp.listenToChannel();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer<CryptoProvider>(builder: (context, _cp, _) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Pair (e.g. BTC/USD)',
                          ),
                          controller: _cryptoInput,
                          onChanged: (v) {
                            setState(() {
                              _dataInput = v;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    SizedBox(
                        height: 50,
                        child: OutlinedButton(
                          onPressed: _dataInput.isEmpty ? null : () => _subToCrypto(),
                          child: Text('Subscribe'),
                        ))
                  ],
                ),
                SizedBox(height: 20),
                _cp.state == NotifierState.loading
                    ? CircularProgressIndicator(color: Colors.greenAccent)
                    : _cp.exrateResponse != null
                        ? _marketData(_cp)
                        : Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                "...",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                SizedBox(height: 20),
                _cp.exrateResponseList.length > 0
                    ? _cryptoChart(_cp)
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Enter a market pair in the text field above and press subscribe to see realtime exchange rate data..",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _marketData(CryptoProvider _cp) {
    ExrateResponse _exrateResp = _cp.exrateResponse!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text("Symbol"),
              Text("${_exrateResp.assetIdBase}/${_exrateResp.assetIdQuote}"),
            ],
          ),
          Column(
            children: [
              Text("Price"),
              Text("${_exrateResp.rate?.toStringAsFixed(2)}"),
            ],
          ),
          if(_exrateResp.time != null)  Column(
            children: [
              Text("Time"),
              Text(
                  "${DateFormat("MMM d, kk:mm a").format(DateTime.parse(_exrateResp.time!))}"),
            ],
          )
        ],
      ),
    );
  }

  Widget _cryptoChart(CryptoProvider _cp) {
    return Expanded(
      child: SfCartesianChart(
        series: <LineSeries<ExrateResponse, int>>[
          LineSeries(
            onRendererCreated: (ChartSeriesController controller) {
              _chartSeriesController = controller;
              _cp.attachController(_chartSeriesController);
            },
            dataSource: _cp.exrateResponseList,
            xValueMapper: (ExrateResponse data, _) => DateTime.parse(data.time ?? "").millisecondsSinceEpoch,
            yValueMapper: (ExrateResponse data, _) => data.rate?.toInt(),
          )
        ],
        primaryXAxis: NumericAxis(
          decimalPlaces: 5,
          majorGridLines: const MajorGridLines(width: 0),
          title: AxisTitle(text: "Date"),
          axisLabelFormatter: (AxisLabelRenderDetails args) {
            late String text;
            text = DateTime.fromMillisecondsSinceEpoch(args.value.toInt()).hour.toString() +
                ":" +
                DateTime.fromMillisecondsSinceEpoch(args.value.toInt()).minute.toString() +
                ":" +
                DateTime.fromMillisecondsSinceEpoch(args.value.toInt()).second.toString();
            return ChartAxisLabel(text, args.textStyle);
          },
        ),
        primaryYAxis: NumericAxis(
            decimalPlaces: 5,
            axisLine: const AxisLine(width: 0),
            numberFormat: NumberFormat.decimalPattern(),
            majorTickLines: const MajorTickLines(size: 0),
            title: AxisTitle(text: "Rate")),
      ),
    );
  }

  void _subToCrypto() {
    context.read<CryptoProvider>().subscribeToCrypto(_dataInput.trim().toUpperCase());
  }
}

import 'dart:convert';

import 'package:rec_tasl/core/base_provider.dart';
import 'package:rec_tasl/core/locator.dart';
import 'package:rec_tasl/models/ExrateResponse.dart';
import 'package:rec_tasl/services/api_service.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

const String COIN_WS = "wss://ws-sandbox.coinapi.io/v1/";
const String COIN_API_TOKEN = "F70AA13C-E172-48D6-9B48-85E22ACD1887";

class CryptoProvider extends BaseProvider {
  var channel;

  ChartSeriesController? _chartSeriesController;

  List<ExrateResponse> _exrateResponseList = [];

  List<ExrateResponse> get exrateResponseList => _exrateResponseList;

  ExrateResponse? _exrateResponse;

  ExrateResponse? get exrateResponse => _exrateResponse;

  ApiService _apiService = locator<ApiService>();

  void listenToChannel() {
    channel = WebSocketChannel.connect(
      Uri.parse(COIN_WS),
    );

    channel.stream.listen(
      (data) {
        try {
          ExrateResponse _exrateResponse = ExrateResponse.fromJson(jsonDecode(data));
          if (_exrateResponse.rate != null) {
            _exrateResponseList.add(_exrateResponse);
            _chartSeriesController?.updateDataSource(addedDataIndex: _exrateResponseList.length - 1);
            if (_exrateResponseList.length > 5) {
              _exrateResponseList.removeAt(0);
              _chartSeriesController?.updateDataSource(removedDataIndex: 0);
            }
            if (exrateResponseList.length == 1) {
              notifyListeners();
            }
          }
        } catch (e) {
          print('failed to parse response $e');
        }
        print(data);
      },
      onError: (error) => print(error),
    );
  }

  Future subscribeToCrypto(String pair) async {
    _exrateResponseList.clear();

    channel.sink.add(jsonEncode({
      "type": "hello",
      "apikey": COIN_API_TOKEN,
      "heartbeat": false,
      "subscribe_update_limit_ms_exrate": 3000,
      "subscribe_data_type": ["exrate"],
      "subscribe_filter_asset_id": [pair]
    }));

    setNotifier(NotifierState.loading);
    try {
      _exrateResponse = await _apiService.getExrate(pair);
    } finally {
      setNotifier(NotifierState.loaded);
    }
  }

  void attachController(ChartSeriesController chartSeriesController) {
    _chartSeriesController = chartSeriesController;
  }
}

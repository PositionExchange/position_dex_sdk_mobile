
import 'package:flutter_test/flutter_test.dart';

import 'package:position_dex_sdk/position_dex_sdk.dart';
import 'package:position_dex_sdk/src/entities/entities.dart';

import 'utils.dart';

void main() {
  const basicPoint = 10000;
  const pipRange = 30000;

  group("generate-orderbook", () {
    // test("add-liquidity-in-same-index", () {
    //   LiquidityAction liquidity = LiquidityAction();
    //
    //   List<List<String>> output = generateDepth(
    //       [
    //         ["8.4900", "12.1778563015312132"],
    //         ["8.4000", "2"],
    //         ["8.1500", "10"],
    //         ["7.9600", "0.48564464"],
    //         ["7.9500", "5"],
    //         ["7.0000", "10"]
    //       ].cast<List<String>>(),
    //       TypeDepth.bid,
    //       10000,
    //       LiquidityPair(
    //           currentIndexPipRange: 2,
    //           pipRange: 30000,
    //           pipSpace: 100,
    //           basisPoint: 10000,
    //           currentPip: 84789,
    //           liquidityIndex: [
    //             ['2', '3773.36223663', '32035.93328244']
    //           ].toList()));
    //
    //   var a=1;
    // });



    test("generateDepth-liquidity", () {
      LiquidityAction liquidity = LiquidityAction();

      List<List<String>> output = generateDepth(
          [
            ["8.4000","2"],
            ["8.1500","10"],
            ["7.0000","10"]
          ].cast<List<String>>(),
          TypeDepth.bid,
          10,
          LiquidityPair(
              currentIndexPipRange: 2,
              pipRange: 30000,
              pipSpace: 100,
              basisPoint: 10000,
              currentPip: 84789,
              liquidityIndex: [
                ["2","3775.83395298","32014.96198738"]
              ].toList()));

      var a=1;


      output.forEach((element) {
        print(' $element');
      });


    });

  });
}

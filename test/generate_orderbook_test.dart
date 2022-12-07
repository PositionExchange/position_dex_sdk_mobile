
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



    test("generateDepth-liquidity-bid", () {
      LiquidityAction liquidity = LiquidityAction();

      List<List<String>> output = generateDepth(
          [
            ["8.4000","2"],
            ["8.1500","10"],
            ["7.0000","10"]
          ].cast<List<String>>(),
          TypeDepth.bid,
          10000,
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

    test("generateDepth-liquidity-ask", () {
      LiquidityAction liquidity = LiquidityAction();

      List<List<String>> output = generateDepth(
          [
            ["8.4000","2"],
            ["8.1500","10"],
            ["7.0000","10"]
          ].cast<List<String>>(),
          TypeDepth.ask,
          1,
          LiquidityPair(
              currentIndexPipRange: 2,
              pipRange: 30000,
              pipSpace: 100,
              basisPoint: 10000,
              currentPip: 68989,
              liquidityIndex: [
                ["2","3775.83395298","26049.1008582"]
              ].toList()));

      var a=1;


      output.forEach((element) {
        print(' $element');
      });


    });
    test("generateDepth-liquidity-camel/busd", () {
      LiquidityAction liquidity = LiquidityAction();

      List<List<String>> output = generateDepth(
          [
            ["65000","715.40916085"],["64900","5000"]
          ].cast<List<String>>(),
          TypeDepth.bid,
          100,
          LiquidityPair(
              currentIndexPipRange: 2,
              pipRange: 30000,
              pipSpace: 100,
              basisPoint: 10000,
              currentPip: 61000,
              liquidityIndex: [
                ["0","219.27326278","657.79786102"],
                ["1","69.99395276","419.95671715"],
                ["2","100","610"],
                ["3","918.10922695","8262.98304252"]
              ].toList()));


      output.forEach((element) {
        print(' $element');
      });


    });

  });
}

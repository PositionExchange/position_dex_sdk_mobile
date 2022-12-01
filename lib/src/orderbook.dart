import 'dart:math';

import '../position_dex_sdk.dart';

class LiquidityPair {
  num currentIndexPipRange = 0;
  num pipRange = 0;
  num basisPoint = 0;
  num currentPip = 0;
  List<List<String>> liquidityIndex = [];

  LiquidityPair(
      {required this.currentIndexPipRange,
      required this.pipRange,
      required this.basisPoint,
      required this.currentPip,
      required this.liquidityIndex});
}

class NexPoint {
  num nextPrice = 0;
  List<String> order = [];

  NexPoint({required this.nextPrice, required this.order});

// get getNextPrice => nextPrice;
// get getOrder => order;
}

class OrderAmm {
  List<String> order = [];
  num nextIndexPipRange = 0;

  OrderAmm({required this.order, required this.nextIndexPipRange});
}

List<List<String>> generateDepth(List<List<String>> orders, TypeDepth typeDepth,
    int groupLevel, LiquidityPair liquidityPair,
    {num depthSize = 100, num multiplier = 1}) {
  List<List<String>> depth = [];

  var liquidityIndexBySide = typeDepth == TypeDepth.ask
      ? liquidityPair.liquidityIndex
          .where((element) =>
              toNum(element[0]) >= liquidityPair.currentIndexPipRange)
          .toList()
      : liquidityPair.liquidityIndex
          .where((element) =>
              toNum(element[0]) <= liquidityPair.currentIndexPipRange)
          .toList();

  if (typeDepth == TypeDepth.ask) {
    // incre
    orders.sort((a, b) => toNum(a[0]).compareTo(toNum(b[0])));
  } else {
    // decre
    orders.sort((a, b) => toNum(b[0]).compareTo(toNum(a[0])));
  }

  num pointPrice = liquidityPair.currentPip / liquidityPair.basisPoint;
  num priceSpace = liquidityPair.pipRange / liquidityPair.basisPoint;
  num nextPoint = -1;
  num indexPipRangeStep = liquidityPair.currentIndexPipRange;
  num countSkipIndex = 0;


  if (orders.isNotEmpty) {
    if (pointPrice == toNum(orders[0][0])) {
      depth.add(orders[0]);
    }
  }

  while (true) {
    NexPoint nextPoint = typeDepth == TypeDepth.ask
        ? _findNextPointPriceAsk(pointPrice, priceSpace, orders)
        : _findNextPointPriceBid(pointPrice, priceSpace, orders);

    OrderAmm resultOrder = calculateOrderAmm(
        typeDepth,
        pointPrice,
        liquidityPair.currentIndexPipRange,
        liquidityIndexBySide,
        liquidityPair.pipRange,
        liquidityPair.basisPoint,
        nextPoint.nextPrice);

    if (toNum(resultOrder.order[0]) != 0) {
      resultOrder.order[1] =
          (toNum(resultOrder.order[1]) + nextPoint.order.length > 0
              ? toNum(nextPoint.order[1])
              : 0)
              .toString();
      depth.add(resultOrder.order);

      pointPrice = nextPoint.nextPrice;
      indexPipRangeStep = resultOrder.nextIndexPipRange;
    }else {

      if (nextPoint.order.isNotEmpty){
        depth.add(nextPoint.order);
      }

      pointPrice = nextPoint.nextPrice;

      num indexPipRangeTemp = (nextPoint.nextPrice *  liquidityPair.basisPoint / liquidityPair.basisPoint ).floor();

      if (indexPipRangeTemp != indexPipRangeStep) {
        countSkipIndex++;
        indexPipRangeStep = indexPipRangeTemp;
      }

    }


    if (depth.length >= depthSize || resultOrder.nextIndexPipRange < 0 || countSkipIndex >2 || pointPrice < 0 ) {
      break;
    }
  }
  return _groupDecimal(
      liquidityPair.basisPoint, depth, groupLevel, typeDepth, multiplier);
}

NexPoint _findNextPointPriceAsk(
    num pointPrice, num priceSpace, List<List<String>> orders) {
  var order = orders
      .firstWhere((element) =>
          toNum(element[0]) > pointPrice &&
          toNum(element[0]) <= pointPrice + priceSpace)
      .toList();

  if (order.isEmpty) {
    return NexPoint(nextPrice: pointPrice + priceSpace, order: []);
  } else {
    orders = orders.removeAt(0).cast<List<String>>().toList();
    return NexPoint(nextPrice: toNum(order[0]), order: order);
  }
}

NexPoint _findNextPointPriceBid(
    num pointPrice, num priceSpace, List<List<String>> orders) {
  var order = orders
      .firstWhere((element) =>
          toNum(element[0]) < pointPrice &&
          toNum(element[0]) <= pointPrice - priceSpace)
      .toList();

  if (order.isEmpty) {
    return NexPoint(nextPrice: pointPrice + priceSpace, order: []);
  } else {
    orders = orders.removeAt(0).cast<List<String>>().toList();
    return NexPoint(nextPrice: toNum(order[0]), order: order);
  }
}

List<List<String>> _groupDecimal(num basisPoint, List<List<String>> depth,
    num groupLevel, TypeDepth type, num multiplier) {
  if (groupLevel == 1) return depth;

  List<List<String>> groupDepth = [];

  num fixedRound = log(groupLevel) / ln10;
  num maxFixedRound = log(basisPoint) / ln10;

  num spacingGroup = (groupLevel * multiplier / basisPoint);
  List<String> group = ["0", "0"];
  num startPrice = 0;
  num endPrice = 0;
  bool newGroup = true;

  // let primitivePrice = depth[0][0].toFixed(3);
  // startPrice = BigNumber(primitivePrice);
  // endPrice = BigNumber(primitivePrice).plus(spacingGroup);
  for (int i = 0; i < depth.length; i++) {
    List<String> order = depth[i];
    num priceOrder = toNum(order[0]);

    if (((priceOrder < endPrice && type == TypeDepth.bid) ||
            (priceOrder > endPrice && type == TypeDepth.ask)) &&
        !newGroup) {
      newGroup = true;
      groupDepth.add(group);
      group = ["0", "0"];
    }

    if (newGroup) {
      if (fixedRound <= maxFixedRound) {
        startPrice = toNum(toNum(order[0]).toStringAsFixed(
            int.parse((maxFixedRound - fixedRound).toString())));
      } else {
        startPrice = toNum(order[0]) -
            (toNum(order[0]) % toNum(spacingGroup.toString()));
      }

      endPrice = type == TypeDepth.ask
          ? startPrice + spacingGroup
          : startPrice - spacingGroup;
      group[0] = endPrice.toString();
      newGroup = false;
    }

    if ((startPrice <= priceOrder &&
            endPrice > priceOrder &&
            type == TypeDepth.ask) ||
        (startPrice >= priceOrder &&
            endPrice < priceOrder &&
            type == TypeDepth.bid)) {
      group[1] = (toNum(group[1]) + toNum(order[1])).toString();
    }

    if (i == depth.length - 1) {
      group[1] = group[1].toString();
      groupDepth.add(group);
    }
  }

  return [];
}

OrderAmm calculateOrderAmm(
    TypeDepth type,
    num pointPrice,
    num currentIndexPipRange,
    List<List<String>> liquidityIndexBySide,
    num pipRange,
    num basisPoint,
    num nextPrice) {
  num indexPipOfNextPrice = ((nextPrice * basisPoint) / pipRange).floor();
  num totalVolume = 0;
  num nextPriceStep = 0;
  bool startIntoIndex = false;
  num pointPriceStep = pointPrice;
  num lastPipIndex = 0;

  for (var i = currentIndexPipRange;;) {
    var liquidityIndex = liquidityIndexBySide
        .firstWhere((element) => toNum(element[0]) == i)
        .toList();

    if (liquidityIndex.isEmpty) {
      return OrderAmm(order: ['0', '0'], nextIndexPipRange: i);
    }

    var priceMaxAndMin = calculatePriceMaxAndMin(i, pipRange, basisPoint);

    if (i != indexPipOfNextPrice) {
      nextPriceStep =
          type == TypeDepth.ask ? priceMaxAndMin[0] : priceMaxAndMin[1];
    } else {
      nextPriceStep = nextPrice;
    }

    if (startIntoIndex) {
      pointPriceStep =
          type == TypeDepth.ask ? priceMaxAndMin[0] : priceMaxAndMin[1];
      startIntoIndex = false;
    }

    var k = toNum(liquidityIndex[1]) * toNum(liquidityIndex[2]);
    num volume;
    if (type == TypeDepth.ask) {
      volume = calculateBaseWithPriceWhenBuy(
          nextPriceStep, toNum(liquidityIndex[1]), pointPriceStep);
      liquidityIndex[1] = (toNum(liquidityIndex[1]) - volume).toString();
    } else {
      volume = calculateBaseWithPriceWhenSell(
          nextPriceStep, toNum(liquidityIndex[2]), pointPriceStep);
      liquidityIndex[1] = (toNum(liquidityIndex[1]) + volume).toString();
    }

    liquidityIndex[2] = (k / toNum(liquidityIndex[1])).toString();
    totalVolume += volume;

    lastPipIndex = i;
    i = type == TypeDepth.ask ? i + 1 : i - 1;

    if ((type == TypeDepth.ask && i > indexPipOfNextPrice) ||
        (type == TypeDepth.bid && i < indexPipOfNextPrice)) {
      break;
    }
    startIntoIndex = true;
  }

  return OrderAmm(
      order: [nextPriceStep.toString(), totalVolume.toString()],
      nextIndexPipRange: lastPipIndex);
}

num toNum(String str) {
  return num.parse(str);
}

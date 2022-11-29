/// @author Musket

import "dart:math" as math;

num calculateQuoteRealFromQuoteVirtual(
    num currentPrice, num quoteVirtual, num priceMin) {
  return ((sqrt(currentPrice) * quoteVirtual) /
      (sqrt(currentPrice) - sqrt(priceMin)));
}

num calculateBaseRealFromBaseVirtual(
    num currentPrice, num baseVirtual, num priceMax) {
  return (sqrt(priceMax) * baseVirtual) / (sqrt(priceMax) - sqrt(currentPrice));
}

num calculateBaseVirtualFromQuoteReal(
    num currentPrice, num quoteReal, num priceMin, num priceMax) {
  return ((quoteReal * (sqrt(priceMax) - sqrt(currentPrice))) /
      (currentPrice * sqrt(priceMax)));
}

num calculateQuoteVirtualFromBaseReal(
    num currentPrice, num baseReal, num priceMin, num priceMax) {
  return baseReal * sqrt(currentPrice) * (sqrt(currentPrice) - sqrt(priceMin));
}

num calculateQuoteByLiquidity(num liquidity, num priceMin, num currentPrice) {
  return liquidity * (sqrt(currentPrice) - sqrt(priceMin));
}

num calculateBaseByLiquidity(num liquidity, num priceMax, num currentPrice) {
  return ((liquidity * (sqrt(priceMax) - sqrt(currentPrice))) /
      (sqrt(currentPrice) * sqrt(priceMax)));
}

num calculateLiquidity(num amountReal, num price, bool isBase) {
  if (isBase) {
    return amountReal * sqrt(price);
  } else {
    return amountReal / sqrt(price);
  }
}

num calculateBaseWithPriceWhenBuy(
    num priceTarget, num baseReal, num currentPrice) {
  return (baseReal * (sqrt(priceTarget) - sqrt(currentPrice))) /
      sqrt(currentPrice);
}

num calculateBaseWithPriceWhenSell(
    num priceTarget, num quoteReal, num currentPrice) {
  return (quoteReal * (sqrt(currentPrice) - sqrt(priceTarget))) /
      (currentPrice * sqrt(priceTarget));
}

List calculatePriceMaxAndMin(num index, num pipRange, num basisPoint) {
  var priceMin = (index == 0 ? 1 : index * pipRange) / basisPoint;
  var priceMax = priceMin + pipRange / basisPoint - 1 / basisPoint;
  return [priceMax, priceMin];
}

num sqrt(num x) {
  return math.sqrt(x);
}

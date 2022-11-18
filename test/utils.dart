/**
 * @author Musket
 */

bool expectDataInRange(num expect, num actual, num percentage) {
  if (actual > 0) {
    return (expect >= actual * (1 - percentage) &&
        expect <= actual * (1 + percentage));
  }
  return (expect <= actual * (1 - percentage) &&
      expect >= actual * (1 + percentage));
}

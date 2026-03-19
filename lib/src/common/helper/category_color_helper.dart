import 'package:finfresh/src/common/consants/constants.dart';

class CategoryColorHelper {
  static getColor(int index) {
    return Constants.COLOR.categoryPalette[index %
        Constants.COLOR.categoryPalette.length];
  }
}

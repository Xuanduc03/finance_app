import 'package:finance_app/data/money.dart';

List<Money> geter() {
  Money breakfast = Money();
  breakfast.amount = "15.000";
  breakfast.name = 'Ăn sáng';
  breakfast.category = 'Ăn Uống';
  breakfast.time = '10/5/2024';
  breakfast.image =
      'https://www.ambitiouskitchen.com/wp-content/uploads/2021/03/Sidneys-Banana-Pancakes-7.jpg';
  breakfast.buy = true;

  Money upwork = Money();
  upwork.amount = '799.979';
  upwork.name = "Upwork";
  upwork.category = 'Việc làm';
  upwork.time = '12/5/2024';
  upwork.image =
      'https://cms-assets.themuse.com/media/lead/01212022-1047259374-coding-classes_scanrail.jpg';
  upwork.buy = false;
  return [breakfast, upwork, breakfast, breakfast, upwork];
}

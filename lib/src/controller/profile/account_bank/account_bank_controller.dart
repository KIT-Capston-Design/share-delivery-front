import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:share_delivery/src/data/repository/profile/account_bank_dto.dart';
import 'package:share_delivery/src/data/repository/profile/profile_repository.dart';

class AccountBankController extends GetxController {
  final ProfileRepository repository;

  static AccountBankController get to => Get.find();
  AccountBankController({required this.repository});

  final RxInt pickedBank = (-1).obs;

  final bank = "농협".obs;
  final accountNumber = "3521264".obs;
  final accountHolder = "박진우".obs;

  final isLoad = false.obs;

  @override
  void onInit() {
    fetchAccountBank();
    super.onInit();
  }

  void setPickedBank(int index) {
    pickedBank.value = index;
  }

  Future<void> fetchAccountBank() async {
    try {
      AccountBankDTO accountDTO = await repository.fetchAccountBank();

      bank.value = accountDTO.bank;
      accountNumber.value = accountDTO.accountNumber;
      accountHolder.value = accountDTO.accountHolder;

      isLoad.value = true;
    } catch (e) {
      Logger().w(e);
    }
  }

  Future<void> updateAccountBank() async {
    AccountBankDTO newAccountDTO = AccountBankDTO(
        userId: 1,
        bank: bank.value,
        accountNumber: accountNumber.value,
        accountHolder: accountHolder.value);
    try {
      await repository.updateAccountBank(newAccountDTO);
    } catch (e) {
      Logger().w(e);
    }
  }
}

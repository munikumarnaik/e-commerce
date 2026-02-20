import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/address_repository.dart';
import '../../domain/models/address_model.dart';

enum AddressStatus { initial, loading, loaded, error }

class AddressState {
  final AddressStatus status;
  final List<Address> addresses;
  final String? error;
  final bool isSaving;

  const AddressState({
    this.status = AddressStatus.initial,
    this.addresses = const [],
    this.error,
    this.isSaving = false,
  });

  AddressState copyWith({
    AddressStatus? status,
    List<Address>? addresses,
    String? error,
    bool? isSaving,
  }) {
    return AddressState(
      status: status ?? this.status,
      addresses: addresses ?? this.addresses,
      error: error,
      isSaving: isSaving ?? this.isSaving,
    );
  }

  Address? get defaultAddress {
    try {
      return addresses.firstWhere((a) => a.isDefault);
    } catch (_) {
      return addresses.isNotEmpty ? addresses.first : null;
    }
  }
}

class AddressNotifier extends StateNotifier<AddressState> {
  final AddressRepository _repository;

  AddressNotifier(this._repository) : super(const AddressState()) {
    loadAddresses();
  }

  Future<void> loadAddresses() async {
    state = state.copyWith(status: AddressStatus.loading);
    try {
      final addresses = await _repository.getAddresses();
      state = state.copyWith(
        status: AddressStatus.loaded,
        addresses: addresses,
      );
    } catch (e) {
      state = state.copyWith(
        status: AddressStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<bool> saveAddress(Map<String, dynamic> body, {String? id}) async {
    state = state.copyWith(isSaving: true);
    try {
      if (id != null) {
        await _repository.updateAddress(id, body);
      } else {
        await _repository.createAddress(body);
      }
      await loadAddresses();
      state = state.copyWith(isSaving: false);
      return true;
    } catch (e) {
      state = state.copyWith(isSaving: false, error: e.toString());
      return false;
    }
  }

  Future<bool> deleteAddress(String id) async {
    try {
      await _repository.deleteAddress(id);
      await loadAddresses();
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  Future<bool> setDefault(String id) async {
    try {
      await _repository.setDefaultAddress(id);
      await loadAddresses();
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }
}

final addressProvider =
    StateNotifierProvider<AddressNotifier, AddressState>((ref) {
  final repository = ref.watch(addressRepositoryProvider);
  return AddressNotifier(repository);
});

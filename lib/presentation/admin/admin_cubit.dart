import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/chatbot/add_generic_reference_doc.dart';
import 'package:priorli/core/contact_leads/usecases/get_contact_leads.dart';
import 'package:priorli/core/country/entities/country.dart';
import 'package:priorli/core/country/usecases/get_support_countries.dart';
import 'package:priorli/core/housing/usecases/admin_get_companies.dart';
import 'package:priorli/core/storage/entities/storage_item.dart';
import 'package:priorli/core/subscription/entities/payment_product_item.dart';
import 'package:priorli/core/subscription/entities/subscription_plan.dart';
import 'package:priorli/core/subscription/usecases/add_payment_product.dart';
import 'package:priorli/core/subscription/usecases/add_subscription_plan.dart';
import 'package:priorli/core/subscription/usecases/delete_subscription_plan.dart';
import 'package:priorli/core/subscription/usecases/get_payment_products.dart';
import 'package:priorli/core/subscription/usecases/remove_payment_product.dart';
import 'package:priorli/presentation/admin/admin_state.dart';

import '../../core/base/usecase.dart';
import '../../core/chatbot/add_document_index.dart';
import '../../core/contact_leads/entities/contact_lead.dart';
import '../../core/housing/entities/housing_company.dart';
import '../../core/subscription/usecases/get_available_subscription_plans.dart';

class AdminCubit extends Cubit<AdminState> {
  final AddSubscriptionPlan _addSubscriptionPlan;
  final GetAvailableSubscriptionPlans _availableSubscriptionPlans;
  final GetContactLeads _getContactLeads;
  final AdminGetCompanies _adminGetCompanies;
  final GetSupportCountries _getSupportCountries;
  final DeleteSubscriptionPlan _deleteSubscriptionPlan;
  final GetPaymentProducts _getPaymentProducts;
  final AddPaymentProduct _addPaymentProduct;
  final RemovePaymentProduct _removePaymentProduct;
  final AddGenericReferenceDoc _addGenericReferenceDoc;
  final AddDocumentIndex _addDocumentIndex;

  AdminCubit(
      this._addDocumentIndex,
      this._addSubscriptionPlan,
      this._availableSubscriptionPlans,
      this._getContactLeads,
      this._adminGetCompanies,
      this._getSupportCountries,
      this._deleteSubscriptionPlan,
      this._getPaymentProducts,
      this._addPaymentProduct,
      this._addGenericReferenceDoc,
      this._removePaymentProduct)
      : super(const AdminState());

  Future<void> getInit({String? countryCode}) async {
    getInitCompanies();
    getInitContactList();
    if (countryCode != null) {
      selectCountry(countryCode);
    } else {
      await getSupportCountries();
      getInitSubscriptionPlans();
      getPaymentProducts();
    }
  }

  Future<void> getInitContactList() async {
    final getContactLeadsResult =
        await _getContactLeads(GetContactLeadListParams());
    if (getContactLeadsResult is ResultSuccess<List<ContactLead>>) {
      final List<ContactLead> contactLeads =
          List.from(state.contactLeadList ?? []);
      contactLeads.addAll(getContactLeadsResult.data);
      emit(state.copyWith(contactLeadList: contactLeads));
    }
  }

  Future<void> getInitCompanies() async {
    final getCompaniesResult = await _adminGetCompanies(
        AdminHousingCompanyParams(
            lastCreatedOn: DateTime.now().millisecondsSinceEpoch, limit: 10));
    if (getCompaniesResult is ResultSuccess<List<HousingCompany>>) {
      final List<HousingCompany> companies = List.from(state.companyList ?? []);
      companies.addAll(getCompaniesResult.data);
      emit(state.copyWith(companyList: companies));
    }
  }

  Future<void> getInitSubscriptionPlans() async {
    final countryCode = state.selectedCountryCode;
    if (countryCode == null) {
      return;
    }
    final getSubscriptionPlansResult = await _availableSubscriptionPlans(
      countryCode,
    );
    if (getSubscriptionPlansResult is ResultSuccess<List<SubscriptionPlan>>) {
      final List<SubscriptionPlan> subscriptionPlans =
          List.from(state.subscriptionPlanList ?? []);
      subscriptionPlans.addAll(getSubscriptionPlansResult.data);
      emit(state.copyWith(subscriptionPlanList: subscriptionPlans));
    }
  }

  Future<void> getSupportCountries() async {
    final getSupptedCountriesResult = await _getSupportCountries(NoParams());
    if (getSupptedCountriesResult is ResultSuccess<List<Country>> &&
        getSupptedCountriesResult.data.isNotEmpty) {
      emit(state.copyWith(
          supportedCountries: getSupptedCountriesResult.data,
          selectedCountryCode:
              getSupptedCountriesResult.data.first.countryCode));
    }
  }

  Future<void> addSubscription({
    required String name,
    required String price,
    required bool hasApartmentDocument,
    required List<String> notificationTypes,
    bool? translation,
    required String maxMessagingChannels,
    required String maxAnnouncement,
    required String maxInvoiceNumber,
    required String additionalInvoiceCost,
    String? interval = 'month',
    int? intervalCount = 1,
  }) async {
    final addSubscriptionPlanResult = await _addSubscriptionPlan(
        AddSubscriptionPlanParams(
            name: name,
            price: double.tryParse(price) ?? 1.99,
            currency: state.supportedCountries
                    ?.where((element) =>
                        element.countryCode == state.selectedCountryCode)
                    .first
                    .currencyCode ??
                'eur',
            hasApartmentDocument: hasApartmentDocument,
            notificationTypes: notificationTypes,
            countryCode: state.selectedCountryCode ?? 'fi',
            translation: translation,
            maxMessagingChannels: int.tryParse(maxMessagingChannels),
            maxAnnouncement: int.tryParse(maxAnnouncement),
            maxInvoiceNumber: int.tryParse(maxInvoiceNumber),
            additionalInvoiceCost:
                double.tryParse(additionalInvoiceCost) ?? 0.99,
            interval: interval,
            intervalCount: intervalCount));
    if (addSubscriptionPlanResult is ResultSuccess<SubscriptionPlan>) {
      final List<SubscriptionPlan> subscriptionPlans =
          List.from(state.subscriptionPlanList ?? []);
      subscriptionPlans.add(addSubscriptionPlanResult.data);
      emit(state.copyWith(subscriptionPlanList: subscriptionPlans));
    }
  }

  Future<void> deleteSubscription(String id) async {
    final deleteSubscriptionPlanResult = await _deleteSubscriptionPlan(id);
    if (deleteSubscriptionPlanResult is ResultSuccess<bool>) {
      final List<SubscriptionPlan> subscriptionPlans =
          List.from(state.subscriptionPlanList ?? []);
      subscriptionPlans.removeWhere((element) => element.id == id);
      emit(state.copyWith(subscriptionPlanList: subscriptionPlans));
    }
  }

  Future<void> getPaymentProducts() async {
    final countryCode = state.selectedCountryCode;
    if (countryCode == null) {
      return;
    }
    final getPaymentProductsResult = await _getPaymentProducts(
        GetPaymentProductParams(countryCode: countryCode));
    if (getPaymentProductsResult is ResultSuccess<List<PaymentProductItem>>) {
      emit(state.copyWith(paymentProductItems: getPaymentProductsResult.data));
    }
  }

  Future<void> addPaymentProduct(
      {required String name,
      required String price,
      required String taxPercentage,
      String? description}) async {
    final countryCode = state.selectedCountryCode;
    if (countryCode == null) {
      return;
    }
    final addPaymentProductResult = await _addPaymentProduct(
        AddPaymentProductParams(
            name: name,
            price: double.tryParse(price) ?? 1.99,
            taxPercentage: double.tryParse(taxPercentage) ?? 24,
            countryCode: countryCode,
            description: description ?? ''));
    if (addPaymentProductResult is ResultSuccess<PaymentProductItem>) {
      final List<PaymentProductItem> paymentProductItems =
          List.from(state.paymentProductItems ?? []);
      paymentProductItems.add(addPaymentProductResult.data);
      emit(state.copyWith(paymentProductItems: paymentProductItems));
    }
  }

  Future<void> removePaymentProductItem(String id) async {
    final removePaymentProductResult = await _removePaymentProduct(
        RemovePaymentProductParams(paymentProductId: id));
    if (removePaymentProductResult is ResultSuccess<bool>) {
      final List<PaymentProductItem> paymentProductItems =
          List.from(state.paymentProductItems ?? []);
      paymentProductItems.removeWhere((element) => element.id == id);
      emit(state.copyWith(paymentProductItems: paymentProductItems));
    }
  }

  void selectCountry(String? value) {
    emit(state.copyWith(selectedCountryCode: value));
    getInitSubscriptionPlans();
    getPaymentProducts();
  }

  Future<void> addGenericReferenceDoc(List<String> files) async {
    final addGenericReferenceDocResult = await _addGenericReferenceDoc(
        AddGenericReferenceDocParams(storageLinks: files, languageCode: 'fi'));
    if (addGenericReferenceDocResult is ResultSuccess<List<StorageItem>>) {
      print(addGenericReferenceDocResult.data);
    }
  }

  Future<void> addDocumentIndex(
      {required String indexName, String? vectorDimension}) async {
    final addDocumentIndex = await _addDocumentIndex(AddDocumentIndexParams(
        indexName: indexName,
        vectorDimension: int.tryParse(vectorDimension ?? '')));
    if (addDocumentIndex is ResultSuccess<bool>) {}
  }
}

class ApiConstants {
//  static String base = "https://app.restroapp.com/storeId";
  static String base = "https://stage.restroapp.com/storeId";

  //static String baseUrl = 'https://app.restroapp.com/storeId/api_v1/';
  static String baseUrl = base + '/api_v1/';

  static String storeList = 'storeList';
  static String version = 'version';
  static String storeLogin = 'storeLogin';

  static String getCategories = 'getCategories';
  static String getProducts = 'getSubCategoryProducts/';
  static String getProductDetail = 'productDetail/';

  static String getStoreBranches = 'getStoreBranches';

  static String search = 'searchProducts';
  static String getTagsList = 'getTagsList';

  static String getAddress = 'deliveryAddress';
  static String getAddressArea = 'deliveryAreas/Area';
  static String getStorePickupAddress = 'storePickupAddress';
  static String getStoreRadius = 'storeRadius';
  static String getStoreArea = 'storearea';

  static String storeOffers = 'storeOffers';
  static String validateCoupon = 'validateAllCoupons';
  static String multipleTaxCalculation = 'multiple_tax_calculation';
  static String multipleTaxCalculation_2 = 'multiple_tax_calculation_new';
  static String subscriptionTaxCalculation = 'tax_calculation';
  static String stripeVerifyTransactionUrl =
      'stripeVerifyTransaction?response=success';

  static String deliveryTimeSlot = 'deliveryTimeSlot';
  static String placeOrder = 'placeOrder';
  static String pickupPlaceOrder = 'pickupPlaceOrder';
  static String setStoreQuery = 'setStoreQuery';
  static String orderHistory = 'orderHistory';
  static String getLoyalityPoints = 'getLoyalityPoints';

  static String login = 'userLogin';
  static String signUp = 'userSignup';
  static String forgetPassword = 'forgetPassword';
  static String updateProfile = 'updateProfile';
  static String mobileVerification = 'mobileVerification';
  static String cancelOrder = 'orderCancel';

  static String socialLogin = 'socialLogin';
  static String verifyEmail = 'verifyEmail';

  static String deliveryAreasArea = 'deliveryAreas/Area';

  static String createOnlineTopUP = 'createOnlineTopUP';
  static String onlineTopUP = 'onlineTopUP';

  static String razorpayCreateOrder = 'razorpayCreateOrder';
  static String razorpayVerifyTransaction = 'razorpayVerifyTransaction';
  static String getReferDetails = 'getReferDetails';
  static String orderCancel = 'orderCancel';

  static String stripePaymentCheckout = 'stripePaymentCheckout';
  static String stripeVerifyTransaction = 'stripeVerifyTransaction';

  static String createPaytmTxnToken = 'createPaytmTxnToken';

  static String faqs = 'faqs';
  static String allNotifications = 'allNotifications';
  static String recommendedProduct = 'recommendedProduct';
  static String orderDetailHistory = 'orderDetailHistory';
  static String reviewRating = 'review_rating';
  static String userWallet = 'user_wallet';
  static String socialLinking = 'social_linking';
  static String termCondition = 'getHtmlPages/term_condition';
  static String privacyPolicy = 'getHtmlPages/privacy_policy';
  static String refundPolicy = 'getHtmlPages/refund_policy';

  static final String txt_mobile =
      "Please enter your Mobile No. to proceed further";
  static final String txt_Submit = "Submit";
  static final String pleaseFullname = "Enter FullName";

  static final String delivrey = "Delievery";
  static final String pickup = "PickUP";
  static final String dine = "dine";

  static String otp = 'verifyOtp';

  static final String txt_OTP =
      "Please enter your One Time Password.We \n have sent the same to your number.";

  static final String enterOtp = "Please enter otp number";

  static String subscriptionPlaceOrder =
      '/api_v1_subscription/placeSubscriptionOrder';
  static String subscriptionPickupPlaceOrder =
      '/api_v1_subscription/pickupPlaceSubscriptionOrder';
  static String subscriptionHistory =
      '/api_v1_subscription/subscriptionHistory';

  static String subscriptionCancel =
      '/api_v1_subscription/subscriptionOrderCancel';

  static String subscriptionStatusUpdate =
      '/api_v1_subscription/subscriptionPauseStart';
  static String subscriptionOrderUpdate =
      '/api_v1_subscription/subscriptionOrderUpdate';
  static String subscriptionDetailHistory =
      '/api_v1_subscription/subscriptionDetailHistory';
  static String subscriptionRazorpayCreateSubscription =
      '/api_v1_online_subscription/razorpayCreateSubscription';
  static String subscriptionRazorpayVerifyTransaction =
      '/api_v1_online_subscription/razorpayVerifyTransaction';
}

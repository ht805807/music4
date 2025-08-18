package com.janther0927M5;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.net.Uri;
import android.os.AsyncTask;
import android.util.Log;
import android.widget.Toast;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.android.billingclient.api.BillingClient;
import com.android.billingclient.api.BillingClientStateListener;
import com.android.billingclient.api.BillingFlowParams;
import com.android.billingclient.api.BillingResult;
import com.android.billingclient.api.ConsumeParams;
import com.android.billingclient.api.ConsumeResponseListener;
import com.android.billingclient.api.ProductDetails;
import com.android.billingclient.api.ProductDetailsResponseListener;
import com.android.billingclient.api.Purchase;
import com.android.billingclient.api.PurchasesUpdatedListener;
import com.android.billingclient.api.QueryProductDetailsParams;
import com.facebook.CallbackManager;
import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
import com.facebook.FacebookSdk;
import com.facebook.share.Sharer;
import com.facebook.share.model.ShareLinkContent;
import com.facebook.share.widget.ShareButton;
import com.facebook.share.widget.ShareDialog;
import com.google.common.collect.ImmutableList;
import java.util.List;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

    CallbackManager callbackManager;

    ShareDialog shareDialog;

    private String channel = "test";

    int SHARED = 0;
    boolean STARE = false;

    private BillingClient billingClient;

    private ImmutableList productDetailsParamsList;

    private BillingFlowParams billingFlowParams;

    private FlutterEngine mflutterEngine;

    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        GooglePlay();
        mflutterEngine = flutterEngine;
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), channel)
                .setMethodCallHandler((call, result) -> {

                    switch (call.method) {
                        case "FaceBookAlertDialog":
                            FaceBookAlertDialog();
                            break;
                        case "30元購買300個金幣":

                            billingClient.startConnection(new BillingClientStateListener() {
                                @Override
                                public void onBillingSetupFinished(BillingResult billingResult) {
                                    if (billingResult.getResponseCode() == BillingClient.BillingResponseCode.OK) {
                                        // BillingClient 初始化成功，可以執行相應的購買操作
                                        initiatePurchase("pc01");
                                    }
                                }

                                @Override
                                public void onBillingServiceDisconnected() {
                                    // 斷開連接，可以在這裡重新連接 BillingClient
                                }
                            });
                            break;
                        case "100元購買1200個金幣":
                            billingClient.startConnection(new BillingClientStateListener() {
                                @Override
                                public void onBillingSetupFinished(BillingResult billingResult) {
                                    if (billingResult.getResponseCode() == BillingClient.BillingResponseCode.OK) {
                                        // BillingClient 初始化成功，可以執行相應的購買操作
                                        initiatePurchase("pc02");
                                    }
                                }

                                @Override
                                public void onBillingServiceDisconnected() {
                                    // 斷開連接，可以在這裡重新連接 BillingClient
                                }
                            });
                            break;
                        case "500元購買7000個金幣":
                            billingClient.startConnection(new BillingClientStateListener() {
                                @Override
                                public void onBillingSetupFinished(BillingResult billingResult) {
                                    if (billingResult.getResponseCode() == BillingClient.BillingResponseCode.OK) {
                                        // BillingClient 初始化成功，可以執行相應的購買操作
                                        initiatePurchase("pc03");
                                    }
                                }

                                @Override
                                public void onBillingServiceDisconnected() {
                                    // 斷開連接，可以在這裡重新連接 BillingClient
                                }
                            });
                            break;
                        case "1000元購買20000個金幣":
                            billingClient.startConnection(new BillingClientStateListener() {
                                @Override
                                public void onBillingSetupFinished(BillingResult billingResult) {
                                    if (billingResult.getResponseCode() == BillingClient.BillingResponseCode.OK) {
                                        // BillingClient 初始化成功，可以執行相應的購買操作
                                        initiatePurchase("pc04");
                                    }
                                }

                                @Override
                                public void onBillingServiceDisconnected() {
                                    // 斷開連接，可以在這裡重新連接 BillingClient
                                }
                            });
                            break;
                        case "30元購買過關金幣五倍卷(永久)":
                            billingClient.startConnection(new BillingClientStateListener() {
                                @Override
                                public void onBillingSetupFinished(BillingResult billingResult) {
                                    if (billingResult.getResponseCode() == BillingClient.BillingResponseCode.OK) {
                                        // BillingClient 初始化成功，可以執行相應的購買操作
                                        initiatePurchase("pc05");
                                    }
                                }

                                @Override
                                public void onBillingServiceDisconnected() {
                                    // 斷開連接，可以在這裡重新連接 BillingClient
                                }
                            });
                            break;
                    }
                });
        FacebookSdk.fullyInitialize();
        shareDialog = new ShareDialog(MainActivity.this);
        callbackManager = CallbackManager.Factory.create();

        shareDialog.registerCallback(callbackManager, new FacebookCallback<Sharer.Result>() {

            @Override
            public void onSuccess(Sharer.Result result) {

                if (SHARED == 0) {
                    SharedPreferences data = MainActivity.this.getSharedPreferences("DATA_FILE_NAME",
                            Context.MODE_PRIVATE);
                    SharedPreferences.Editor editor = data.edit();

                    editor.putInt("Shared", 1);
                    editor.commit();

                    //MyPlayer.playTone(MainActivity.this, MyPlayer.INDEX_TONE_COIN);
                    //handleCoins(300);
                    new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), channel)
                            .invokeMethod("TOTAL_COINS_300", null);
                    Toast.makeText(getApplicationContext(), "首次分享成功，獲得300個金幣", Toast.LENGTH_SHORT).show();

                    new AlertDialog.Builder(MainActivity.this).setTitle("給予5星評價")
                            .setMessage("給予5星評價再送200個金幣，此視窗只出現一次，敬請把握")
                            .setPositiveButton("給予5星評價", new DialogInterface.OnClickListener() {
                                @Override
                                public void onClick(DialogInterface dialog, int which) {
                                    SharedPreferences data2 = MainActivity.this.getSharedPreferences("DATA_FILE_NAME",
                                            Context.MODE_PRIVATE);
                                    SharedPreferences.Editor editor2 = data2.edit();
                                    STARE = data2.getBoolean("stare", false);

                                    editor2.commit();
                                    Uri uri = Uri.parse("market://details?id=com.janther0927M5");
                                    Intent i = new Intent(Intent.ACTION_VIEW, uri);

                                    SharedPreferences data = MainActivity.this.getSharedPreferences("DATA_FILE_NAME",
                                            Context.MODE_PRIVATE);
                                    SharedPreferences.Editor editor = data.edit();

                                    editor.putBoolean("stare", true);
                                    editor.commit();

                                    startActivity(i);
                                    if (!STARE) {
                                        new SetUserData111().execute();

                                    }

                                }
                            }).show();

                } else {
                    Toast.makeText(getApplicationContext(), "分享成功", Toast.LENGTH_SHORT).show();
                }
            }

            @Override
            public void onCancel() {
                Toast.makeText(getApplicationContext(), "分享取消", Toast.LENGTH_SHORT).show();
            }

            @Override
            public void onError(FacebookException error) {
                Toast.makeText(getApplicationContext(), "分享失敗", Toast.LENGTH_SHORT).show();
            }
        });


    }

    private void FaceBookAlertDialog() {
        SharedPreferences data = MainActivity.this.getSharedPreferences("DATA_FILE_NAME",
                Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = data.edit();
        SHARED = data.getInt("Shared", 0);
        editor.commit();


        new AlertDialog.Builder(MainActivity.this).setTitle("FaceBook分享")
                .setMessage("首次分享贈送300個金幣!!\n分享後請勿將APP刪除，否則金幣數據將被刪除")
                .setPositiveButton("分享", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        new AlertDialog.Builder(MainActivity.this)
                                .setMessage("是否同意此應用程式代替您在FaceBook發布文章?不同意請按上一頁")
                                .setPositiveButton("同意", new DialogInterface.OnClickListener() {
                                    @Override
                                    public void onClick(DialogInterface dialog, int which) {
                                        String link = "https://play.google.com/store/apps/details?id=com.janther0927M5";// 网站的链接


                                        ShareLinkContent content = new ShareLinkContent.Builder()
                                                .setContentUrl(Uri.parse(link))
                                                .build();
                                        shareDialog.show(content, ShareDialog.Mode.AUTOMATIC);

                                    }
                                }).show();

                    }
                }).show();


    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        // TODO Auto-generated method stub
        super.onActivityResult(requestCode, resultCode, data);
        callbackManager.onActivityResult(requestCode, resultCode, data);
    }

    private void GooglePlay() {
        billingClient = BillingClient.newBuilder(this)
                .setListener(purchasesUpdatedListener)
                .enablePendingPurchases()
                .build();
    }

    private PurchasesUpdatedListener purchasesUpdatedListener = new PurchasesUpdatedListener() {
        @Override
        public void onPurchasesUpdated(@NonNull BillingResult billingResult, @Nullable List<Purchase> purchases) {
            if (billingResult.getResponseCode() == BillingClient.BillingResponseCode.OK
                    && purchases != null) {
                for (com.android.billingclient.api.Purchase purchase : purchases) {
                    handlePurchase(purchase);
                }
            } else if (billingResult.getResponseCode() == BillingClient.BillingResponseCode.USER_CANCELED) {
                // Handle an error caused by a user cancelling the purchase flow.
            } else {
                // Handle any other error codes.
            }
        }
    };

    private void handlePurchase(com.android.billingclient.api.Purchase purchase) {
        // Purchase retrieved from BillingClient#queryPurchasesAsync or your PurchasesUpdatedListener.

        switch (purchase.getSkus().toString()) {
            case "[pc01]":

                //MainActivity.handleCoins(300);
                alert("獲得300金幣");
                new MethodChannel(mflutterEngine.getDartExecutor().getBinaryMessenger(), channel)
                        .invokeMethod("TOTAL_COINS_300", null);
                //MyPlayer.playTone(google.this, MyPlayer.INDEX_TONE_COIN);
                break;
            case "[pc02]":

                //MainActivity.handleCoins(1200);
                alert("獲得1200金幣");
                //MyPlayer.playTone(google.this, MyPlayer.INDEX_TONE_COIN);
                new MethodChannel(mflutterEngine.getDartExecutor().getBinaryMessenger(), channel)
                        .invokeMethod("TOTAL_COINS_1200", null);
                break;
            case "[pc05]":

                alert("金幣五倍已開啟");
                SharedPreferences data = this.getSharedPreferences("DATA_FILE_NAME", Context.MODE_PRIVATE);
                SharedPreferences.Editor editor = data.edit();

                editor.putBoolean("mo", true);
                editor.commit();
                break;

            case "[pc03]":

                //MainActivity.handleCoins(7000);
                alert("獲得7000金幣");
                //MyPlayer.playTone(google.this, MyPlayer.INDEX_TONE_COIN);
                new MethodChannel(mflutterEngine.getDartExecutor().getBinaryMessenger(), channel)
                        .invokeMethod("TOTAL_COINS_7000", null);
                break;

            case "[pc04]":

                //MainActivity.handleCoins(20000);
                alert("獲得20000金幣");
                //MyPlayer.playTone(google.this, MyPlayer.INDEX_TONE_COIN);
                new MethodChannel(mflutterEngine.getDartExecutor().getBinaryMessenger(), channel)
                        .invokeMethod("TOTAL_COINS_20000", null);
                break;

            default:
                break;
        }
        // Verify the purchase.
        // Ensure entitlement was not already granted for this purchaseToken.
        // Grant entitlement to the user.

        ConsumeParams consumeParams =
                ConsumeParams.newBuilder()
                        .setPurchaseToken(purchase.getPurchaseToken())
                        .build();

        ConsumeResponseListener listener = new ConsumeResponseListener() {
            @Override
            public void onConsumeResponse(BillingResult billingResult, String purchaseToken) {
                if (billingResult.getResponseCode() == BillingClient.BillingResponseCode.OK) {
                    // Handle the success of the consume operation.
                    //Toast.makeText(getApplicationContext(), "消耗成功", Toast.LENGTH_SHORT).show();
                }
            }
        };

        billingClient.consumeAsync(consumeParams, listener);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (billingClient != null) {
            billingClient.endConnection();
        }
    }

    void alert(String message) {
        AlertDialog.Builder bld = new AlertDialog.Builder(this);
        bld.setMessage(message);
        bld.setNeutralButton("OK", null);
        bld.create().show();
    }

    // 發送購買請求
    private void initiatePurchase(String SKU_GAS_ID) {
        // 購買商品的 SKU（Stock Keeping Unit）

        QueryProductDetailsParams queryProductDetailsParams =
                QueryProductDetailsParams.newBuilder()
                        .setProductList(
                                ImmutableList.of(
                                        QueryProductDetailsParams.Product.newBuilder()
                                                .setProductId(SKU_GAS_ID)
                                                .setProductType(BillingClient.ProductType.INAPP)
                                                .build()))
                        .build();

        billingClient.queryProductDetailsAsync(
                queryProductDetailsParams,
                new ProductDetailsResponseListener() {
                    public void onProductDetailsResponse(BillingResult billingResult,
                                                         List<ProductDetails> productDetailsList) {
                        // check billingResult
                        // process returned productDetailsList

                        productDetailsParamsList =
                                ImmutableList.of(
                                        BillingFlowParams.ProductDetailsParams.newBuilder()
                                                // retrieve a value for "productDetails" by calling queryProductDetailsAsync()
                                                .setProductDetails(productDetailsList.get(0))
                                                // to get an offer token, call ProductDetails.getSubscriptionOfferDetails()
                                                // for a list of offers that are available to the user
                                                .build()
                                );
                        billingFlowParams = BillingFlowParams.newBuilder()
                                .setProductDetailsParamsList(productDetailsParamsList)
                                .build();
                        billingClient.launchBillingFlow(MainActivity.this, billingFlowParams);

                    }
                }
        );

    }

    public class SetUserData111 extends AsyncTask<String, Integer, String> {

        @Override
        protected String doInBackground(String... params) {

            try {
                Thread.sleep(20000); // 模拟5秒的耗时操作
            } catch (InterruptedException e) {
                e.printStackTrace();
            }

            return null;
        }

        @Override
        protected void onPostExecute(String string) {
            // 執行後 完成背景任務
            new MethodChannel(mflutterEngine.getDartExecutor().getBinaryMessenger(), channel)
                    .invokeMethod("TOTAL_COINS_200", null);
            super.onPostExecute(string);

        }
    }

}

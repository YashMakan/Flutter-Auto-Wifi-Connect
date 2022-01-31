package com.makan.flutter_iot
import android.app.Application
import android.annotation.TargetApi
import android.content.Context
import android.net.wifi.WifiManager
import android.net.wifi.WifiNetworkSuggestion
import android.os.Build
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.*

class MyApplication : Application() {

    override fun onCreate() {
        super.onCreate()
        MyApplication.appContext = applicationContext
    }

    companion object {

        lateinit  var appContext: Context

    }
}

class MainActivity: FlutterActivity() {
    private val CHANNEL = "flutteriot/wifi"


    @ExperimentalStdlibApi
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler{
            call, result ->
            when {
                call.method.equals("connectWifi") -> {
                    connectToWifi(call, result)
                }
            }
        }
    }

    @TargetApi(Build.VERSION_CODES.Q)
    private fun connectToWifi(call: MethodCall, result: MethodChannel.Result) {
        val arguments: Map<String, String> = call.arguments();
        val ssid = arguments["ssid"]
        val password = arguments["password"]
        try {
            val wifiNetworkSuggestion: WifiNetworkSuggestion = WifiNetworkSuggestion.Builder().setSsid(ssid.toString()).setWpa2Passphrase(password.toString()).build()
            val list: MutableList<WifiNetworkSuggestion> = ArrayList()
            list.add(wifiNetworkSuggestion)
            val context = MyApplication.appContext
            // todo: issue in line 55
            val wifiManager: WifiManager = context.applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager
            wifiManager.removeNetworkSuggestions(ArrayList<WifiNetworkSuggestion>())
            wifiManager.addNetworkSuggestions(list)
            result.success("connected successfully");
        } catch (e: Exception) {
            e.printStackTrace()
            result.success(e.toString());
        }
    }
}

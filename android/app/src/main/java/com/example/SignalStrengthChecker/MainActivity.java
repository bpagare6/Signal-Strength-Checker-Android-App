package com.example.SignalStrengthChecker;

import io.flutter.embedding.android.FlutterActivity;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.BatteryManager;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.os.Bundle;

// Import Telephony Manager for Accessing Sim Card Details
import android.telephony.SubscriptionManager;
import android.telephony.SubscriptionInfo;
import android.telephony.TelephonyManager;
import android.telephony.CellInfo;
import android.telephony.CellInfoCdma;
import android.telephony.CellInfoGsm;
import android.telephony.CellInfoLte;
import android.telephony.CellInfoWcdma;
import android.telephony.CellSignalStrength;
import android.telephony.CellSignalStrengthCdma;
import android.telephony.CellSignalStrengthGsm;
import android.telephony.CellSignalStrengthLte;
import android.telephony.CellSignalStrengthWcdma;

import android.provider.Settings.Secure;

// Extra imports needed
import android.util.Log;
import android.content.Context;
import java.util.List;
import java.util.ArrayList;
import java.util.HashMap;

public class MainActivity extends FlutterActivity {
    private String CHANNEL = "com.bhushan.signalchecker/GetSignalStrength";
    private SubscriptionManager subscriptionManager;
    private List<SubscriptionInfo> activeSubscriptionInfoList = new ArrayList<SubscriptionInfo>();;
    private List<TelephonyManager> telephonyManagerList = new ArrayList<TelephonyManager>();
    private int simCount = 0;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
            .setMethodCallHandler(
                (call, result) -> {
                    this.subscriptionManager = SubscriptionManager.from(getApplicationContext());
                    this.activeSubscriptionInfoList = subscriptionManager.getActiveSubscriptionInfoList();

                    TelephonyManager telephonyManager = (TelephonyManager)getSystemService(Context.TELEPHONY_SERVICE);
                    for (SubscriptionInfo subscriptionInfo : activeSubscriptionInfoList) {
                        int subId = subscriptionInfo.getSubscriptionId();
                        this.telephonyManagerList.add(telephonyManager.createForSubscriptionId(subId));
                    }

                    // Note: this method is invoked on the main thread.
                    if (call.method.equals("getSignalStrengths")) {
                        int simNumber = call.argument("simNumber");
                        result.success(getSignalStrengths(simNumber));
                    } else if (call.method.equals("getSimCount")) {
                        getSimCount();
                        result.success(simCount);
                    } else if (call.method.equals("getSimDetails")) {
                        int simNumber = call.argument("simNumber");
                        result.success(getSimDetails(simNumber));
                    } else {
                        result.notImplemented();
                    }
                }
            );
    }

    private void getSimCount() {
        this.simCount = activeSubscriptionInfoList.size();
    }

    private int getSignalStrengths(int simNumber) {
        TelephonyManager tm = telephonyManagerList.get(simNumber);
        
        int signal_strength = 0;
        String carrierName = tm.getNetworkOperatorName();
        if (carrierName == null || carrierName.equals("")) {
            signal_strength = 0;
        } else {
            CellInfo cellInfo = tm.getAllCellInfo().get(simNumber);
            if (cellInfo instanceof CellInfoCdma) {
                CellInfoCdma cellInfoCdma = (CellInfoCdma)cellInfo;
                CellSignalStrengthCdma cellSignalStrengthCdma = cellInfoCdma.getCellSignalStrength();
                signal_strength = cellSignalStrengthCdma.getDbm();
            } else if (cellInfo instanceof CellInfoGsm) {
                CellInfoGsm cellInfoGsm = (CellInfoGsm)cellInfo;
                CellSignalStrengthGsm cellSignalStrengthGsm = cellInfoGsm.getCellSignalStrength();
                signal_strength = cellSignalStrengthGsm.getDbm();
            } else if (cellInfo instanceof CellInfoLte) {
                CellInfoLte cellInfoLte = (CellInfoLte)cellInfo;
                CellSignalStrengthLte cellSignalStrengthLte = cellInfoLte.getCellSignalStrength();
                signal_strength = cellSignalStrengthLte.getDbm();
            } else if (cellInfo instanceof CellInfoWcdma) {
                CellInfoWcdma cellInfoWcdma = (CellInfoWcdma)cellInfo;
                CellSignalStrengthWcdma cellSignalStrengthWcdma = cellInfoWcdma.getCellSignalStrength();
                signal_strength = cellSignalStrengthWcdma.getDbm();
            }
        }
        return signal_strength;
    }

    private HashMap<String, String> getSimDetails(int simNumber) {
        TelephonyManager tm = telephonyManagerList.get(simNumber);

        String operator_name = tm.getSimOperatorName();
        String serial_number = activeSubscriptionInfoList.get(simNumber).getIccId();

        String carrierName = tm.getNetworkOperatorName();
        String signal = "";
        if (carrierName == null || carrierName.equals("")) {
            signal = "No Service";
        } else {
            int signal_strength = getSignalStrengths(simNumber);
            signal = Integer.toString(signal_strength) + "dBm";
        }        

        HashMap<String, String> map = new HashMap<String, String>();
        map.put("SIM Operator Name", operator_name);
        map.put("SIM Serial Number", serial_number);
        map.put("SIM Signal Strength", signal);

        // Log.d("MainActivity: ", map.toString());
        return map;
    }
}

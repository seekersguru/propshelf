/*
 * GetDataFromServer.java
 * Flo2Cash
 * 
 * Created by Sanket Patel on 2/18/13.
 * Copyright (c) 2013 Xerces Technologies Pvt. Ltd. All rights reserved.
 */
package app.prop.propshelf.async;

import android.app.ProgressDialog;
import android.content.Context;
import android.os.AsyncTask;

import app.prop.propshelf.model.ResponseData;
import app.prop.propshelf.network.IAsyncTaskCompleteListener;
import app.prop.propshelf.network.NetworkUtils;
import app.prop.propshelf.utils.Constants;
import app.prop.propshelf.utils.Logger;


/**
 * GetDataFromServer class is the common class which is used to process all
 * requests to server and when response comes then send the response to
 * OnTaskComplete() method. This class also handles the loader still the
 * response from server does not get.
 */
public class GetDataFromServer {

    private String url = null;
    private IAsyncTaskCompleteListener<ResponseData> callBack;

    private int method;
    private int webServiceNumber = 1;
    private GetDataInAsyncTaskClass getDataInAsyncTask = null;
    private String payload;
    private Context context;
    private boolean showLoader;
    private String message="Loading...";

    public void setLoaderMessage(String message) {
        this.message = message;
    }

    public GetDataFromServer(IAsyncTaskCompleteListener<ResponseData> callBack,
                             int webServiceNumber, int methodType) {
        this.callBack = callBack;
        this.webServiceNumber = webServiceNumber; // Get web service identifier
        this.method = methodType;
    }

    public void InitialiseRequest(Context context, String url, String payload, boolean showLoader) {
        this.context = context;
        this.url = url;
        this.payload = payload;
        this.showLoader = showLoader;
        getDataInAsyncTask = new GetDataInAsyncTaskClass();
        getDataInAsyncTask.execute();
    }

    public class GetDataInAsyncTaskClass extends
            AsyncTask<String, Void, ResponseData> {
        ProgressDialog dialog;

        @Override
        protected void onPreExecute() {
            if (showLoader) {
                dialog = ProgressDialog.show(context, "Please Wait", message);
            }
        }

        @Override
        protected ResponseData doInBackground(String... params) {

            ResponseData response;
            Logger.logger("URL:" + url);
            Logger.logger("Payload:" + payload);
            try {

                switch (method) {
                    case Constants.METHOD_GET:
                        response = NetworkUtils.sendHttpGet(url);
                        break;
                    case Constants.METHOD_POST:
                        response = NetworkUtils.sendHttpPost(url, payload);
                        break;
                    case Constants.METHOD_PUT:
                        response = NetworkUtils.sendHttpPut(url, payload);
                        break;
                    case Constants.METHOD_DELETE:
                        response = NetworkUtils.sendHttpDelete(url, payload);
                        break;

                    default:
                        response = null;
                        break;
                }

                return response;

            } catch (Exception e) {
                e.printStackTrace();
                return null;
            }
        }

        protected void onPostExecute(ResponseData result) {
            getDataInAsyncTask.cancel(true);
            if (result != null) {
                switch (result.getResponseCode()) {
                    case 200:
                    case 201:
                    case 204:
                        callBack.OnTaskSuccess(result, webServiceNumber);
                        break;
                    default:
                        callBack.OnTaskError(result, webServiceNumber);
                        break;
                }

            } else {

                callBack.OnTaskError(result, webServiceNumber);
            }
            if (dialog != null) {
                dialog.dismiss();
            }
        }
    }
}

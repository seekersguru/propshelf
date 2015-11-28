package app.prop.propshelf.network;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.security.KeyManagementException;
import java.security.NoSuchAlgorithmException;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;

import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;

import app.prop.propshelf.PropShelf;
import app.prop.propshelf.model.ResponseData;
import app.prop.propshelf.utils.Constants;
import app.prop.propshelf.utils.Logger;
import app.prop.propshelf.utils.PreferenceManager;

public class NetworkUtils 
{

	public static ResponseData sendHttpPost(String url,String payload) throws Exception {
		 
		Logger.logger("URL:" + url);
		URL obj = new URL(url);
		
		HttpURLConnection con = (HttpURLConnection) obj.openConnection();
 
		con.setRequestMethod("POST");
		
		con.setRequestProperty(Constants.CONTENT_TYPE, Constants.CONTENT_TYPE_JSON);
		con.setRequestProperty(Constants.ACCEPT_ENCODING,Constants.ACCEPT_ENCODING_TYPE);
		Logger.logger("Authorisation: "+PreferenceManager.getAuthorization(PropShelf.getAppContext()));
		con.setRequestProperty(Constants.AUTHORIZATION, PreferenceManager.getAuthorization(PropShelf.getAppContext()));

		con.setRequestProperty("Content-Length", "0");
		con.setDoOutput(true);
		
		if (payload!=null) {
			con.setRequestProperty("Content-Length", Integer.toString(payload.getBytes().length));
			BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(con.getOutputStream(), "UTF-8"));
			bw.write(payload);
			bw.flush();
			bw.close();	
		}
		
		Logger.logger("Sending 'POST' request to URL : " + url);
		Logger.logger("Post parameters : " + payload);
		int responseCode = con.getResponseCode();
		Logger.logger("Response Code : " + responseCode);

		BufferedReader in = new BufferedReader(
		        new InputStreamReader(con.getInputStream()));
		String inputLine;
		StringBuffer response = new StringBuffer();
 
		while ((inputLine = in.readLine()) != null) {
			response.append(inputLine);
		}
		
		Logger.logger("Response: " + response.toString());
		ResponseData responseData=new ResponseData();
		responseData.setResponseCode(responseCode);
		responseData.setResponse(response.toString());
		
		in.close();
		con.disconnect();
		return responseData;
	}
	
	private static String getStringFromInputStream(InputStream is) {
		 
		BufferedReader br = null;
		StringBuilder sb = new StringBuilder();
 
		String line;
		try {
 
			br = new BufferedReader(new InputStreamReader(is));
			while ((line = br.readLine()) != null) {
				sb.append(line);
			}
 
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if (br != null) {
				try {
					br.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
 
		return sb.toString();
 
	}
 
	public static ResponseData sendHttpGet(String url) throws Exception {
		 
		URL obj = new URL(url);
		HttpURLConnection con = (HttpURLConnection) obj.openConnection();
		
//		if (url.contains("https://staging.ufony.com/api/")) 
//		{
//			disableSSLCertificateChecking();	
//		}
		// optional default is GET
		con.setRequestMethod("GET");
		
		con.setRequestProperty(Constants.CONTENT_TYPE,Constants.CONTENT_TYPE_JSON);
		con.setRequestProperty(Constants.ACCEPT_ENCODING,Constants.ACCEPT_ENCODING_TYPE);
		con.setRequestProperty(Constants.AUTHORIZATION,PreferenceManager.getAuthorization(PropShelf.getAppContext()));
	
		int responseCode = con.getResponseCode();
		
		Logger.logger("Sending 'GET' request to URL : " + url);
		Logger.logger("Response Code : " + responseCode);
				BufferedReader in = new BufferedReader(
		        new InputStreamReader(con.getInputStream()));
		String inputLine;
		StringBuffer response = new StringBuffer();
 
		while ((inputLine = in.readLine()) != null) {
			response.append(inputLine);
		}
		in.close();
		con.disconnect();
		
		Logger.logger("Response: " + response.toString());
		ResponseData responseData=new ResponseData();
		responseData.setResponseCode(responseCode);
		responseData.setResponse(response.toString());
		
		return responseData;
	}

	 
		public static ResponseData sendHttpDelete(String url) throws Exception {
			 
			URL obj = new URL(url);
			HttpURLConnection con = (HttpURLConnection) obj.openConnection();
			
//			if (url.contains("https://staging.ufony.com/api/")) 
//			{
//				disableSSLCertificateChecking();	
//			}
			// optional default is GET
			con.setRequestMethod("DELETE");
			
			con.setRequestProperty(Constants.CONTENT_TYPE,Constants.CONTENT_TYPE_JSON);
			con.setRequestProperty(Constants.ACCEPT_ENCODING,Constants.ACCEPT_ENCODING_TYPE);
			con.setRequestProperty(Constants.AUTHORIZATION,PreferenceManager.getAuthorization( PropShelf.getAppContext()));
		
			int responseCode = con.getResponseCode();
			
			Logger.logger("Sending 'DELETE' request to URL : " + url);
			Logger.logger("Response Code : " + responseCode);

			
			BufferedReader in = new BufferedReader(
			        new InputStreamReader(con.getInputStream()));
			String inputLine;
			StringBuffer response = new StringBuffer();
	 
			while ((inputLine = in.readLine()) != null) {
				response.append(inputLine);
			}
			in.close();
			con.disconnect();
			
			Logger.logger("Response: " + response.toString());
			ResponseData responseData=new ResponseData();
			responseData.setResponseCode(responseCode);
			responseData.setResponse(response.toString());
			
			return responseData;
		}

		public static ResponseData sendHttpDelete(String url,String payload) throws Exception {
			 
			URL obj = new URL(url);
			HttpURLConnection con = (HttpURLConnection) obj.openConnection();
			
//			if (url.contains("https://staging.ufony.com/api/")) 
//			{
//				disableSSLCertificateChecking();	
//			}
			// optional default is GET
			con.setRequestMethod("DELETE");
			
			con.setRequestProperty(Constants.CONTENT_TYPE,Constants.CONTENT_TYPE_JSON);
			con.setRequestProperty(Constants.ACCEPT_ENCODING,Constants.ACCEPT_ENCODING_TYPE);
			con.setRequestProperty(Constants.AUTHORIZATION,PreferenceManager.getAuthorization( PropShelf.getAppContext()));

			if (payload!=null) {
//				con.setDoOutput(true);
				BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(con.getOutputStream(), "UTF-8"));
				bw.write(payload);
				bw.flush();
				bw.close();
			}
						
			int responseCode = con.getResponseCode();
			
			Logger.logger("Sending 'DELETE' request to URL : " + url);
			Logger.logger("Response Code : " + responseCode);

			
			BufferedReader in = new BufferedReader(
			        new InputStreamReader(con.getInputStream()));
			String inputLine;
			StringBuffer response = new StringBuffer();
	 
			while ((inputLine = in.readLine()) != null) {
				response.append(inputLine);
			}
			in.close();
			con.disconnect();
			
			Logger.logger("Response: " + response.toString());
			ResponseData responseData=new ResponseData();
			responseData.setResponseCode(responseCode);
			responseData.setResponse(response.toString());
			
			return responseData;
		}

	public static ResponseData sendHttpPut(String url,String payload) throws Exception {
		 
		URL obj = new URL(url);
		HttpURLConnection con = (HttpURLConnection) obj.openConnection();
 
//		if (url.contains("https://staging.ufony.com/api/")) 
//		{
//			disableSSLCertificateChecking();	
//		}
		con.setRequestMethod("PUT");
 
		con.setRequestProperty(Constants.CONTENT_TYPE,Constants.CONTENT_TYPE_JSON);
		con.setRequestProperty(Constants.ACCEPT_ENCODING,Constants.ACCEPT_ENCODING_TYPE);
		con.setRequestProperty(Constants.AUTHORIZATION,PreferenceManager.getAuthorization(PropShelf.getAppContext()));
	
		con.setDoOutput(true);
		DataOutputStream wr = new DataOutputStream(con.getOutputStream());
		wr.writeBytes(payload);
		wr.flush();
		wr.close();
 
		int responseCode = con.getResponseCode();
	

//		Logger.logger("Response Code : " + responseCode);
// 
		BufferedReader in = new BufferedReader(
		        new InputStreamReader(con.getInputStream()));
		String inputLine;
		StringBuffer response = new StringBuffer();
 
		while ((inputLine = in.readLine()) != null) {
			response.append(inputLine);
		}
		in.close();
		con.disconnect();
		
		Logger.logger(url+"== Response: " + response.toString());
		ResponseData responseData=new ResponseData();
		responseData.setResponseCode(responseCode);
		responseData.setResponse(response.toString());
		return responseData;
	}
	
	public static HttpURLConnection getHttpMedia(String url) throws Exception {
		 
		URL obj = new URL(url);
		HttpURLConnection con = (HttpURLConnection) obj.openConnection();
 
		// optional default is GET
		con.setRequestMethod("GET");
		
		con.setRequestProperty(Constants.CONTENT_TYPE,Constants.CONTENT_TYPE_JSON);
		con.setRequestProperty(Constants.ACCEPT_ENCODING,Constants.ACCEPT_ENCODING_TYPE);
		con.setRequestProperty(Constants.AUTHORIZATION,PreferenceManager.getAuthorization(PropShelf.getAppContext()));
	
		int responseCode = con.getResponseCode();
		
		Logger.logger("GET request to URL : " + url);
		Logger.logger("Response Code : " + responseCode);

		return con;
	}
	
	
	public static ResponseData forgetPassword(String url,String payload) throws Exception {
		 
		URL obj = new URL(url);
		
		HttpURLConnection con = (HttpURLConnection) obj.openConnection();
 
		con.setRequestMethod("POST");
		
		con.setRequestProperty(Constants.CONTENT_TYPE,Constants.CONTENT_TYPE_JSON);
		con.setRequestProperty(Constants.ACCEPT_ENCODING,Constants.ACCEPT_ENCODING_TYPE);
		con.setRequestProperty(Constants.AUTHORIZATION,PreferenceManager.getAuthorization(PropShelf.getAppContext()));
	
		con.setDoOutput(true);
		
		if (payload!=null) {
			BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(con.getOutputStream(), "UTF-8"));
			bw.write(payload);
			bw.flush();
			bw.close();	
		}
 
		int responseCode = con.getResponseCode();
		
		Logger.logger("Sending 'POST' request to URL : " + url);
		Logger.logger("Post parameters : " + payload);
		Logger.logger("Response Code : " + responseCode);

		ResponseData responseData=new ResponseData();
		responseData.setResponseCode(responseCode);
		responseData.setResponse("");
		
		con.disconnect();
		return responseData;
	}


	public static void disableSSLCertificateChecking() {
        TrustManager[] trustAllCerts = new TrustManager[] { new X509TrustManager() {
            public X509Certificate[] getAcceptedIssuers() {
                return null;
            }
 
            @Override
            public void checkClientTrusted(X509Certificate[] arg0, String arg1) throws CertificateException {
                // Not implemented
            }
 
            @Override
            public void checkServerTrusted(X509Certificate[] arg0, String arg1) throws CertificateException {
                // Not implemented
            }
        } };
 
        try {
            SSLContext sc = SSLContext.getInstance("TLS");
 
            sc.init(null, trustAllCerts, new java.security.SecureRandom());
 
            //HttpURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());
        } catch (KeyManagementException e) {
            e.printStackTrace();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
    }
}

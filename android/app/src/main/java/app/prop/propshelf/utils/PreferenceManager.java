package app.prop.propshelf.utils;

import android.content.Context;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;

import com.google.gson.Gson;

import app.prop.propshelf.model.WallUser;

public class PreferenceManager {

	public static final String PREF_NAME = "shared_prefs";
	public static final String AUTHO = "shared_prefs";
	public static final String USER = "shared_user";
	public static final String GRADES = "allGrades";
	public static final String CHILDS = "allChilds";

	public static final String UNREAD_MESSAGES = "unreadMessages";

	public static final String DEFAULT_AUTH = "";
	private static final String DEFAULT_RECIPIENT = "default_recipient";
	private static final String SCHOOL_DETAILS = "school_details";
	private static final String USER_ROLE = "userrole";

	/**
	 * get authorization
	 * 
	 * @param context
	 * @param authorization
	 */
	public static void setAuthorization(Context context, String authorization) {
		SharedPreferences prefs = context.getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE);
		Editor editor = prefs.edit();
		// prefix by Basic
		editor.putString(AUTHO, authorization);
		editor.commit();
	}

	public static String getAuthorization(Context context) {
		SharedPreferences prefs = context.getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE);
		return prefs.getString(AUTHO, DEFAULT_AUTH);
	}

	public static void setCurrentUser(Context context, String user) {
		SharedPreferences prefs = context.getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE);
		Editor editor = prefs.edit();
		// prefix by Basic
		editor.putString(USER, user);
		editor.commit();
	}

	public static WallUser getCurrentUser(Context context) {
		SharedPreferences prefs = context.getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE);
		String s=prefs.getString(USER, null);
        Logger.logger("getCurrentUser:"+s);
        if (s==null)
            return null;
		WallUser user=new Gson().fromJson(s,WallUser.class);
		return user;
	}

	public static void setMessagesToRead(Context context, String messages) {
		SharedPreferences prefs = context.getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE);
		Editor editor = prefs.edit();
		editor.putString(UNREAD_MESSAGES, messages);
		editor.commit();
	}


}

/*
 * Logger.java
 * Flo2Cash
 * 
 * Created by Sanket Patel on 2/18/13.
 * Copyright (c) 2013 Xerces Technologies Pvt. Ltd. All rights reserved.
 */
package app.prop.propshelf.utils;

import android.util.Log;


/**
 * Logger class is used to print the messages/error in console. This class is for developers purpose only
 * 
 */
public class Logger 
{
	// APP_TAG is the String which indicates the print statement in Console is in  Application
	public static final String APP_TAG = "PropShelf:";
	
	/**
	 *  logger() method used to print the INFO statements in Logger view with TAG "flo2cash"
	 */
	public static void logger(String msg) 
	{
		Log.d(APP_TAG, APP_TAG+" "+msg);
	}
	
	/**
	 *  logger() method used to print the INFO statements in Logger view with a specified TAG value
	 */
	public static void logger(String tag, String msg)
	{
		Log.i(tag, APP_TAG+" "+msg);
	}
	public static void loggerCheck(String tag, String msg)
	{
		Log.i(tag,"loggerCheck//: "+msg);
	}
	/**
	 *  logger() method is used to print the error log in Logger view with TAG "flo2cash"
	 *  
	 */
	public static void errorLog(String message) 
	{
			Log.e(APP_TAG, APP_TAG+" "+message);
	}
	
}
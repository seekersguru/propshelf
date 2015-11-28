package app.prop.propshelf;

import android.app.Application;
import android.content.Context;

public class PropShelf extends Application {
	private static String TAG = "APP Class";
	private static Context context;

	@Override
	public void onCreate() {
		super.onCreate();
		PropShelf.context = getApplicationContext();

		try {
			Class.forName("android.os.AsyncTask");

		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
	}
	
	
	public static Context getAppContext() {
		return PropShelf.context;
	}

	@Override
	public void onTerminate() {
		super.onTerminate();

	}
}

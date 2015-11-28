package app.prop.propshelf;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;

import app.prop.propshelf.utils.PreferenceManager;

public class Splash extends Activity {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_splash);

	}

	@Override
	protected void onResume() {
		// TODO Auto-generated method stub
		super.onResume();

		new Thread() {

			@Override
			public void run() {

				try {
					sleep(2 * 1000);

					if (PreferenceManager.getCurrentUser(Splash.this)!=null)
					{
						Intent intent = new Intent(Splash.this, Main.class);
						startActivity(intent);
						finish();
					}else
					{
						Intent intent = new Intent(Splash.this, SocialRegister.class);
						startActivity(intent);
						finish();
					}

				} catch (Exception e) {
                    e.printStackTrace();
				}
			}
		}.start();
	}

	private void diaogToFinishOnNoInternet() {

		AlertDialog.Builder dialogBuilder = new AlertDialog.Builder(this);
		dialogBuilder.setMessage("No Internet Connection");
		dialogBuilder.setPositiveButton("OK",
				new DialogInterface.OnClickListener() {

					@Override
					public void onClick(DialogInterface arg0, int arg1) {
						// code to close application and remove it from stack
						// too.
						Splash.this.finish();

					}
				});
		dialogBuilder.setTitle("Connection Error");
		dialogBuilder.setCancelable(false);
		AlertDialog alertDialog = dialogBuilder.create();
		alertDialog.show();

	}

}
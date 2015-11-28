package app.prop.propshelf;

import android.content.Intent;
import android.content.res.Resources;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarActivity;
import android.view.MenuItem;
import android.view.View;
import android.widget.ExpandableListView;

import java.util.LinkedHashMap;

import app.prop.propshelf.adapter.SettingExpandableListAdapter;
import app.prop.propshelf.model.HeaderData;
import app.prop.propshelf.utils.Logger;

public class Setting extends ActionBarActivity {

	private String[] headings;
	private String[] content;
	private String[] subheading;
	private ExpandableListView settingExpandableList;
	private SettingExpandableListAdapter settingExpandableListAdapter;
	private LinkedHashMap<HeaderData, String> settingData = new LinkedHashMap<HeaderData, String>();
	private int lastExpandedPosition = -1;
	private final String TAG = "Setting";

	// drawer
	private ExpandableListView drawerList;
	private DrawerLayout drawerLayout;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_setting);

		Resources res = getResources();
		headings = new String[]{"Profile","About","Logout"};
		content = new String[]{"aa","bb","cc"};
		subheading  = new String[]{"aaaaaa","bbbbbbb","ccccccc"};

		for (int i = 0; i < headings.length; i++) {

			HeaderData headerData = new HeaderData();
			headerData.heading = headings[i];
			headerData.subHeading = subheading[i];
			settingData.put(headerData, content[i]);
		}

		settingExpandableListAdapter = new SettingExpandableListAdapter(this,
				settingData);
		settingExpandableList = (ExpandableListView) findViewById(R.id.setting_list);
		settingExpandableList.setAdapter(settingExpandableListAdapter);

		settingExpandableList
				.setOnGroupExpandListener(new ExpandableListView.OnGroupExpandListener() {

					@Override
					public void onGroupExpand(int groupPosition) {
						// TODO Auto-generated method stub

						Logger.logger("setOnGroupExpandListener=" + groupPosition);
						if (lastExpandedPosition != -1
								&& groupPosition != lastExpandedPosition) {

							settingExpandableList
									.collapseGroup(lastExpandedPosition);

						}

						lastExpandedPosition = groupPosition;

					}
				});

		
		settingExpandableList
				.setOnGroupClickListener(new ExpandableListView.OnGroupClickListener() {

					@Override
					public boolean onGroupClick(ExpandableListView parent,
							View v, int groupPosition, long id) {
						Logger.logger("setOnGroupClickListener="+groupPosition);

						switch (groupPosition) {
						case 0:

							break;
						case 1:

							Intent intent = new Intent(Intent.ACTION_SEND);
							intent.setType("plain/text");
							intent.putExtra(Intent.EXTRA_EMAIL, new String[] { "hello@gostartapp.com" });
							startActivity(Intent.createChooser(intent, ""));
							break;
						case 2:

//							Intent intent2=new Intent(Setting.this, Web.class);
//							intent2.putExtra("LINK", "http://www.gostartapp.com/privacy-policy.html");
//							intent2.putExtra("TITLE", "Privacy");
//							startActivity(intent2);
							Intent browserIntent = new Intent(Intent.ACTION_VIEW, Uri.parse("http://www.gostartapp.com/privacy-policy.html"));
							startActivity(browserIntent);
							break;
						case 3:

//							Intent intent3=new Intent(Setting.this, Web.class);
//							intent3.putExtra("LINK", "https://www.facebook.com/gostartapp");
//							intent3.putExtra("TITLE", "Facebook Page");
//							startActivity(intent3);
							
							try {
								startActivity(getOpenFacebookIntent());
							} catch (Exception e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
								
							}
//							Intent intent3 = new Intent("android.intent.category.LAUNCHER");
//							intent3.setClassName("com.facebook.katana", "com.facebook.katana.LoginActivity");
//							startActivity(intent3);
							break;
						case 4:
//							Intent intent4=new Intent(Setting.this, Web.class);
//							intent4.putExtra("LINK", "www.twitter.com/gostartapp");
//							intent4.putExtra("TITLE", "Twiter Page");
//							startActivity(intent4);
							try {
								   startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse("twitter://user?screen_name=gostartapp" )));
								}catch (Exception e) {
								   startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse("https://twitter.com/#!/gostartapp")));
								}
							break;
						case 5:
//							Intent intent5=new Intent(Setting.this, Web.class);
//							intent5.putExtra("LINK", "www.gostartapp.com");
//							intent5.putExtra("TITLE", "StartApp Website");
//							startActivity(intent5);
							Intent intent5 = new Intent(Intent.ACTION_VIEW, Uri.parse("http://www.gostartapp.com"));
							startActivity(intent5);
							break;
						default:
							break;
						}

					
						return true;
					}
				});

		
		// drawer
//		drawerIntents = DrawerIntentProvider.getIntentList(this, drawerIntents);
		drawerList = (ExpandableListView) findViewById(R.id.drawer);
		drawerLayout = (DrawerLayout) findViewById(R.id.drawerLayout);
		/*drawerToggleListener = new ActionBarDrawerToggle(this, drawerLayout,
				R.drawable.nav_option_icon, R.string.open, R.string.close) {

			@Override
			public void onDrawerClosed(View drawerView) {
				super.onDrawerClosed(drawerView);
			}

			@Override
			public void onDrawerOpened(View drawerView) {
				super.onDrawerOpened(drawerView);
			}
		};*/
		getSupportActionBar().setHomeButtonEnabled(true);
		getSupportActionBar().setDisplayHomeAsUpEnabled(true);
		getSupportActionBar().setDisplayShowTitleEnabled(true);
		getSupportActionBar().setTitle("About StartApp");

		// drawer
		// get categorised list of NB //categorisedNB(getNoticeBoard());
		// create hash map to send in adapter //createHashMap();
		/*drawerAdapter = new DrawerAdapter(this, getResources(), drawerData);
		drawerList.setAdapter(drawerAdapter);

		// drawer
		drawerList
				.setOnGroupClickListener(new ExpandableListView.OnGroupClickListener() {
					@Override
					public boolean onGroupClick(
							ExpandableListView expandableListView, View view,
							int i, long l) {
						startActivity(drawerIntents.get(i));
						drawerLayout.closeDrawers();
						return false;
					}
				});*/

	}
	public Intent getOpenFacebookIntent() {

		   try {
		    getPackageManager().getPackageInfo("com.facebook.katana", 0);
		    return new Intent(Intent.ACTION_VIEW, Uri.parse("fb://page/1632475447018925"));
		   } catch (Exception e) {
		    return new Intent(Intent.ACTION_VIEW, Uri.parse("https://www.facebook.com/<user_name_here>"));
		   }
		}
	// drawer
	@Override
	public void onPostCreate(Bundle savedInstanceState) {
		super.onPostCreate(savedInstanceState);
	}

	/*
	 * // implement Action BAR
	 * 
	 * @Override public boolean onCreateOptionsMenu(Menu menu) { // Inflate the
	 * menu; this adds items to the action bar if it is present.
	 * getMenuInflater().inflate(R.menu.setting, menu); return true; }
	 */
	@Override
	public boolean onOptionsItemSelected(MenuItem item) {

		int id = item.getItemId();
		if (id == android.R.id.home) {
			finish();
		}
		return super.onOptionsItemSelected(item);
	}
}

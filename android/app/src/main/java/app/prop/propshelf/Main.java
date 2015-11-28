package app.prop.propshelf;

import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.drawable.ColorDrawable;
import android.net.Uri;
import android.os.Bundle;
import android.os.StrictMode;
import android.support.v4.app.FragmentTransaction;
import android.support.v4.view.ViewPager;
import android.support.v7.app.ActionBar;
import android.support.v7.app.ActionBar.Tab;
import android.support.v7.app.ActionBarActivity;
import android.support.v7.app.AlertDialog;
import android.view.Menu;
import android.view.MenuItem;

import app.prop.propshelf.adapter.MainPagerAdapter;
import app.prop.propshelf.fragments.GroupFragment;
import app.prop.propshelf.fragments.WallFragment;

@SuppressWarnings("deprecation")
public class Main extends ActionBarActivity implements
        WallFragment.OnFragmentInteractionListener,
        GroupFragment.OnFragmentInteractionListener {

    private final String MAIN = "main";
    private final String INDIVIDUAL = "individual";
    private final String GROUP = "group";
    private final String TAG = "Main";

    private ViewPager mainViewPager;
    private MainPagerAdapter mainPagerAdapter;
    private Intent intent;
    private ActionBar actionBar;
    private Tab TAB_CHAT;
    private Tab TAB_EXPLORE;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        StrictMode.ThreadPolicy policy = new StrictMode.ThreadPolicy.Builder()
                .permitAll().build();
        StrictMode.setThreadPolicy(policy);
        setContentView(R.layout.activity_main);

        mainViewPager = (ViewPager) findViewById(R.id.mainViewPager);
        intent = getIntent();
        actionBar = getSupportActionBar();

        ActionBar.TabListener tabListener = new ActionBar.TabListener() {
            @Override
            public void onTabSelected(Tab tab, FragmentTransaction ft) {
                mainViewPager.setCurrentItem(tab.getPosition());
            }

            @Override
            public void onTabUnselected(Tab tab,
                                        FragmentTransaction ft) {

            }

            @Override
            public void onTabReselected(Tab tab,
                                        FragmentTransaction ft) {

            }
        };

        TAB_CHAT = actionBar.newTab().setText("Chats")
                .setTabListener(tabListener);

        TAB_EXPLORE = actionBar.newTab().setText("Explore")
                .setTabListener(tabListener);

        actionBar.addTab(TAB_CHAT);
        actionBar.addTab(TAB_EXPLORE);

        getSupportActionBar().setDisplayShowTitleEnabled(true);
        getSupportActionBar().setTitle("PropShelf");
        getSupportActionBar().setNavigationMode(ActionBar.NAVIGATION_MODE_TABS);

        actionBar.setStackedBackgroundDrawable(new ColorDrawable(getResources()
                .getColor(R.color.prop_theme_color)));

        mainViewPager
                .setOnPageChangeListener(new ViewPager.OnPageChangeListener() {

                    // This method will be invoked when a new page becomes
                    // selected.
                    @Override
                    public void onPageSelected(int position) {
                        actionBar.setSelectedNavigationItem(position);

                    }

                    // This method will be invoked when the current page is
                    // scrolled
                    @Override
                    public void onPageScrolled(int position,
                                               float positionOffset, int positionOffsetPixels) {
                        // Code goes here
                    }

                    @Override
                    public void onPageScrollStateChanged(int state) {
                        // Code goes here
                    }
                });

        mainPagerAdapter = new MainPagerAdapter(getSupportFragmentManager());
        mainViewPager.setAdapter(mainPagerAdapter);
        mainViewPager.setCurrentItem(0);
    }

    @Override
    protected void onResume() {
        super.onResume();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        // drawer
        int id = item.getItemId();

        // noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            Intent intent = new Intent(this, Setting.class);
            startActivity(intent);

        } else if (id == R.id.action_new_group) {
            Intent intent = new Intent(this, GroupCreate.class);
            startActivity(intent);
        }

        return super.onOptionsItemSelected(item);
    }

    public void ShowAlertDialog(String title, String message) {

        String positiveBtn = "Ok";
        final AlertDialog alert = new AlertDialog.Builder(this)
                .setPositiveButton(positiveBtn,
                        new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialog,
                                                int which) {
                            }
                        }).create();

        if (title != null)
            alert.setTitle(title);

        if (message != null)
            alert.setMessage(message);
        alert.show();
    }

    @Override
    public void onFragmentInteraction(Uri uri) {
        // TODO Auto-generated method stub

    }

}

package app.prop.propshelf;

import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.support.v7.app.ActionBar;
import android.support.v7.app.ActionBarActivity;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.Window;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ListView;
import android.widget.TextView;

import java.util.ArrayList;
import java.util.List;

import app.prop.propshelf.adapter.GroupListAdapter;
import app.prop.propshelf.model.GroupData;


@SuppressWarnings("deprecation")
public class UserDetail extends ActionBarActivity {

    private ActionBar actionBar;
    private ListView user_list;
    private GroupListAdapter groupAdapter;
    private List<GroupData> groups = new ArrayList<GroupData>();
    private TextView userName;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        getWindow().requestFeature(Window.FEATURE_ACTION_BAR_OVERLAY);
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_userdetail);

        actionBar = getSupportActionBar();

        actionBar.setDisplayHomeAsUpEnabled(true);
        actionBar.setHomeButtonEnabled(true);
        actionBar.setBackgroundDrawable(new ColorDrawable(getResources()
                .getColor(R.color.prop_semi_theme_color)));
        actionBar.setStackedBackgroundDrawable(new ColorDrawable(getResources()
                .getColor(R.color.prop_semi_theme_color)));


        String name = getIntent().getStringExtra("USER");
        userName = (TextView) findViewById(R.id.userName);
        userName.setText(name);

        user_list = (ListView) findViewById(R.id.user_list);
        groupAdapter = new GroupListAdapter(this, R.layout.group_list_item_short, groups);
        user_list.setAdapter(groupAdapter);
        user_list.setOnItemClickListener(new OnItemClickListener() {

            @Override
            public void onItemClick(AdapterView<?> arg0, View arg1, int arg2,
                                    long arg3) {
                // TODO Auto-generated method stub

            }
        });
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.main, menu);

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
            return true;
        } else if (id == android.R.id.home) {
            finish();
        }

        return super.onOptionsItemSelected(item);
    }
}

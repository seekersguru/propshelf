package app.prop.propshelf;

import android.content.Context;
import android.content.Intent;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.support.v7.app.ActionBar;
import android.support.v7.app.ActionBarActivity;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.Window;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.reflect.TypeToken;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;

import app.prop.propshelf.adapter.ParticipantsAdapter;
import app.prop.propshelf.async.GetDataFromServer;
import app.prop.propshelf.model.ResponseData;
import app.prop.propshelf.model.WallUser;
import app.prop.propshelf.model.WallUserNew;
import app.prop.propshelf.network.IAsyncTaskCompleteListener;
import app.prop.propshelf.utils.Constants;


@SuppressWarnings("deprecation")
public class GroupDetail extends ActionBarActivity {

	private ActionBar actionBar;
	private ListView user_list;
	private ParticipantsAdapter adapter;
	private ArrayList<WallUser> users;
	private TextView groupName;
    private Context context;
    private WallUser group;

    @Override
	protected void onCreate(Bundle savedInstanceState) {
		getWindow().requestFeature(Window.FEATURE_ACTION_BAR_OVERLAY);
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_groupdetail);
        context=this;
		actionBar = getSupportActionBar();

		actionBar.setDisplayHomeAsUpEnabled(true);
		actionBar.setHomeButtonEnabled(true);
		actionBar.setBackgroundDrawable(new ColorDrawable(getResources()
				.getColor(R.color.prop_semi_theme_color)));
		actionBar.setStackedBackgroundDrawable(new ColorDrawable(getResources()
				.getColor(R.color.prop_semi_theme_color)));

//		int titleId = getResources().getIdentifier("action_bar_title", "id", "android");
//		TextView abTitle = (TextView) findViewById(titleId);
//		abTitle.setTextColor(android.R.color.transp);

		String strGroup = getIntent().getStringExtra("GROUP");
        group=new Gson().fromJson(strGroup,WallUser.class);

		groupName = (TextView) findViewById(R.id.groupName);

		groupName.setText(group.name);

		user_list = (ListView) findViewById(R.id.user_list);
		user_list.setOnItemClickListener(new AdapterView.OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1, int position,
									long arg3) {
				Toast.makeText(GroupDetail.this, " Clicked on Group", Toast.LENGTH_SHORT).show();
				Intent intent = new Intent(GroupDetail.this, UserDetail.class);
				intent.putExtra("USER", users.get(position).firstName + " " + users.get(position).lastName);
                intent.putExtra("USERID", users.get(position).id);
				startActivity(intent);
			}
		});
        loadMembers();
    }

    private void loadMembers() {
//        http://surveyglass.in/api/thread/group_13_22/
        String url = Constants.BASE_URL + Constants.GROUP_USER;
        GetDataFromServer getData = new GetDataFromServer(new IAsyncTaskCompleteListener<ResponseData>() {
            @Override
            public void OnTaskSuccess(ResponseData result, int count) {
                try {
                    JSONObject jsonObject = new JSONObject(result.getResponse());
                    String success = jsonObject.getString("success");
                    if (success != null) {
                        JSONArray jsonArray = jsonObject.getJSONArray("json");

                        Type collectionType = new TypeToken<List<WallUserNew>>() {
                        }.getType();

						List<WallUserNew> list= new Gson().fromJson(jsonArray.toString(), collectionType);
						users=new ArrayList<>();
						for (WallUserNew u : list)
						{
							WallUser user=new WallUser();
							user.id=Integer.parseInt(u.id);
							user.name=u.name;
							user.firstName=u.firstName;
							user.lastName=u.lastName;
							//user.role=u.role;
							user.imageUrl=u.imageUrl;

							users.add(user);
						}
//                        users = new Gson().fromJson(jsonArray.toString(), collectionType);

                        adapter = new ParticipantsAdapter(context, R.layout.user_list_item, users);
                        user_list.setAdapter(adapter);


                    } else {
                        Toast.makeText(context, "Opps! try later...", Toast.LENGTH_SHORT).show();
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }

            @Override
            public void OnTaskError(ResponseData result, int count) {

            }
        }, 1, Constants.METHOD_POST);

        JsonObject jsonObject=new JsonObject();
        jsonObject.addProperty("group_id", group.id+"");

        getData.setLoaderMessage("Loading...");
        getData.InitialiseRequest(context, url, jsonObject.toString(), true);
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

package app.prop.propshelf;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.support.v7.app.ActionBar;
import android.support.v7.app.ActionBarActivity;
import android.text.TextUtils;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.Window;
import android.widget.EditText;
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

import app.prop.propshelf.async.GetDataFromServer;
import app.prop.propshelf.model.GroupRequest;
import app.prop.propshelf.model.ResponseData;
import app.prop.propshelf.network.IAsyncTaskCompleteListener;
import app.prop.propshelf.utils.Constants;
import app.prop.propshelf.utils.Logger;


@SuppressWarnings("deprecation")
public class GroupCreate extends ActionBarActivity {

    private ActionBar actionBar;
    private EditText groupName, groupDescription,groupCity, groupLocation;
    private ArrayList<String> cities;
    private ArrayList<String> subLocations;
    private Context context;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        getWindow().requestFeature(Window.FEATURE_ACTION_BAR_OVERLAY);
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_groupcreate);
        context = this;
        actionBar = getSupportActionBar();
        actionBar.setDisplayShowTitleEnabled(true);
        actionBar.setDisplayHomeAsUpEnabled(true);
        actionBar.setHomeButtonEnabled(true);
        actionBar.setBackgroundDrawable(new ColorDrawable(getResources()
                .getColor(R.color.prop_theme_color)));
        actionBar.setStackedBackgroundDrawable(new ColorDrawable(getResources()
                .getColor(R.color.prop_theme_color)));

        actionBar.setTitle("Create Group");

        groupName = (EditText) findViewById(R.id.groupName);
        groupDescription = (EditText) findViewById(R.id.groupDescription);
        groupLocation = (EditText) findViewById(R.id.groupLocation);
        groupCity= (EditText) findViewById(R.id.groupCity);

        groupCity.setOnFocusChangeListener(new View.OnFocusChangeListener() {
            @Override
            public void onFocusChange(View view, boolean b) {
                Toast.makeText(context,"Aaa gaya cities me",Toast.LENGTH_SHORT).show();
                showCities();
            }
        });

        groupLocation.setOnFocusChangeListener(new View.OnFocusChangeListener() {
            @Override
            public void onFocusChange(View view, boolean b) {
                Toast.makeText(context,"Aaa gaya cities me",Toast.LENGTH_SHORT).show();
            }
        });

        String url = Constants.BASE_URL + Constants.CITIES;
        GetDataFromServer getData = new GetDataFromServer(new IAsyncTaskCompleteListener<ResponseData>() {
            @Override
            public void OnTaskSuccess(ResponseData result, int count) {
                try {
                    JSONObject jsonObject = new JSONObject(result.getResponse());
                    JSONArray jsonArray = jsonObject.getJSONArray("json");

                    Type collectionType = new TypeToken<List<String>>() {
                    }.getType();

                    if (jsonArray!=null)
                    {
                        cities = new Gson().fromJson(jsonArray.toString(), collectionType);
                    }else{
                        cities =new ArrayList<>();
                    }

                } catch (JSONException e) {
                    e.printStackTrace();
                }

            }

            @Override
            public void OnTaskError(ResponseData result, int count) {
            }
        }, 1, Constants.METHOD_GET);

        getData.setLoaderMessage("Fetching Cities");
        getData.InitialiseRequest(context, url, null, true);

    }

    protected void showCities() {
        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setTitle("Select City");
        String items[] = new String[cities.size()];
        items=cities.toArray(items);
        final String[] finalItems = items;

        builder.setItems(items, new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int item) {
                groupCity.setText(finalItems[item]);
                getSubLocationsByCity(finalItems[item]);
            }
        });
        AlertDialog alert = builder.create();
        alert.show();
    }
    protected void showSubLocations() {
        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setTitle("Select Location");
        String items[] = new String[cities.size()];
        items=subLocations.toArray(items);
        final String[] finalItems = items;

        builder.setItems(items, new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int item) {
                groupLocation.setText(finalItems[item]);
            }
        });
        AlertDialog alert = builder.create();
        alert.show();
    }
    private void getSubLocationsByCity(String city) {
        String url = Constants.BASE_URL+Constants.SUB_LOCATIONS;

        GetDataFromServer getData = new GetDataFromServer(new IAsyncTaskCompleteListener<ResponseData>() {
            @Override
            public void OnTaskSuccess(ResponseData result, int count) {
                try {
                    JSONObject jsonObject = new JSONObject(result.getResponse());
                    JSONArray jsonArray = jsonObject.getJSONArray("sublocs");

                    Type collectionType = new TypeToken<List<String>>() {
                    }.getType();

                    if (jsonArray!=null)
                    {
                        subLocations = new Gson().fromJson(jsonArray.toString(), collectionType);
                    }else
                    {
                        subLocations =new ArrayList<>();
                    }
                    showSubLocations();

                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }

            @Override
            public void OnTaskError(ResponseData result, int count) {
            }
        }, 1, Constants.METHOD_POST);

        JsonObject jsonObject=new JsonObject();
        jsonObject.addProperty("city_name", city);
        getData.setLoaderMessage("Fetching locations");
        getData.InitialiseRequest(context, url, jsonObject.toString(), true);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_groupcreate, menu);

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
        } else if (id == R.id.action_group_create) {
            Logger.logger(groupName.getText().toString() + "," + groupDescription.getText().toString());
            createGroup();
        }

        return super.onOptionsItemSelected(item);
    }

    private void createGroup() {
        GroupRequest groupRequest = new GroupRequest();
        groupRequest.name = groupName.getText().toString();
        groupRequest.description = groupDescription.getText().toString();
        if(TextUtils.isEmpty(groupCity.getText().toString()))
        {
            Toast.makeText(context,"Please Select City",Toast.LENGTH_SHORT).show();
            return;
        }
        groupRequest.city = groupCity.getText().toString();
        groupRequest.location = groupLocation.getText().toString();

        String url = Constants.BASE_URL + Constants.GROUP;

        GetDataFromServer getData = new GetDataFromServer(new IAsyncTaskCompleteListener<ResponseData>() {
            @Override
            public void OnTaskSuccess(ResponseData result, int count) {
                Toast.makeText(GroupCreate.this, "Group created successfully", Toast.LENGTH_SHORT).show();
                finish();
            }

            @Override
            public void OnTaskError(ResponseData result, int count) {
                Toast.makeText(GroupCreate.this, result.getErrorMessage(), Toast.LENGTH_SHORT).show();
            }
        }, 1, Constants.METHOD_POST);

        getData.setLoaderMessage("Creating Group");
        getData.InitialiseRequest(this, url, new Gson().toJson(groupRequest), true);
    }
}

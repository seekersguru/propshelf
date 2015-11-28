package app.prop.propshelf;

import android.content.Context;
import android.content.Intent;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.support.v7.app.ActionBar;
import android.support.v7.app.ActionBarActivity;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;

import app.prop.propshelf.adapter.ChatAdapter;
import app.prop.propshelf.async.GetDataFromServer;
import app.prop.propshelf.model.MessageRequest;
import app.prop.propshelf.model.MessageResponse;
import app.prop.propshelf.model.ResponseData;
import app.prop.propshelf.model.WallData;
import app.prop.propshelf.model.WallUser;
import app.prop.propshelf.network.IAsyncTaskCompleteListener;
import app.prop.propshelf.utils.Constants;

public class GroupChat extends ActionBarActivity implements View.OnClickListener {

    //	:app:transformClassesWithDexForDebug' TransformException: com.android.ide.common.process.ProcessException: org.gradle.process.internal.ExecException
    private ActionBar actionBar;
    private ListView chatList;
    private ChatAdapter adapter;
//    private ArrayList<User> messages;
    private EditText editText;

    private Context context;
    private WallData wallItem;
    private ArrayList<WallData> messages;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_chat);

        context=this;
        actionBar = getSupportActionBar();

        getSupportActionBar().setHomeButtonEnabled(true);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        getSupportActionBar().setDisplayShowHomeEnabled(true);
        getSupportActionBar().setDisplayShowTitleEnabled(false);

        wallItem = new Gson().fromJson(getIntent().getStringExtra("WALLITEM"), WallData.class);

        /////////////////////////////////////////////////////////////////////////////////

//        actionBar.setDisplayShowHomeEnabled(false);
//        actionBar.setDisplayShowTitleEnabled(false);
//        actionBar.setDisplayShowTitleEnabled(true);

        LayoutInflater mInflater = LayoutInflater.from(this);

        View mCustomView = mInflater.inflate(R.layout.action_bar_title_item, null);
        TextView mTitleTextView = (TextView) mCustomView.findViewById(R.id.action_bar_title);
        mTitleTextView.setText(wallItem.reciepents.get(0).name);
        ////////////////////////////////////////////////////////////////////////////////
        actionBar.setBackgroundDrawable(new ColorDrawable(getResources()
                .getColor(R.color.prop_theme_color)));
        actionBar.setStackedBackgroundDrawable(new ColorDrawable(getResources()
                .getColor(R.color.prop_theme_color)));

        actionBar.setCustomView(mCustomView);
        actionBar.setDisplayShowCustomEnabled(true);



//        actionBar.setTitle(wallItem.reciepents.get(0).name);

        mTitleTextView.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {
                //Do something
                if (wallItem.isGroup == 1) {
                    Intent intent = new Intent(GroupChat.this, GroupDetail.class);
                    intent.putExtra("GROUP", new Gson().toJson(wallItem.reciepents.get(0)));
                    startActivity(intent);
                } else {
                    Intent intent = new Intent(GroupChat.this, UserDetail.class);
                    intent.putExtra("USER", new Gson().toJson(wallItem.reciepents.get(0)));
                    startActivity(intent);
                }
            }
        });


        messages = new ArrayList<WallData>();
        chatList = (ListView) findViewById(R.id.chat);
        editText = (EditText) findViewById(R.id.msg_edit_box);


       /* chatList.setOnItemClickListener(new OnItemClickListener() {

            @Override
            public void onItemClick(AdapterView<?> arg0, View arg1, int position,
                                    long arg3) {
                Intent intent = new Intent(GroupChat.this, UserDetail.class);
                intent.putExtra("USER", messages.get(position).getFname() + " " + messages.get(position).getLname());
                startActivity(intent);
            }
        });
        */
        loadMessages();
    }


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_group_chat, menu);

        return true;
    }

    private void loadMessages() {
//        http://surveyglass.in/api/thread/group_13_22/
        String url = Constants.BASE_URL + Constants.THREAD+wallItem.threadId+"/";
        GetDataFromServer getData = new GetDataFromServer(new IAsyncTaskCompleteListener<ResponseData>() {
            @Override
            public void OnTaskSuccess(ResponseData result, int count) {
                try {
                    JSONObject jsonObject = new JSONObject(result.getResponse());
                    String success = jsonObject.getString("success");
                    if (success != null && success.equals("Done")) {
                        JSONArray jsonArray = jsonObject.getJSONArray("json");

                        Type collectionType = new TypeToken<List<WallData>>() {
                        }.getType();
                        messages = new Gson().fromJson(jsonArray.toString(), collectionType);

                        adapter = new ChatAdapter(context, R.layout.chat_message_left, messages);
                        chatList.setAdapter(adapter);

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
        }, 1, Constants.METHOD_GET);

        getData.setLoaderMessage("Loading wall...");
        getData.InitialiseRequest(context, url, null, true);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar Fitem clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        // drawer
        int id = item.getItemId();

        if (id == R.id.action_settings) {
            return true;
        } else if (id == android.R.id.home) {
            finish();
        }

        return super.onOptionsItemSelected(item);
    }

    @Override
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.share:
                break;
            case R.id.post:
                String text = editText.getText().toString();
                if (text.trim().length() > 0) {
                    postMessage();
                }
                break;
            default:
                break;
        }
    }

    private void postMessage() {

        String url = Constants.BASE_URL + Constants.MESSAGE;

        MessageRequest request=new MessageRequest();
        request.text=editText.getText().toString();

        if (wallItem.isGroup==1)
        {
            request.group=new ArrayList<>();
                request.group.add(wallItem.reciepents.get(0).id);
        }else {
            request.reciepents=new ArrayList<>();
            request.reciepents.add(wallItem.reciepents.get(0).id);
        }

        GetDataFromServer getData = new GetDataFromServer(new IAsyncTaskCompleteListener<ResponseData>() {
            @Override
            public void OnTaskSuccess(ResponseData result, int count) {
                try {
                    JSONObject jsonObject = new JSONObject(result.getResponse());
                    String success = jsonObject.getString("success");
                    if (success != null) {
                        JSONArray jsonArray = jsonObject.getJSONArray("json");

                        Type collectionType = new TypeToken<List<MessageResponse>>() {
                        }.getType();
                        ArrayList<MessageResponse> message= new Gson().fromJson(jsonArray.toString(), collectionType);
                        WallData data=new WallData();
                        data.createdBy=new WallUser();
                        data.createdBy.name="sanket";
                        data.createdBy.id=101;
                        data.text=message.get(0).messageText;
                        messages.add(data);
                        adapter.notifyDataSetChanged();
                    } else {
                        Toast.makeText(context, "Opps! try later...", Toast.LENGTH_SHORT).show();
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            @Override
            public void OnTaskError(ResponseData result, int count) {

            }
        }, 1, Constants.METHOD_POST);

        getData.setLoaderMessage("Sending message...");
        getData.InitialiseRequest(context, url, new Gson().toJson(request), true);
    }
}

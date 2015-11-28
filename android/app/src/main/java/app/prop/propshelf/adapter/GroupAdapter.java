package app.prop.propshelf.adapter;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CompoundButton;
import android.widget.CompoundButton.OnCheckedChangeListener;

import com.google.gson.JsonObject;

import java.util.List;

import app.prop.propshelf.R;
import app.prop.propshelf.async.GetDataFromServer;
import app.prop.propshelf.holder.GroupHolder;
import app.prop.propshelf.model.GroupData;
import app.prop.propshelf.model.ResponseData;
import app.prop.propshelf.network.IAsyncTaskCompleteListener;
import app.prop.propshelf.utils.Constants;
import app.prop.propshelf.utils.Logger;

public class GroupAdapter extends RecyclerView.Adapter<GroupHolder> {

    private List<GroupData> noticeDatas;
    public String TAG = "Notice Grid Adapter";
    private Context context;
    private ClickListener clickListener;

    public GroupAdapter(List<GroupData> noticeDatas, Context context) {

        this.noticeDatas = noticeDatas;
        this.context = context;
    }

    @Override
    public GroupHolder onCreateViewHolder(ViewGroup parent, int viewType) {

        View itemView = LayoutInflater.from(context).inflate(
                R.layout.group_list_item, parent, false);
        GroupHolder ngh = new GroupHolder(itemView, clickListener);
        return ngh;
    }

    public void setClickListener(ClickListener clickListener) {
        this.clickListener = clickListener;
    }

    @Override
    public void onBindViewHolder(final GroupHolder holder, final int position) {
        // holder.pinTop.bringToFront();
        final GroupData data = noticeDatas.get(position);
        holder.userName.setText(data.name);
        holder.btnJoined.setChecked(data.joined == 1 ? true : false);
        if (data.joined == 1 ? true : false) {
            holder.btnJoined.setBackgroundResource(R.drawable.prop_textstyle);
            holder.btnJoined
                    .setTextAppearance(context, R.style.PropButtonStyle);
        } else {
            holder.btnJoined
                    .setBackgroundResource(R.drawable.prop_textstyle_inverse);
            holder.btnJoined.setTextAppearance(context,
                    R.style.PropButtonStyleInverse);
        }

        holder.btnJoined.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                holder.btnJoined.setChecked(!holder.btnJoined.isChecked());
                Logger.logger("holder.btnJoined=" + holder.btnJoined.isChecked());
                if (!holder.btnJoined.isChecked()) {

                    String url = Constants.BASE_URL + Constants.JOIN_GROUP;
                    GetDataFromServer getData = new GetDataFromServer(new IAsyncTaskCompleteListener<ResponseData>() {
                        @Override
                        public void OnTaskSuccess(ResponseData result, int count) {

                            holder.btnJoined.setChecked(true);
                            holder.btnJoined
                                    .setBackgroundResource(R.drawable.prop_textstyle);
                            holder.btnJoined.setTextAppearance(context,
                                    R.style.PropButtonStyle);

                        }

                        @Override
                        public void OnTaskError(ResponseData result, int count) {
                            holder.btnJoined.setChecked(false);
                            holder.btnJoined
                                    .setBackgroundResource(R.drawable.prop_textstyle_inverse);
                            holder.btnJoined.setTextAppearance(context,
                                    R.style.PropButtonStyleInverse);
                        }
                    }, 1, Constants.METHOD_POST);

                    JsonObject jsonObject = new JsonObject();
                    jsonObject.addProperty("group_id", data.id);
                    getData.setLoaderMessage("Joining Group");
                    getData.InitialiseRequest(context, url, jsonObject.toString(), true);

                } else {

                    String url = Constants.BASE_URL + Constants.UNJOIN_GROUP;
                    GetDataFromServer getData = new GetDataFromServer(new IAsyncTaskCompleteListener<ResponseData>() {
                        @Override
                        public void OnTaskSuccess(ResponseData result, int count) {
                            holder.btnJoined.setChecked(false);
                            holder.btnJoined
                                    .setBackgroundResource(R.drawable.prop_textstyle_inverse);
                            holder.btnJoined.setTextAppearance(context,
                                    R.style.PropButtonStyleInverse);
                        }

                        @Override
                        public void OnTaskError(ResponseData result, int count) {
                            holder.btnJoined.setChecked(true);
                            holder.btnJoined
                                    .setBackgroundResource(R.drawable.prop_textstyle);
                            holder.btnJoined.setTextAppearance(context,
                                    R.style.PropButtonStyle);
                        }
                    }, 1, Constants.METHOD_POST);

                    JsonObject jsonObject = new JsonObject();
                    jsonObject.addProperty("group_id", data.id);
                    getData.setLoaderMessage("UnJoining Group");
                    getData.InitialiseRequest(context, url, jsonObject.toString(), true);
                }

            }
        });

        holder.btnJoined
                .setOnCheckedChangeListener(new OnCheckedChangeListener() {

                    @Override
                    public void onCheckedChanged(CompoundButton arg0,
                                                 boolean arg1) {


                    }
                });
    }

    @Override
    public int getItemCount() {
        return noticeDatas.size();
    }

    public interface ClickListener {
        public void itemClicked(View view, int position);
    }
}

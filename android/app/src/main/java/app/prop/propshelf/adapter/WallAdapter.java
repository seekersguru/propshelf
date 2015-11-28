package app.prop.propshelf.adapter;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import java.util.List;

import app.prop.propshelf.R;
import app.prop.propshelf.holder.WallHolder;
import app.prop.propshelf.model.WallData;

public class WallAdapter extends RecyclerView.Adapter<WallHolder> {


    private List<WallData> noticeDatas;
    private Context context;
    private ClickListener clickListener;

    public WallAdapter(List<WallData> noticeDatas, Context context){

        this.noticeDatas = noticeDatas;
        this.context = context;
    }


    @Override
    public WallHolder onCreateViewHolder(ViewGroup parent, int viewType) {

        View itemView = LayoutInflater.from(context).inflate(R.layout.wall_list_item, parent, false);
        WallHolder ngh =new WallHolder(itemView,clickListener);

        return ngh;
    }

    public void setClickListener(ClickListener clickListener){
        this.clickListener = clickListener;
        
    }

    @Override
    public void onBindViewHolder(final WallHolder holder, final int position) {
        //holder.pinTop.bringToFront();
        WallData data = noticeDatas.get(position);
        holder.userName.setText(data.reciepents.get(0).name);
        holder.textMessage.setText(data.text);
        if (data.isGroup==1)
        {
            holder.profilePic.setBackgroundResource(R.drawable.groupicon);
            holder.profilePic.setImageResource(R.drawable.groupicon);
        }else
        {
            holder.profilePic.setBackgroundResource(R.drawable.profile_placeholder);
            holder.profilePic.setImageResource(R.drawable.profile_placeholder);
        }
    }

    @Override
    public int getItemCount() {
        return noticeDatas.size();
    }


    public interface ClickListener {
        public void itemClicked(View view, int position);
    }
}

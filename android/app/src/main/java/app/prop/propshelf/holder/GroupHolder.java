package app.prop.propshelf.holder;

import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.ToggleButton;

import app.prop.propshelf.R;
import app.prop.propshelf.adapter.GroupAdapter;


public class GroupHolder extends RecyclerView.ViewHolder implements View.OnClickListener {

    public ImageView profilePic;
    public ToggleButton btnJoined;
    public TextView userName;
    public GroupAdapter.ClickListener clickListener;

    public GroupHolder(View itemView, GroupAdapter.ClickListener clickListener) {
        super(itemView);

        itemView.setOnClickListener(this);
        profilePic = (ImageView)itemView.findViewById(R.id.profile_pic);
        btnJoined = (ToggleButton)itemView.findViewById(R.id.btnJoined);
        userName = (TextView)itemView.findViewById(R.id.userName);
        this.clickListener = clickListener;
    }

    @Override
    public void onClick(View view) {

        if(clickListener!=null){
            clickListener.itemClicked(view,getPosition());
        }
    }
}

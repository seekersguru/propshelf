package app.prop.propshelf.holder;

import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import app.prop.propshelf.R;
import app.prop.propshelf.adapter.WallAdapter;

/**
 * Created by adm on 4/8/2015.
 */
public class WallHolder extends RecyclerView.ViewHolder implements View.OnClickListener {

    public ImageView profilePic;
    public TextView textMessage;
    public TextView userName;
    public WallAdapter.ClickListener clickListener;

    public WallHolder(View itemView, WallAdapter.ClickListener clickListener) {
        super(itemView);

        itemView.setOnClickListener(this);
        profilePic = (ImageView)itemView.findViewById(R.id.profile_pic);
        textMessage = (TextView)itemView.findViewById(R.id.textMessage);
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

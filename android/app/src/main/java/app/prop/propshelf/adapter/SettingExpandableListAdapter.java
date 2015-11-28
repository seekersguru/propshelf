package app.prop.propshelf.adapter;


import android.content.Context;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseExpandableListAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;

import app.prop.propshelf.R;
import app.prop.propshelf.model.HeaderData;


public class SettingExpandableListAdapter extends BaseExpandableListAdapter {
	
	private Context context;
	private LinkedHashMap<HeaderData, String> settingData;
	private List<HeaderData> header;
	private final String TAG = "SettingAdapter";
	
	
	public SettingExpandableListAdapter(Context context, LinkedHashMap<HeaderData, String> settingData) {
		this.context = context;
		this.settingData = settingData;
		this.header = new ArrayList<HeaderData>(settingData.keySet());

	}
	
	
	
	

	@Override
	public int getGroupCount() {
		// TODO Auto-generated method stub
		return header.size();
	}

	@Override
	public int getChildrenCount(int groupPosition) {
		// TODO Auto-generated method stub
		return 0;
		/*if(groupPosition <=2) {
			return 1;
		}else {
			return 0; //no child for the last two setting option.
		}*/
	}

	@Override
	public Object getGroup(int groupPosition) {
		// TODO Auto-generated method stub
		return header.get(groupPosition);
	}

	@Override
	public Object getChild(int groupPosition, int childPosition) {
		// TODO Auto-generated method stub
		return settingData.get(header.get(groupPosition));
	}

	@Override
	public long getGroupId(int groupPosition) {
		// TODO Auto-generated method stub
		return groupPosition;
	}

	@Override
	public long getChildId(int groupPosition, int childPosition) {
		// TODO Auto-generated method stub
		return childPosition;
	}

	@Override
	public boolean hasStableIds() {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public View getGroupView(int groupPosition, boolean isExpanded,
			View convertView, ViewGroup parent) {
		// TODO Auto-generated method stub
		if(convertView == null) {
			LayoutInflater inflate =(LayoutInflater)context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
			convertView = inflate.inflate(R.layout.setting_header_list, parent,false);
		}
		
		HeaderData headerDataObject = (HeaderData) getGroup(groupPosition);
		
		ImageView listIcon = (ImageView) convertView.findViewById(R.id.list_icon);
		Log.i(TAG, "position " + groupPosition);
		switch(groupPosition) {
			case 0:{

			listIcon.setBackgroundResource(R.drawable.profile);
			listIcon.setImageResource(R.drawable.profile);
			break;
			}
			case 1:{

			listIcon.setBackgroundResource(R.drawable.about);
			listIcon.setImageResource(R.drawable.about);
			break;
			}
			case 2:{

			listIcon.setBackgroundResource(R.drawable.logout);
			listIcon.setImageResource(R.drawable.logout);
			break;
			}

			default: Log.i(TAG, "header list running out of required index");
		}
		
		TextView settingListHeading = (TextView)convertView.findViewById(R.id.setting_list_heading);
		settingListHeading.setText(headerDataObject.heading);
		TextView settingListSubheading = (TextView)convertView.findViewById(R.id.setting_list_subheading);
		settingListSubheading.setVisibility(View.GONE);
//		settingListSubheading.setText(headerDataObject.subHeading);
		
		return convertView;
	}

	@Override
	public View getChildView(int groupPosition, int childPosition,
			boolean isLastChild, View convertView, ViewGroup parent) {
		// TODO Auto-generated method stub
		if(convertView == null) {
			LayoutInflater inflate =(LayoutInflater)context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
			convertView = inflate.inflate(R.layout.setting_child_list, parent, false);
		}
		
		TextView settingListChild = (TextView)convertView.findViewById(R.id.content);
		settingListChild.setText((String)getChild(groupPosition, childPosition));
		
		return convertView;
	}

	@Override
	public boolean isChildSelectable(int groupPosition, int childPosition) {
		// TODO Auto-generated method stub
		return false;
	}

}

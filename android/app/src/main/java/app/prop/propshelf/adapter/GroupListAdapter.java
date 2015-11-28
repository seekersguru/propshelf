package app.prop.propshelf.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.CompoundButton;
import android.widget.CompoundButton.OnCheckedChangeListener;
import android.widget.TextView;
import android.widget.ToggleButton;

import java.util.List;

import app.prop.propshelf.R;
import app.prop.propshelf.model.GroupData;

public class GroupListAdapter extends ArrayAdapter<GroupData> {

	private Context context;
	private List<GroupData> groups;
	private int resource;

	public GroupListAdapter(Context context, int resource, List<GroupData> users) {
		super(context, resource, users);

		this.context = context;
		this.groups = users;
		this.resource = resource;
	}

	@Override
	public View getView(final int position, View convertView, ViewGroup parent) {
		View rowView = convertView;

		if (rowView == null) {

			LayoutInflater inflater = (LayoutInflater) context
					.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
			rowView = inflater.inflate(resource, parent, false);

			ViewHolderCommentList holder = new ViewHolderCommentList();
			holder.textName = (TextView) rowView.findViewById(R.id.userName);
			holder.btnJoined= (ToggleButton) rowView.findViewById(R.id.btnJoined);
			rowView.setTag(holder);

		}

		final ViewHolderCommentList holder = (ViewHolderCommentList) rowView
				.getTag();
		
		GroupData data = groups.get(position);
		holder.textName.setText(data.name);
		holder.btnJoined.setChecked(data.joined==1?true:false);
		
		if (data.joined==1?true:false) {
			holder.btnJoined.setBackgroundResource(R.drawable.prop_textstyle);
			holder.btnJoined
					.setTextAppearance(context, R.style.PropButtonStyle);
		} else {
			holder.btnJoined
					.setBackgroundResource(R.drawable.prop_textstyle_inverse);
			holder.btnJoined.setTextAppearance(context,
					R.style.PropButtonStyleInverse);
		}

		holder.btnJoined
				.setOnCheckedChangeListener(new OnCheckedChangeListener() {

					@Override
					public void onCheckedChanged(CompoundButton arg0,
							boolean arg1) {

						if (arg1) {
							holder.btnJoined
									.setBackgroundResource(R.drawable.prop_textstyle);
							holder.btnJoined.setTextAppearance(context,
									R.style.PropButtonStyle);
						} else {
							holder.btnJoined
									.setBackgroundResource(R.drawable.prop_textstyle_inverse);
							holder.btnJoined.setTextAppearance(context,
									R.style.PropButtonStyleInverse);
						}

					}
				});

		return rowView;
	}

	class ViewHolderCommentList {

		ToggleButton btnJoined;
		TextView textName;
	}

}

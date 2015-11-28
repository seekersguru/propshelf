package app.prop.propshelf.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import java.util.List;

import app.prop.propshelf.R;
import app.prop.propshelf.model.WallUser;


public class ParticipantsAdapter extends ArrayAdapter<WallUser> {

	private Context context;
	private List<WallUser> users;
	private int resource;

	public ParticipantsAdapter(Context context, int resource,
			List<WallUser> users) {
		super(context, resource, users);

		this.context = context;
		this.users = users;
		this.resource = resource;
	}

	@Override
	public View getView(final int position, View convertView, ViewGroup parent) {
		View rowView = convertView;

		if (rowView == null) {

			LayoutInflater inflater = (LayoutInflater) context
					.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
			rowView = inflater.inflate(resource, parent, false);

			ViewHolderCommentList viewHolderCommentListObject = new ViewHolderCommentList();
			viewHolderCommentListObject.textName = (TextView) rowView
					.findViewById(R.id.userName);

			rowView.setTag(viewHolderCommentListObject);

		}

		final ViewHolderCommentList viewHolderCommentListObject = (ViewHolderCommentList) rowView
				.getTag();

		viewHolderCommentListObject.textName.setText(users.get(position)
				.firstName + " " + users.get(position).lastName);

		return rowView;
	}

	class ViewHolderCommentList {

		TextView commentText;
		TextView textName;
	}

}

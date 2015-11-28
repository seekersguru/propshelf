package app.prop.propshelf.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import java.util.List;

import app.prop.propshelf.R;
import app.prop.propshelf.model.WallData;
import app.prop.propshelf.utils.PreferenceManager;


public class ChatAdapter extends ArrayAdapter<WallData> {

	private Context context;
	private List<WallData> users;
	private int resource;
	long currentId;

	public ChatAdapter(Context context, int resource,
					   List<WallData> users) {
		super(context, resource, users);

		this.context = context;
		this.users = users;
		this.resource = resource;
		currentId=PreferenceManager.getCurrentUser(context).id;
	}

	@Override
	public View getView(final int position, View convertView, ViewGroup parent) {
		View rowView = convertView;

		if (rowView == null) {

			LayoutInflater inflater = (LayoutInflater) context
					.getSystemService(Context.LAYOUT_INFLATER_SERVICE);


			if (users.get(position).id.equalsIgnoreCase(currentId+""))
			{
				rowView = inflater.inflate(resource, parent, false);
			}else
			{
				rowView = inflater.inflate(R.layout.chat_message_right, parent, false);
			}

			ViewHolderCommentList viewHolderCommentListObject = new ViewHolderCommentList();
			viewHolderCommentListObject.textName = (TextView) rowView
					.findViewById(R.id.userName);
			viewHolderCommentListObject.commentText= (TextView) rowView
					.findViewById(R.id.commentText);
			rowView.setTag(viewHolderCommentListObject);

		}

		final ViewHolderCommentList viewHolderCommentListObject = (ViewHolderCommentList) rowView
				.getTag();

		viewHolderCommentListObject.textName.setText(users.get(position).createdBy.name);
		viewHolderCommentListObject.commentText.setText(users.get(position).text);

		return rowView;
	}

	class ViewHolderCommentList {

		TextView commentText;
		TextView textName;
	}

}

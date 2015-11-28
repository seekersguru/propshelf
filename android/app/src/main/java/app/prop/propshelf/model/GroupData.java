package app.prop.propshelf.model;

import java.util.ArrayList;

public class GroupData implements Comparable<GroupData> {

	public int id;
	public String name;
	public String profilePicLink;
	public int joined;
	public ArrayList<Long> members=new ArrayList<>();


	public GroupData(String name, String profilePicLink, int joined) {
		this.name = name;
		this.profilePicLink = profilePicLink;
		this.joined = joined;
	}

	public GroupData() {

	}

	@Override
	public int compareTo(GroupData o) {
		// TODO Auto-generated method stub

		return 0;
	}
}

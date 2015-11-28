package app.prop.propshelf.model;

import java.io.Serializable;
import java.util.ArrayList;

public class GroupRequest implements Serializable {

	public String name;
	public String description;
	public String location;
	public String city;
	public ArrayList<String> members=new ArrayList<>();

}

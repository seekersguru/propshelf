package app.prop.propshelf.model;

import java.io.Serializable;
import java.util.ArrayList;

public class BaseGroup implements Serializable {

	public String success;
	public String error;
	public ArrayList<GroupData> json=new ArrayList<>();


}

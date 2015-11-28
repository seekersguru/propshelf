package app.prop.propshelf.model;


import java.io.Serializable;
import java.util.ArrayList;

public class WallData implements Serializable {

    public String threadId;
    public String id;
	public String name;
	public String text;
    public String timestamp;
    public int isGroup;
    public ArrayList<WallUser> reciepents;
    public WallUser createdBy;

}

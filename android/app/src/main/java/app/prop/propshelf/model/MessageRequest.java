package app.prop.propshelf.model;


import java.io.Serializable;
import java.util.ArrayList;

public class MessageRequest implements Serializable {

	public String text;
    public ArrayList<Long> reciepents;
    public ArrayList<Long> group;

}

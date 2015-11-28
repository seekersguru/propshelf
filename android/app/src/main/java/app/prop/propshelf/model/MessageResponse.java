package app.prop.propshelf.model;


import java.io.Serializable;

public class MessageResponse implements Serializable {

	public String mimeType;
    public String messageText;
    public String messageId;
    public String threadId;

    public WallUser recipient;

}

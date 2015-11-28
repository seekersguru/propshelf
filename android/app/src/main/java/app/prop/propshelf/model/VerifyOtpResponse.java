package app.prop.propshelf.model;

import java.io.Serializable;

public class VerifyOtpResponse implements Serializable {

	public int id;
	public String userId;
	public String success;
	public Session session;

	public class Session implements Serializable
	{
		public String id;
		public String lastAccessTime;
	}
}

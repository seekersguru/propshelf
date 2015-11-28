package app.prop.propshelf.utils;


/**
 * Created by VR.One on 6/27/2015.
 */
public interface Links {
	// http:// webapi.gostartapp.com/api/User/checkUserData?token=234
//	final String SERVER = "webapi.gostartapp.com";
	final String SERVER = "gostartapp.azurewebsites.net";
	final String HEAD = "http://";
	final String LOCATION = "/api";

	public static final String PRIVATE_CHAT_LIST = HEAD + SERVER + LOCATION
			+ "/Chart/getcharuser?token=102";
	public static final String GET_CHAT_MSG = HEAD + SERVER + LOCATION
			+ "/Chart/getchatmessage?token=123";
	public static final String POST_MSG = HEAD + SERVER + LOCATION
			+ "/Chart/addmessage?token=233";
	public static final String GET_POINT = HEAD + SERVER + LOCATION
			+ "/User/getpoint?token=123";
	public static final String GET_POINT_DISTRIBUTION = HEAD + SERVER
			+ LOCATION + "/other/getpointearninglogic?token=123";
	public static final String DUMP_DATA = HEAD + SERVER + LOCATION
			+ "/User/adduser?token=234";
	public static final String GET_NOTICES = HEAD + SERVER + LOCATION
			+ "/NoticeBoard/getparticularnotice?token=123";
	public static final String ADD_NOTICE = HEAD + SERVER + LOCATION
			+ "/Notice/addnotice?token=2323";
	public static final String SEARCH_NB = HEAD + SERVER + LOCATION
			+ "/NoticeBoard/getnoticeboard?token=123";
	public static final String GET_NB = HEAD + SERVER + LOCATION
			+ "/NoticeBoard/getnb?token=123";
	public static final String GET_REDEEM_LIST = HEAD + SERVER + LOCATION
			+ "/redeem/getredeem?token=233";
	public static final String DEDUCT_POINTS = HEAD + SERVER + LOCATION
			+ "/user/deductpoint?token=123";
	// public static final String PINNED =
	// HEAD+SERVER+LOCATION+"/Notice/getpinnednotice?token=123";
	public static final String PIN_UNPIN = HEAD + SERVER + LOCATION
			+ "/Notice/updatepinnedrelation?token=33";
	public static final String FAV_UNFAV = HEAD + SERVER + LOCATION
			+ "/Notice/updatefav?token=33";
	public static final String NOTICE_IMG = HEAD + SERVER + LOCATION + "";
	public static final String GET_COMMENT = HEAD + SERVER + LOCATION
			+ "/Notice/getcomments?token=333";
	public static final String CHECK_USER = HEAD + SERVER + LOCATION
			+ "/User/checkUserData?token=234";
	public static final String GET_NOTICES_NEW = HEAD + SERVER + LOCATION
			+ "/NoticeBoard/getnotice?token=123";
	public static final String GET_ALL_USERS = HEAD + SERVER + LOCATION
			+ "/User/GetUser?token=123";
	public static final String UPDATE_BIO = HEAD + SERVER + LOCATION
			+ "/User/updatebio?token=124";
	public static final String UPDATE_GCM = HEAD + SERVER + LOCATION
			+ "/User/updateGCM?token=124";

	public static final String POST_IMAGE = HEAD + SERVER + LOCATION
			+ "/Notice/Post?fb_id=";
	public static final String POST_COMMENT = HEAD + SERVER + LOCATION
			+ "/Notice/addcomment?token=234";
	public static final String GET_EVENTS = HEAD + SERVER + LOCATION
			+ "/Event/GetEvents?token=234";
	
	public static final String GET_IMAGE = HEAD + SERVER + "/UploadedImages/";
}

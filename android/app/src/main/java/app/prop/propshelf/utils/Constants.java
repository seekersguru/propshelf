package app.prop.propshelf.utils;

public class Constants {

	public static final int FILTER_ALL = 0;
	public static final int FILTER_PINNED = 1;
	public static final int FILTER_OWNED = 2;
	public static final int FILTER_OTHERS = 3;
	
	public final static String DIR_ROOT = "/PropShelf/";
	public final static String DIR_MEDIA = DIR_ROOT + "Media/";
	public final static String DIR_CACHE = DIR_ROOT + "cache";
	public final static String DIR_IMAGES = DIR_MEDIA + "StartApp Images/";
	public final static String IMAGE_FILE_NAME_PREFIX = "StartApp_IMAGE_";
	public final static String IMAGE_FILE_EXTENTION = ".jpg";

	public final static String CONTENT_TYPE = "Content-Type";
	public final static String CONTENT_TYPE_JSON = "application/json";
	public final static String AUTHORIZATION = "Authorization";
	public final static String ACCEPT_ENCODING = "Accept-Encoding";
	public final static String ACCEPT_ENCODING_TYPE = "gzip";
	public final static String CONTENT_ENCODING = "Content-Encoding";

	public final static int METHOD_GET = 1;
	public final static int METHOD_POST = 2;
	public final static int METHOD_PUT = 3;
	public final static int METHOD_DELETE = 4;

	public final static String BASE_URL="http://surveyglass.in/api/";
	public final static String CREATE_USER="create_user/";
	public final static String VERIFY_OTP="verify_otp/";
	public final static String RESEND_OTP="resend_otp/";
	public final static String GROUPS="groups/";
	public final static String GROUP="group/";
	public final static String JOIN_GROUP="join_group/";
	public final static String UNJOIN_GROUP="unjoin_group/";
	public final static String WALL="wall/";
	public final static String THREAD="thread/";
	public final static String MESSAGE="message/";
	public final static String GROUP_USER="group_user/";
	public final static String CITIES="cities/";
	public final static String SUB_LOCATIONS="sub_locations/";

}

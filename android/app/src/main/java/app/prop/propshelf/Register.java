package app.prop.propshelf;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.EditText;
import android.widget.Toast;

import com.google.gson.Gson;

import app.prop.propshelf.async.GetDataFromServer;
import app.prop.propshelf.model.CreateUser;
import app.prop.propshelf.model.CreateUserResponse;
import app.prop.propshelf.model.ResponseData;
import app.prop.propshelf.model.VerifyOTP;
import app.prop.propshelf.model.VerifyOtpResponse;
import app.prop.propshelf.model.WallUser;
import app.prop.propshelf.network.IAsyncTaskCompleteListener;
import app.prop.propshelf.utils.Constants;
import app.prop.propshelf.utils.Logger;
import app.prop.propshelf.utils.PreferenceManager;

public class Register extends Activity implements OnClickListener,IAsyncTaskCompleteListener{


    private static final int CREATE_USER =1 ;
    private static final int VERIFY_OTP = 2;
    private static final int RESEND_OTP = 3;
    private String email,source,first_name,last_name;

    private Context context;
    private EditText etCountryCode;
    private EditText etPhoneNumber;
    private EditText etOTP;
    private Gson gson;
    private VerifyOTP verifyOTP;

    @Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_register);
        gson=new Gson();
        context=this;
        etCountryCode=(EditText)findViewById(R.id.etCountryCode);
        etPhoneNumber=(EditText)findViewById(R.id.etPhoneNumber);
        etOTP=(EditText)findViewById(R.id.etOTP);
        
        email=getIntent().getStringExtra("email");
        source=getIntent().getStringExtra("source");
        first_name=getIntent().getStringExtra("first_name");
        last_name=getIntent().getStringExtra("last_name");

        if (!TextUtils.isEmpty(PreferenceManager.getAuthorization(context)))
        {
            navigateToMain();
        }
    }

	@Override
	public void onClick(View v) {

		switch (v.getId()) {
            case R.id.btnSendOTP:
                createUser();
                break;
            case R.id.btnVerify:
                verifyUser();
                break;
            case R.id.resendOPT:
                break;
        default:
        	navigateToMain();
        }
	}


    private void createUser() {

        String url = Constants.BASE_URL+Constants.CREATE_USER;
        GetDataFromServer getData = new GetDataFromServer(this, CREATE_USER, Constants.METHOD_POST);
        CreateUser createUser=new CreateUser();
        createUser.email=email;
        createUser.first_name=first_name;
        createUser.last_name=last_name;
        createUser.source=source;

        if (!TextUtils.isEmpty(etCountryCode.getText().toString()))
        {
            if (etPhoneNumber.getText().toString().length()==10)
            {
                createUser.userName=etPhoneNumber.getText().toString();
                Logger.logger("Create User: "+gson.toJson(createUser));
                getData.InitialiseRequest(context, url,gson.toJson(createUser),true);
            }else
            {
                Toast.makeText(context,"Enter 10 digit mobile number",Toast.LENGTH_SHORT).show();
            }
        }else
        {
            Toast.makeText(context,"Please add Country code",Toast.LENGTH_SHORT).show();
        }

    }

    private void verifyUser() {

        String url = Constants.BASE_URL+Constants.VERIFY_OTP;

        GetDataFromServer getData = new GetDataFromServer(this, VERIFY_OTP, Constants.METHOD_POST);
        if (verifyOTP!=null)
        {
            getData.InitialiseRequest(context, url,gson.toJson(verifyOTP),true);
        }else{
            Toast.makeText(context,"Click on send OTP first",Toast.LENGTH_SHORT);
        }

    }

    private void navigateToMain() {

		Intent intent = new Intent(Register.this, Main.class);
		startActivity(intent);
		finish();
	}

	@Override
	public void OnTaskSuccess(ResponseData result, int count) {
        String response = result.getResponse();
        switch (count)
        {
            case CREATE_USER:

                CreateUserResponse createUserResponse=gson.fromJson(response,CreateUserResponse.class);

                if (createUserResponse.success!=null)
                {
                    etOTP.setText(""+createUserResponse.otp_testing_ask_to_delete_ecurity_issue);
                    verifyOTP=new VerifyOTP();
                    verifyOTP.userName=etPhoneNumber.getText().toString();
                    verifyOTP.otp=createUserResponse.otp_testing_ask_to_delete_ecurity_issue+"";
                    verifyUser();
                }
                break;
            case VERIFY_OTP:
                VerifyOtpResponse verifyOtpResponse=gson.fromJson(response,VerifyOtpResponse.class);
                if (verifyOtpResponse.success!=null)
                {
                    WallUser user=new WallUser();
                    user.firstName=first_name;
                    user.lastName=last_name;
                    user.name=first_name;
                    user.id=verifyOtpResponse.id;
                    PreferenceManager.setAuthorization(context,verifyOtpResponse.session.id);
                    PreferenceManager.setCurrentUser(context, new Gson().toJson(user));
                    navigateToMain();
                }
            default:
                break;
        }
	}

	@Override
	public void OnTaskError(ResponseData result, int count) {

	}
}
package app.prop.propshelf.fragments;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Toast;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;

import app.prop.propshelf.GroupChat;
import app.prop.propshelf.R;
import app.prop.propshelf.adapter.WallAdapter;
import app.prop.propshelf.async.GetDataFromServer;
import app.prop.propshelf.model.ResponseData;
import app.prop.propshelf.model.WallData;
import app.prop.propshelf.network.IAsyncTaskCompleteListener;
import app.prop.propshelf.utils.Constants;


/**
 * A simple {@link Fragment} subclass. Activities that contain this fragment
 * must implement the {@link OnFragmentInteractionListener}
 * interface to handle interaction events. Use the
 * {@link WallFragment#newInstance} factory method to create an instance of this
 * fragment.
 */
public class WallFragment extends Fragment implements WallAdapter.ClickListener{
	
	private static WallFragment fragment;
	private android.support.v7.widget.RecyclerView recyclerView;
	private List<WallData> wallList = new ArrayList<WallData>();
	private Context context;
	private final String TAG = "Test";
	private WallAdapter wallAdapter;
	private OnFragmentInteractionListener mListener;

	public static WallFragment newInstance() {
		fragment = new WallFragment();
		Bundle args = new Bundle();
		fragment.setArguments(args);
		return fragment;
	}

	public WallFragment() {
		// Required empty public constructor
	}

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

	}
	
	@SuppressWarnings("deprecation")
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		// Inflate the layout for this fragment
		View view = inflater.inflate(R.layout.fragment_notice_board, container,
				false);

		recyclerView = (RecyclerView) view.findViewById(R.id.notice_grid);
		recyclerView.getParent().requestDisallowInterceptTouchEvent(false);
		recyclerView.setOnFocusChangeListener(new View.OnFocusChangeListener() {
            @Override
            public void onFocusChange(View view, boolean b) {

            }
        });
        wallAdapter = new WallAdapter(wallList, getActivity());
        wallAdapter.setClickListener(this);

		String url = Constants.BASE_URL + Constants.WALL;
		GetDataFromServer getData = new GetDataFromServer(new IAsyncTaskCompleteListener<ResponseData>() {
			@Override
			public void OnTaskSuccess(ResponseData result, int count) {
                try {
                    JSONObject jsonObject= new JSONObject(result.getResponse());
                    String success=jsonObject.getString("success");
                    if (success!=null&&success.equals("Done"))
                    {
                        JSONArray jsonArray=jsonObject.getJSONArray("json");

                        Type collectionType = new TypeToken<List<WallData>>() {
                        }.getType();
                        wallList = new Gson().fromJson(jsonArray.toString(), collectionType);
                        wallAdapter = new WallAdapter(wallList, getActivity());
                        wallAdapter.setClickListener(WallFragment.this);
                        recyclerView.setLayoutManager(new myManager(getActivity(), 1));
                        recyclerView.setAdapter(wallAdapter);
                    }else
                    {
                        Toast.makeText(context,"Opps! try later...",Toast.LENGTH_SHORT).show();
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                }


			}

			@Override
			public void OnTaskError(ResponseData result, int count) {

			}
		}, 1, Constants.METHOD_GET);

		getData.setLoaderMessage("Loading wall...");
		getData.InitialiseRequest(context, url, null, true);
		return view;
	}


	public abstract class HidingScrollListener extends
			RecyclerView.OnScrollListener {
		private static final int HIDE_THRESHOLD = 20;
		private int scrolledDistance = 0;
		private boolean controlsVisible = true;

		@Override
		public void onScrolled(RecyclerView recyclerView, int dx, int dy) {
			super.onScrolled(recyclerView, dx, dy);

			if (scrolledDistance > HIDE_THRESHOLD && controlsVisible) {
				onHide();
				controlsVisible = false;
				scrolledDistance = 0;
			} else if (scrolledDistance < -HIDE_THRESHOLD && !controlsVisible) {
				onShow();
				controlsVisible = true;
				scrolledDistance = 0;
			}

			if ((controlsVisible && dy > 0) || (!controlsVisible && dy < 0)) {
				scrolledDistance += dy;
			}
		}

		public abstract void onHide();

		public abstract void onShow();

	}

	class myManager extends GridLayoutManager {

		public myManager(Context context, int spanCount) {
			super(context, spanCount);
		}

		public myManager(Context context, int spanCount, int orientation,
				boolean reverseLayout) {
			super(context, spanCount, orientation, reverseLayout);
		}

		@Override
		public int scrollVerticallyBy(int dx, RecyclerView.Recycler recycler,
				RecyclerView.State state) {
			int scrollRange = super.scrollVerticallyBy(dx, recycler, state);
			int overscroll = dx - scrollRange;
			if (overscroll > 0) {

			} else if (overscroll < 0) {

			}
			return scrollRange;
		}
	}

	private void onScrolledUp() {
	
	}

	private void onScrolledDown() {
	}

	@Override
	public void onActivityCreated(Bundle savedInstanceState) {
		super.onActivityCreated(savedInstanceState);
	}

	// TODO: Rename method, update argument and hook method into UI event
	public void onButtonPressed(Uri uri) {
		if (mListener != null) {
			mListener.onFragmentInteraction(uri);
		}
	}

	@Override
	public void onPause() {
		// TODO Auto-generated method stub
		super.onPause();
	}

	@Override
	public void onResume() {
		super.onResume();

	}

	//
	@Override
	public void onAttach(Activity activity) {
		super.onAttach(activity);
		try {
			mListener = (OnFragmentInteractionListener) activity;
			context = activity;
		} catch (ClassCastException e) {
			throw new ClassCastException(activity.toString()
					+ " must implement OnFragmentInteractionListener");
		}
	}

	@Override
	public void onDetach() {
		super.onDetach();
		mListener = null;
	}

	

	@Override
	public void onSaveInstanceState(Bundle outState) {
		super.onSaveInstanceState(outState);
	}
	public interface OnFragmentInteractionListener {
		// TODO: Update argument type and name
		public void onFragmentInteraction(Uri uri);
	}

	@Override
	public void itemClicked(View view, int position) {
	
	//	Toast.makeText(context, " itemClicked in Wall",Toast.LENGTH_SHORT).show();
		Intent intent=new Intent(context, GroupChat.class);
		intent.putExtra("WALLITEM", new Gson().toJson(wallList.get(position)));
		startActivity(intent);
	}

	
}

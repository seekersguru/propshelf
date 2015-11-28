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
import com.google.gson.JsonObject;

import java.util.ArrayList;
import java.util.List;

import app.prop.propshelf.GroupDetail;
import app.prop.propshelf.R;
import app.prop.propshelf.adapter.GroupAdapter;
import app.prop.propshelf.async.GetDataFromServer;
import app.prop.propshelf.model.BaseGroup;
import app.prop.propshelf.model.GroupData;
import app.prop.propshelf.model.ResponseData;
import app.prop.propshelf.network.IAsyncTaskCompleteListener;
import app.prop.propshelf.utils.Constants;

/**
 * A simple {@link Fragment} subclass. Activities that contain this fragment
 * must implement the {@link OnFragmentInteractionListener}
 * interface to handle interaction events. Use the
 * {@link GroupFragment#newInstance} factory method to create an instance of this
 * fragment.
 */
public class GroupFragment extends Fragment implements GroupAdapter.ClickListener,IAsyncTaskCompleteListener {
    private static final int GET_GROUPS = 1;
    // TODO: Rename parameter arguments, choose names that match
	// the fragment initialization parameters, e.g. ARG_ITEM_NUMBER
	private static GroupFragment fragment;
	
	private android.support.v7.widget.RecyclerView recyclerView;
	private List<GroupData> groupList = new ArrayList<GroupData>();
	private Context context;
	private final String TAG = "Test";
	private GroupAdapter groupAdapter;
	private OnFragmentInteractionListener mListener;

    private Gson gson;
	public static GroupFragment newInstance() {
		fragment = new GroupFragment();
		Bundle args = new Bundle();
		fragment.setArguments(args);
		return fragment;
	}

	public GroupFragment() {
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


        gson=new Gson();
		return view;
	}

	@Override
	public void OnTaskSuccess(ResponseData result, int count) {

        switch (count)
        {
            case GET_GROUPS:
                BaseGroup baseGroup=gson.fromJson(result.getResponse(),BaseGroup.class);
                if(baseGroup.success!=null)
                {
                    groupList=baseGroup.json;
                    groupAdapter = new GroupAdapter(groupList, getActivity());
                    recyclerView.setLayoutManager(new myManager(getActivity(), 1));
                    recyclerView.setAdapter(groupAdapter);
                    groupAdapter.setClickListener(this);
                }

                break;
            default:
        }
     /*   for (int i = 0; i < 20; i++) {
            if (i%2==0) {
                GroupData wallData=new GroupData("Group "+i, null, true);
                groupList.add(wallData);
            }else
            {
                GroupData wallData=new GroupData("Group "+i, null, false);
                groupList.add(wallData);
            }
        }*/

    }

	@Override
	public void OnTaskError(ResponseData result, int count) {

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
				// bottom overscroll
				// if (scrollUp) {
				// onScrolledUp();
				// scrollUp = false;
				// }

			} else if (overscroll < 0) {
				// top overscroll
				// if (!scrollUp) {
				// scrollUp = true;
				// onScrolledDown();
				// }

			}
			return scrollRange;
		}
	}

	// private boolean scrollUp = false;

	private void onScrolledUp() {
	
	}

	private void onScrolledDown() {
	}

	@Override
	public void onActivityCreated(Bundle savedInstanceState) {
		super.onActivityCreated(savedInstanceState);
		// initialization goes here

        String url = Constants.BASE_URL+Constants.GROUPS;
        GetDataFromServer getData = new GetDataFromServer(this, GET_GROUPS, Constants.METHOD_POST);

        JsonObject jsonObject=new JsonObject();
        jsonObject.addProperty("page_no", "1");

        getData.InitialiseRequest(context, url, jsonObject.toString(), false);

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
	/**
	 * This interface must be implemented by activities that contain this
	 * fragment to allow an interaction in this fragment to be communicated to
	 * the activity and potentially other fragments contained in that activity.
	 * <p/>
	 * See the Android Training lesson <a href=
	 * "http://developer.android.com/training/basics/fragments/communicating.html"
	 * >Communicating with Other Fragments</a> for more information.
	 */
	public interface OnFragmentInteractionListener {
		// TODO: Update argument type and name
		public void onFragmentInteraction(Uri uri);
	}

	@Override
	public void itemClicked(View view, int position) {
		// TODO Auto-generated method stub
		Toast.makeText(context, " itemClicked in Group",1).show();
		Intent intent=new Intent(context, GroupDetail.class);
		intent.putExtra("GROUP", groupList.get(position).name);
		startActivity(intent);
	}

}

package app.prop.propshelf.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import app.prop.propshelf.R;


public class BlankFragment1 extends Fragment {
    // TODO: Rename parameter arguments, choose names that match
    // the fragment initialization parameters, e.g. ARG_ITEM_NUMBER
    private static final String ARG_PARAM1 = "param1";
    private TextView text;
    private int position;


    // TODO: Rename and change types of parameters
    private int mParam1;


    // TODO: Rename and change types and number of parameters
    public static BlankFragment1 newInstance(int param1) {
        Log.i("Main", "Creating fragment for " + param1 + "");
        BlankFragment1 fragment = new BlankFragment1();
        Bundle args = new Bundle();
        args.putInt(ARG_PARAM1, param1);
        fragment.setArguments(args);
        //fragment.mParam1 = param1;
        //fragment.setRetainInstance(false);
        return fragment;
    }
    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        Log.i("Main", "on activityCreate of fragment " + mParam1);

    }
    @Override
    public void onResume() {
        super.onResume();

        Log.i("Main", "on Resume of fragment " + mParam1);
        //Log.i("Main", "on Resume of fragment " + StaticList.noticeBoardList.get(position.getPosition()).getNbName());
        //text.setText(mParam1);
    }

    public BlankFragment1() {
        // Required empty public constructor
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (getArguments() != null) {
            mParam1 = getArguments().getInt(ARG_PARAM1);
        }
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View view = inflater.inflate(R.layout.fragment_blank_fragment1, container, false);
        text = (TextView)view.findViewById(R.id.text);
        //text.setText(mParam1);
        return view;
    }



}

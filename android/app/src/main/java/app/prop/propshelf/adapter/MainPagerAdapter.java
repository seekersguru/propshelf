package app.prop.propshelf.adapter;

import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.view.PagerAdapter;
import android.util.Log;

import app.prop.propshelf.fragments.BlankFragment1;
import app.prop.propshelf.fragments.GroupFragment;
import app.prop.propshelf.fragments.WallFragment;

/**
 * Created by Admin i.e vinayak r khedkar on 6/15/2015.
 */
public class MainPagerAdapter extends SmartFragmentStatePagerAdapter {

	private FragmentManager manager;
	{
		Log.i("Main", "static block");
	}

	public MainPagerAdapter(FragmentManager fm) {
		super(fm);
		Log.i("Main", "adapter constructor");

	}

	@Override
	public Fragment getItem(int position) {

		Log.i("Main", "page item called for positio " + position);

		switch (position) {
		case 0:
			return WallFragment.newInstance();
		case 1:
			return GroupFragment.newInstance();
		default:
			return BlankFragment1.newInstance(position);
		}
	}

	@Override
	public int getCount() {
		// return datas.size();
		return 2;
	}

	@Override
	public int getItemPosition(Object object) {
		return PagerAdapter.POSITION_NONE;
	}
}

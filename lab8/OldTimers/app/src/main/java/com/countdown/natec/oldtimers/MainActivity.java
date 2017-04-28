package com.countdown.natec.oldtimers;

import android.app.Activity;
import android.app.FragmentTransaction;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;

public class MainActivity extends Activity implements TimerListFragment.TimerListener, TimerListFragment.AddButtonListener, TimerDetailFragment.ButtonClickListener {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        TimerListFragment tlfrag = new TimerListFragment();
        FragmentTransaction ft = getFragmentManager().beginTransaction();
        ft.add(R.id.timer_list_frag, tlfrag);
        ft.commit();
    }

    @Override public void itemClicked(long id) {
        View fragmentContainer = findViewById(R.id.timer_detail_frag_container);
        if (fragmentContainer != null) {
            TimerDetailFragment tfrag = new TimerDetailFragment();
            FragmentTransaction ft = getFragmentManager().beginTransaction();
            tfrag.setTimerID(id);
            ft.replace(R.id.timer_detail_frag_container, tfrag);
            ft.addToBackStack(null);
            ft.setTransition(FragmentTransaction.TRANSIT_FRAGMENT_FADE);
            ft.commit();
        } else {
            Intent intent = new Intent(this, DetailActivity.class);
            intent.putExtra("id", (int) id);
            startActivity(intent);
        }
    }

    @Override public void onBackPressed() {
        if (getFragmentManager().getBackStackEntryCount() > 0) {
            getFragmentManager().popBackStack();
        } else {
            super.onBackPressed();
        }
    }

    public void toggleChronoClicked(View view) {
        TimerDetailFragment tfrag = (TimerDetailFragment)getFragmentManager().findFragmentById(R.id.timer_detail_frag_container);
        tfrag.toggleChrono();
    }

    @Override public void addClicked(View view) {
        TimerListFragment tlfrag = (TimerListFragment)getFragmentManager().findFragmentById(R.id.timer_list_frag);
        tlfrag.addTimer();
    }
}

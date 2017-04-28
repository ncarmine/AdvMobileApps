package com.countdown.natec.oldtimers;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;

public class DetailActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_detail);

        TimerDetailFragment timerDetailFragment = (TimerDetailFragment) getFragmentManager().findFragmentById(R.id.timer_detail_frag_container);
        int timerID = (int) getIntent().getExtras().get("id");
        timerDetailFragment.setTimerID(timerID);
    }
}

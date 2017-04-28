package com.countdown.natec.oldtimers;


import android.content.Context;
import android.os.Bundle;
import android.app.Fragment;
import android.os.SystemClock;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.Chronometer;

/**
 * A simple {@link Fragment} subclass.
 */
public class TimerDetailFragment extends Fragment implements View.OnClickListener {

    private long timerID;
    private long time;
    private ButtonClickListener buttonClickListener;
    private Chronometer timerChrono;
    private Button toggleButton;
    private boolean isCountingDown;

    public TimerDetailFragment() {
        // Required empty public constructor
    }

    interface ButtonClickListener {
        void toggleChronoClicked(View view);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        if (savedInstanceState != null) {
            timerID = savedInstanceState.getLong("timerID");
        }
        isCountingDown = false;

        // Inflate the layout for this fragment
        return inflater.inflate(R.layout.fragment_timer_detail, container, false);
    }

    @Override public void onStart() {
        super.onStart();
        View view = getView();
        timerChrono = (Chronometer) view.findViewById(R.id.timerChrono);
        time = Timer.timers.get((int) timerID).getTime()*1000;
        timerChrono.setBase(SystemClock.elapsedRealtime()+time);

        toggleButton = (Button)view.findViewById(R.id.toggleButton);
        toggleButton.setOnClickListener(this);
    }

    @Override public void onAttach(Context context) {
        super.onAttach(context);
        buttonClickListener = (ButtonClickListener)context;
    }

    @Override public void onClick(View view) {
        if (buttonClickListener != null) {
            buttonClickListener.toggleChronoClicked(view);
        }
    }

    public void toggleChrono() {
        if (isCountingDown) {
            timerChrono.stop();
            time = timerChrono.getBase() - SystemClock.elapsedRealtime();
            toggleButton.setText(R.string.start);
        } else {
            timerChrono.setBase(SystemClock.elapsedRealtime()+time);
            timerChrono.start();
            toggleButton.setText(R.string.stop);
        }
        isCountingDown = !isCountingDown;
    }

    public void setTimerID(long newID) {
        this.timerID = newID;
    }

    @Override public void onSaveInstanceState(Bundle savedInstanceState) {
        savedInstanceState.putLong("timerID", timerID);
    }

}

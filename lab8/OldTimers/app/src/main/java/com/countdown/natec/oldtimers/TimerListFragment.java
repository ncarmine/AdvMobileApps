package com.countdown.natec.oldtimers;


import android.app.Dialog;
import android.content.Context;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.app.Fragment;
import android.util.Log;
import android.view.ContextMenu;
import android.view.LayoutInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;

import static android.content.Context.MODE_PRIVATE;


/**
 * A simple {@link Fragment} subclass.
 */
public class TimerListFragment extends Fragment implements View.OnClickListener, AdapterView.OnItemClickListener {

    private TimerListener timerListener;
    private AddButtonListener addButtonListener;
    private ArrayAdapter<Timer> timerAdapter;

    interface TimerListener {
        void itemClicked(long id);
    }

    interface AddButtonListener {
        void addClicked(View view);
    }

    public TimerListFragment() {
        // Required empty public constructor
    }


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        for (int i=0; i<10; i++) {
            //WHY WILL YOU NOT WORK
            loadTimers(getActivity(), i);
        }
        // Inflate the layout for this fragment
        return inflater.inflate(R.layout.fragment_timer_list, container, false);
    }

    @Override
    public void onStart() {
        super.onStart();
        View view = getView();
        if (view != null) {
            ListView timerList = (ListView) view.findViewById(R.id.timerList);
            timerAdapter = new ArrayAdapter<Timer>(getActivity(), android.R.layout.simple_list_item_1, Timer.timers);
            timerList.setAdapter(timerAdapter);
            timerList.setOnItemClickListener(this);

            Button addButton = (Button)view.findViewById(R.id.addTimer);
            addButton.setOnClickListener(this);

            registerForContextMenu(timerList);
        }
    }

    @Override public void onAttach(Context context) {
        super.onAttach(context);
        timerListener = (TimerListener) context;
        addButtonListener = (AddButtonListener) context;
    }

    @Override public void onItemClick(AdapterView<?>parent, View view, int position, long id) {
        if (timerListener != null) {
            timerListener.itemClicked(id);
        }
    }

    @Override public void onClick(View view) {
        if (addButtonListener != null) {
            addButtonListener.addClicked(view);
        }
    }

    public void addTimer() {
        final Dialog dialog = new Dialog(getActivity());
        dialog.setContentView(R.layout.dialog);
        dialog.setTitle("Add Timer");
        dialog.setCancelable(true);
        final EditText editName = (EditText)dialog.findViewById(R.id.editTimerName);
        final EditText editTime = (EditText)dialog.findViewById(R.id.editTimerSeconds);
        Button button = (Button) dialog.findViewById(R.id.addButton);
        button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String timerName = editName.getText().toString();
                Long timerTime = Long.parseLong(editTime.getText().toString());
                Timer.timers.add(new Timer(timerName, timerTime));
                TimerListFragment.this.timerAdapter.notifyDataSetChanged();
                storeTimers(getActivity(), Timer.timers.size()-1);
                dialog.dismiss();
            }
        });
        dialog.show();
    }

    @Override public void onCreateContextMenu(ContextMenu menu, View view, ContextMenu.ContextMenuInfo menuInfo) {
        super.onCreateContextMenu(menu, view, menuInfo);
        AdapterView.AdapterContextMenuInfo adapterContextMenuInfo = (AdapterView.AdapterContextMenuInfo) menuInfo;
        String timerName = timerAdapter.getItem(adapterContextMenuInfo.position).getName();
        menu.setHeaderTitle("Delete \'"+timerName+"\'?");
        menu.add(1,1,1,"Yes");
        menu.add(2,2,2,"No");
    }

    @Override public boolean onContextItemSelected(MenuItem menuItem) {
        int itemID = menuItem.getItemId();
        if (itemID == 1) {
            AdapterView.AdapterContextMenuInfo info = (AdapterView.AdapterContextMenuInfo) menuItem.getMenuInfo();
            Timer.timers.remove(info.position);
            TimerListFragment.this.timerAdapter.notifyDataSetChanged();
        }
        return true;
    }

    private void storeTimers(Context context, int timerID) {
        SharedPreferences sharedPrefs = context.getSharedPreferences("Timers", MODE_PRIVATE);
        SharedPreferences.Editor editor = sharedPrefs.edit();
        Timer currTimer = Timer.timers.get(timerID);
        Log.d("currTimerName", String.valueOf(currTimer.getName()));
        Log.d("currTimerNum", String.valueOf(currTimer.getTime()));
        editor.putLong(currTimer.getName(), currTimer.getTime());
        editor.apply();
    }

    private void loadTimers(Context context, int timerID) {
        SharedPreferences sharedPrefs = context.getSharedPreferences("Timers", MODE_PRIVATE);

        try {
            Timer currTimer = Timer.timers.get(timerID);
            Log.d("currTimerNameLoad", String.valueOf(currTimer.getName()));
            Log.d("currTimerNumLoad", String.valueOf(currTimer.getTime()));
            Timer.timers.add(new Timer(currTimer.getName(), sharedPrefs.getLong(currTimer.getName(), 0)));
        } catch (Exception e) {
            switch (timerID) {
                case 0:
                    Timer.timers.add(new Timer("Grandpa", 85));
                    storeTimers(getActivity(), 0);
                    break;
                case 1:
                    Timer.timers.add(new Timer("Youngin", 15));
                    storeTimers(getActivity(), 1);
                    break;
                default:
                    break;
            }
        }

    }
}

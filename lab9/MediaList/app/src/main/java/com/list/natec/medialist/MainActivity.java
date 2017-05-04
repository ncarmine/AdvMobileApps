package com.list.natec.medialist;

import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.ContextMenu;
import android.view.View;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;

import java.util.ArrayList;
import java.util.List;

public class MainActivity extends AppCompatActivity {

    FirebaseDatabase fbdb = FirebaseDatabase.getInstance();
    DatabaseReference ref = fbdb.getReference();

    List mediaItemList = new ArrayList<MediaItem>();
    ArrayAdapter<MediaItem> listAdapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        ListView mediaListView = (ListView) findViewById(R.id.listView);
        listAdapter = new ArrayAdapter<MediaItem>(this, android.R.layout.simple_list_item_1, mediaItemList);
        mediaListView.setAdapter(listAdapter);

        registerForContextMenu(mediaListView);

        ValueEventListener firebaseListener = new ValueEventListener() {
            @Override
            public void onDataChange(DataSnapshot dataSnapshot) {
                mediaItemList.clear();
                for (DataSnapshot snapshot: dataSnapshot.getChildren()) {
                    String itemName = String.valueOf(snapshot.getKey());
                    String itemURL = String.valueOf(snapshot.getValue());
                    MediaItem newItem = new MediaItem(itemName, itemURL);
                    Log.d("data", "Value is "+newItem);
                    mediaItemList.add(newItem);

                }
                listAdapter.notifyDataSetChanged();
            }

            @Override
            public void onCancelled(DatabaseError databaseError) {
                Log.w("onCreate", "Failed to read value", databaseError.toException());
            }
        };

        ref.addValueEventListener(firebaseListener);

        FloatingActionButton fab = (FloatingActionButton) findViewById(R.id.fab);
        fab.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                final Dialog dialog = new Dialog(MainActivity.this);
                dialog.setContentView(R.layout.dialog);
                dialog.setTitle("Add Website");
                dialog.setCancelable(true);
                final EditText nameEditText = (EditText) dialog.findViewById(R.id.editTextName);
                final EditText urlEditText = (EditText) dialog.findViewById(R.id.editTextURL);
                Button addButton = (Button) dialog.findViewById(R.id.addButton);
                addButton.setOnClickListener(new View.OnClickListener() {
                    @Override public void onClick(View v) {
                        String siteName = nameEditText.getText().toString();
                        String siteURL = urlEditText.getText().toString();
                        if (siteName.trim().length() > 0) {
                            MediaItem newItem = new MediaItem(siteName, siteURL);
                            mediaItemList.add(newItem);
                            listAdapter.notifyDataSetChanged();
                            ref.child(siteName).setValue(siteURL);
                            dialog.dismiss();
                        } else {
                            Context context = getApplicationContext();
                            CharSequence text = getString(R.string.add_website_toast);
                            int duration = Toast.LENGTH_SHORT;

                            Toast toast = Toast.makeText(context, text, duration);
                            toast.show(); //make a toast
                        }
                    }
                });
                dialog.show();
            }
        });

        //listener for tapping on item in listView
        AdapterView.OnItemClickListener itemClickListener = new AdapterView.OnItemClickListener() {
            public void onItemClick(AdapterView<?> listView, View view, int pos, long id) {
                MediaItem websiteSelected = (MediaItem) mediaItemList.get(pos);
                String siteURL = websiteSelected.getUrl();
                Intent intent = new Intent(Intent.ACTION_VIEW);
                intent.setData(Uri.parse(siteURL));
                startActivity(intent); //state your intentions
            }
        };
        mediaListView.setOnItemClickListener(itemClickListener);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    @Override public void onCreateContextMenu(ContextMenu menu, View view, ContextMenu.ContextMenuInfo menuInfo) {
        super.onCreateContextMenu(menu, view, menuInfo);
        AdapterView.AdapterContextMenuInfo adapterContextMenuInfo = (AdapterView.AdapterContextMenuInfo) menuInfo;
        String mediaName = ((TextView) adapterContextMenuInfo.targetView).getText().toString();
        menu.setHeaderTitle("Delete \'"+mediaName+"\'?");
        menu.add(1, 1, 1, "Yes");
        menu.add(2, 2, 2, "No");
    }

    @Override public boolean onContextItemSelected(MenuItem item) {
        int itemID = item.getItemId();
        if (itemID == 1) { //if delete button pressed
            AdapterView.AdapterContextMenuInfo info = (AdapterView.AdapterContextMenuInfo) item.getMenuInfo();
            String mediaName = ((TextView) info.targetView).getText().toString();
            mediaItemList.remove(info.position);
            listAdapter.notifyDataSetChanged();
            ref.child(mediaName).removeValue();
        }
        return true;
    }
}

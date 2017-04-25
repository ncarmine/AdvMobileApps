package com.weather.natec.weatherornot;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import java.util.ArrayList;

public class DayAdapter extends BaseAdapter {

    private Context context;
    private final ArrayList<String> dayTemps;
    private final ArrayList<Drawable> forecastImages;
    private final ArrayList<String> daysForecast;

    public DayAdapter(Context newContext, ArrayList<String> newTemps, ArrayList<Drawable> newImages, ArrayList<String> newDays) {
        this.context = newContext;
        this.dayTemps = newTemps;
        this.forecastImages = newImages;
        this.daysForecast = newDays;
    }

    public View getView(int position, View convertView, ViewGroup parent) {
        LayoutInflater layoutInflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        View gridView;

        if (convertView == null) {
            gridView = layoutInflater.inflate(R.layout.day_adapter, null);

            TextView dayTemp = (TextView) gridView.findViewById(R.id.day_temp);
            dayTemp.setText(dayTemps.get(position));
            ImageView dayImage = (ImageView) gridView.findViewById(R.id.day_image);
            dayImage.setImageDrawable(forecastImages.get(position));
            TextView dayName = (TextView) gridView.findViewById(R.id.day_name);
            dayName.setText(daysForecast.get(position));
        } else {
            gridView = convertView;
        }
        return gridView;
    }

    @Override
    public int getCount() {
        return dayTemps.size();
    }

    @Override
    public Object getItem(int position) {
        return null;
    }

    @Override
    public long getItemId(int position) {
        return 0;
    }
}

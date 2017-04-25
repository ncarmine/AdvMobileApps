package com.weather.natec.weatherornot;

import android.*;
import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageManager;
import android.graphics.drawable.Drawable;
import android.location.Location;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.util.Log;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.TextView;

import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.location.LocationListener;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationServices;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONTokener;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Objects;

// Weather icon images provided by DeviantArt user "LavAna"
// http://lavana.deviantart.com/art/Flat-Weather-Icons-32021664

public class WeatherMainActivity extends Activity implements GoogleApiClient.ConnectionCallbacks, GoogleApiClient.OnConnectionFailedListener, LocationListener {

    private GoogleApiClient mGoogleApiClient;
    public static final String TAG = WeatherMainActivity.class.getSimpleName();
    private static final int MY_PERMISSION_ACCESS_COARSE_LOCATION = 303;
    private LocationRequest mLocationRequest;

    private TextView currentTemp;
    private TextView currentSummary;
    private TextView todayTemp;
    private ImageView currentForecast;
    private GridView weekGrid;
    private Context thatContext;
    private Double currLat;
    private Double currLong;

    static final String[] daysOfWeek = new String[] {"Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"};

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_weather_main);

        currentTemp = (TextView) findViewById(R.id.current_temp);
        currentSummary = (TextView) findViewById(R.id.current_summary);
        currentForecast = (ImageView) findViewById(R.id.current_forecast);
        todayTemp = (TextView) findViewById(R.id.today_temp);
        weekGrid = (GridView) findViewById(R.id.weekGrid);
        thatContext = this;
        ImageView darkskyImage = (ImageView) findViewById(R.id.darksky);
        darkskyImage.setImageDrawable(getDrawable(R.drawable.darksky));

        //Create instance of GoogleAPIClient
        if (mGoogleApiClient == null) {
            mGoogleApiClient = new GoogleApiClient.Builder(this)
                    .addConnectionCallbacks(this)
                    .addOnConnectionFailedListener(this)
                    .addApi(LocationServices.API)
                    .build();
        }

        mLocationRequest = LocationRequest.create()
                .setPriority(LocationRequest.PRIORITY_LOW_POWER);
    }


    public void handleLocation(Location lastLocation) {
        Log.d("LOCATION", lastLocation.toString());
        currLat = lastLocation.getLatitude();
        currLong = lastLocation.getLongitude();
        new RetrieveDarkskyData().execute("");
    }

    @Override
    public void onConnected(Bundle connectionHint) {
        Log.d(TAG, "Connection Successful");
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            Log.w(TAG, "PERMISSION DENIED");
            ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.ACCESS_COARSE_LOCATION}, MY_PERMISSION_ACCESS_COARSE_LOCATION);
        }

        Location mLastLocation = LocationServices.FusedLocationApi.getLastLocation(mGoogleApiClient);
        if (mLastLocation != null) {
            handleLocation(mLastLocation);
        } else {
            LocationServices.FusedLocationApi.requestLocationUpdates(mGoogleApiClient, mLocationRequest, this);
        }
    }

    @Override
    public void onConnectionSuspended(int i) {
        Log.d(TAG, "Connection Suspended");
    }

    @Override
    public void onConnectionFailed(ConnectionResult connectionResult) {
        Log.w(TAG, "Connection Failed");
//        if (connectionResult.hasResolution()) {
//            Log.e(TAG, connectionResult.getErrorMessage());
//            try {
//                connectionResult.startResolutionForResult(this, 9000);
//            } catch (IntentSender.SendIntentException e) {
//                e.printStackTrace();
//            }
//
//        } else {
            Log.w(TAG, connectionResult.getErrorMessage());
            Log.w(TAG, "Location services failed with code "+connectionResult.getErrorCode());
    }

    protected void onResume() {
        super.onResume();
        mGoogleApiClient.connect();
    }

    protected void onPause() {
        super.onPause();
        if (mGoogleApiClient.isConnected()) {
            LocationServices.FusedLocationApi.removeLocationUpdates(mGoogleApiClient, this);
            mGoogleApiClient.disconnect();
        }
    }

    @Override
    public void onLocationChanged(Location location) {
        Log.d(TAG, "Location Changed");
        handleLocation(location);

    }

    class RetrieveDarkskyData extends AsyncTask<String, Void, String> {
        private Exception exception;

        protected void onPreExecute() {

        }

        protected String doInBackground(String... args) {
            try {
                URL url = new URL("https://api.darksky.net/forecast/251044d8d01971a3d739a13ddd102c08/"+currLat+","+currLong);

                HttpURLConnection urlConnection = (HttpURLConnection) url.openConnection();
                try {
                    //create an InputStreamReader with the JSON stream
                    InputStreamReader isr = new InputStreamReader(urlConnection.getInputStream());
                    //convert the byte stream to a character stream using BufferedReader
                    BufferedReader bufferedReader = new BufferedReader(isr);
                    StringBuilder stringBuilder = new StringBuilder();
                    String line;
                    //loop through char stream and build sequence of chars using StringBuilder
                    while ((line = bufferedReader.readLine()) != null) {
                        stringBuilder.append(line).append("\n");
                    }
                    bufferedReader.close();
                    //convert char seq to Str
                    return stringBuilder.toString();
                } finally {
                    urlConnection.disconnect();
                }
            } catch (Exception e) {
                Log.e(TAG, e.getMessage(), e);
                return null;
            }
        }

        private String getTemperature(JSONObject weather, String tempName, Boolean deg) {
            try {
                String fullTempStr = weather.getString(tempName);
                Double fullTempDbl = Double.parseDouble(fullTempStr);
                Long roundedTemp = Math.round(fullTempDbl);
                String roundedTempStr = Objects.toString(roundedTemp, null);
                if (roundedTempStr != null) {
                    if (deg) {
                        return roundedTempStr+"º";
                    } else {
                        return roundedTempStr;
                    }
                } else {
                    return null;
                }
            } catch (JSONException e) {
                Log.e(TAG, e.getMessage());
                e.printStackTrace();
                return null;
            }
        }

        private Drawable getForecastImage(String forecast) {
            switch (forecast) {
                case "clear-day":
                    return getDrawable(R.drawable.clear_day);
                case "clear-night":
                    return getDrawable(R.drawable.clear_night);
                case "rain":
                    return getDrawable(R.drawable.rain);
                case "snow":
                    return getDrawable(R.drawable.snow);
                case "sleet":
                    return getDrawable(R.drawable.sleet);
                case "wind":
                    return getDrawable(R.drawable.wind);
                case "cloudy":
                    return getDrawable(R.drawable.cloudy);
                case "fog":
                    return getDrawable(R.drawable.cloudy);
                case "partly-cloudy-day":
                    return getDrawable(R.drawable.partly_cloudy_day);
                case "partly-cloudy-night":
                    return getDrawable(R.drawable.partly_cloudy_night);
                default:
                    return getDrawable(R.drawable.partly_cloudy_day);

            }
        }

        protected void onPostExecute(String response) {
            if (response == null) {
                response = "NULL EXCEPTION ERROR";
            }

            try {
                JSONObject report = (JSONObject) new JSONTokener(response).nextValue();
                JSONObject currentWeather = report.getJSONObject("currently");
                currentTemp.setText(getTemperature(currentWeather, "temperature", true));
                currentSummary.setText(currentWeather.getString("summary"));
                currentForecast.setImageDrawable(getForecastImage(currentWeather.getString("icon")));
                //JSONObject dayReport = report.getJSONObject("hourly");
                JSONArray weekReport = report.getJSONObject("daily").getJSONArray("data");
                String todayHigh = getTemperature(weekReport.getJSONObject(0), "temperatureMax", true);
                String todayLow = getTemperature(weekReport.getJSONObject(0), "temperatureMin", true);
                todayTemp.setText(todayHigh+" | "+todayLow);
                ArrayList<String> dayTemps = new ArrayList<String>();
                ArrayList<Drawable> forecastImages = new ArrayList<Drawable>();
                ArrayList<String> daysForecast = new ArrayList<String>();
                for (int i=1; i<6; i++) {
                    JSONObject iterDay = weekReport.getJSONObject(i);
                    String dayHigh = getTemperature(iterDay, "temperatureMax", false);
                    String dayLow = getTemperature(iterDay, "temperatureMin", false);
                    dayTemps.add(dayHigh+" | "+dayLow);
                    Drawable forecastImage = getForecastImage(iterDay.getString("icon"));
                    forecastImages.add(forecastImage);
                    Calendar cal = Calendar.getInstance();
                    cal.setTimeInMillis(iterDay.getLong("time")*1000);
                    int iterDayofWeek = cal.get(Calendar.DAY_OF_WEEK);
                    daysForecast.add(daysOfWeek[iterDayofWeek-1]);
                }

                weekGrid.setAdapter(new DayAdapter(thatContext, dayTemps, forecastImages, daysForecast));

            } catch (JSONException e) {
                Log.e(TAG, e.getMessage());
                e.printStackTrace();
            }
        }
    }
}

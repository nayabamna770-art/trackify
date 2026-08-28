package com.example.trackify

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

class TrackifyWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.trackify_widget_layout).apply {
                val title = widgetData.getString("widget_title", "TRACKIFY") ?: "TRACKIFY"
                val habitsCount = widgetData.getString("widget_habits_count", "0 / 0 Done Today") ?: "0 / 0 Done Today"
                val streak = widgetData.getString("widget_streak", "0🔥") ?: "0🔥"
                val nextTask = widgetData.getString("widget_next_task", "Tap to track daily habits") ?: "Tap to track daily habits"

                setTextViewText(R.id.widget_title, title)
                setTextViewText(R.id.widget_habits_count, habitsCount)
                setTextViewText(R.id.widget_streak, streak)
                setTextViewText(R.id.widget_next_task, nextTask)

                // Attach pending intent to launch app on widget click
                val pendingIntent = HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java,
                    Uri.parse("trackify://open/habits")
                )
                setOnClickPendingIntent(R.id.widget_container, pendingIntent)
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}

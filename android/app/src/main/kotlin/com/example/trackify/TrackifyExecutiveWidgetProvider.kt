package com.example.trackify

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

class TrackifyExecutiveWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.trackify_executive_widget_layout).apply {
                val streak = widgetData.getString("widget_streak", "0🔥") ?: "0🔥"
                val habitsCount = widgetData.getString("widget_habits_count", "0 / 0 Done") ?: "0 / 0 Done"
                val nextTask = widgetData.getString("widget_next_task", "Next: Routine") ?: "Next: Routine"
                val totalCost = widgetData.getString("widget_exec_total_cost", "$0.00 / mo") ?: "$0.00 / mo"
                val urgentBadge = widgetData.getString("widget_exec_urgent_badge", "0 Urgent") ?: "0 Urgent"

                setTextViewText(R.id.widget_exec_streak, streak)
                setTextViewText(R.id.widget_exec_habits_count, habitsCount)
                setTextViewText(R.id.widget_exec_next_task, nextTask)
                setTextViewText(R.id.widget_exec_total_cost, totalCost)
                setTextViewText(R.id.widget_exec_urgent_badge, urgentBadge)

                val pendingIntent = HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java,
                    Uri.parse("trackify://open/dashboard")
                )
                setOnClickPendingIntent(R.id.widget_container, pendingIntent)
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}

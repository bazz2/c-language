#include<glib.h>
#include<dbus/dbus.h>
#include<dbus/dbus-glib.h>

static DBusHandlerResult signal_filter(DBusConnection *connection, DBusMessage *message, void *user_data);

int main()
{
	GMainLoop *loop;
	DBusConnection *bus;
	DBusError error;
	loop = g_main_loop_new(NULL, 0);
	dbus_error_init(&error);
	bus = dbus_bus_get(DBUS_BUS_SESSION, &error);
	if(!bus)
	{
		g_warning("Failed to connect to the D-BUS deamon: %s", error.message);
		dbus_error_free(&error);
		return 1;
	}

	dbus_connection_setup_with_g_main(bus,  NULL);
	dbus_bus_add_match(bus, "type='signal',interface='com.burtonini.dbus.Signal'", &error);
	dbus_connection_add_filter(bus, signal_filter, loop, NULL);
	g_main_loop_run(loop);
	return 0;
}

static DBusHandlerResult signal_filter(DBusConnection *connection, DBusMessage *message, void *user_data)
{
	GMainLoop *loop = user_data;
	if(dbus_message_is_signal(message, DBUS_INTERFACE_LOCAL, "Disconnected"))
	{
		g_main_loop_quit(loop);
		return DBUS_HANDLER_RESULT_HANDLED;
	}
	else if (dbus_message_is_signal (message, "com.burtonini.dbus.Signal", "Ping")) 
	{
		DBusError error;
		char *s;
		dbus_error_init(&error);
		if(dbus_message_get_args(message, &error, DBUS_TYPE_STRING, &s, DBUS_TYPE_INVALID))
		{
			g_print("Ping received: %s\n", s);
			dbus_free(s);
		}
		else
		{
			g_print("Ping received, but error getting message: %s\n", error.message);
			dbus_error_free (&error);
		}
		return DBUS_HANDLER_RESULT_HANDLED;
	}
	return DBUS_HANDLER_RESULT_NOT_YET_HANDLED;
}

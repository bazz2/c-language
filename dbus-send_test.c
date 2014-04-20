#include <glib.h>
#include <dbus/dbus.h>
#include <dbus/dbus-glib.h>

static gboolean send_ping(DBusConnection *bus);

int main(int argc, char **argv)
{
	GMainLoop *loop;
	DBusConnection *bus;
	DBusError error;

	//create a new event loop to run in
	loop = g_main_loop_new(NULL, 0);

	//get a connection to the session bus
	dbus_error_init(&error);
	bus = dbus_bus_get(DBUS_BUS_SESSION, &error);
	if(!bus)
	{
		g_warning("Failed to connect to the D-BUS deamon: %s", error.message);
		dbus_error_free(&error);
		return 1;
	}

	//set up this connection to work in a Glib event loop
	dbus_connection_setup_with_g_main(bus, NULL);

	send_ping(bus);

	//start the event loop
	//g_main_loop_run(loop);
}

static gboolean send_ping(DBusConnection *bus)
{
	DBusMessage *message;
	const char *ping_str = "Ping!";
	message = dbus_message_new_signal("/com/burtonini/dbus/ping",
			"com.burtonini.dbus.Signal",
			"Ping");
	dbus_message_append_args(message,
			DBUS_TYPE_STRING, &ping_str,
			DBUS_TYPE_INVALID);

	//send the dignal
	dbus_connection_send(bus, message, NULL);
	dbus_message_unref(message);
	g_print("Ping!\n");
	return 1;
}

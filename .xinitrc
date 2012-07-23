# If you are not using a display manager then you will have to add consolekit,
# e.g.:
#
#     exec ck-launch-session dbus-launch openbox-session
#
# The following works well with SLiM (dbus-launch allows automounting with
# gvfs and Gnome PolKit)
exec dbus-launch openbox-session

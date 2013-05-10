README

2012-11-30 Fixed missing corners.  Black opaque panel background displays corners.
           Added German Translations thanks for the efforts of Tobias Bannert.
           Added function to determine utf8 strings length in bytes.
           Created separate branches for Gnome Shell 3.4 and 3.6.

2012-12-02 Uploaded for review.

2012-12-09 Fixed bug in missing icon logic.
           Removed uneeded string length function.

2012-12-10 v12 and v13 active.

2012-12-14 Updated German Translations thanks to Jonatan Zeidler.
           No programmatic changes. Sources same as v12 GS3.4 and v13 GS3.6.
           Uploaded for review.

2013-01-14 Fixed conflicts with some extensions in GS3.6 when screen was locked.
           Fixed inconsistent custom colors in GS3.4 and GS3.6.
           Added pango formating in prefs tool when entering Activities Text,
           ie. <i>Activities</i> displays text in italics.
           Rounded corners are displayed in the color and transparency selected
           for the panel background.  Rounded corners can be hidden.
           The appearance of rounded corners is affected by screen width and
           height ratio, screen resolution, font size and font scaling, screen
           background image and screen background colors and your panel background
           color choice.  The rounded corners with an opaque black panel background
           work well with almost any background image or color.  Other colors and
           levels of transparency for the panel background may or may not work as
           well with your choice of background image or background color.
           Uploaded for review.

2013-04-30 Added conflict detection and resolution to eliminate conflict with
           the Frippery Move Clock extension.  Uploaded for review.


Activities Configurator

The Activities Text can be changed by entering New Text and then pressing the APPLY button.  The text spacing on the panel is adjustable with the Text Padding scale.  The text can be removed from the panel with the Hide Text switch.

The Activities Icon is selectable with the SELECT Icon button.  The icon spacing on the panel is adjustable with the Icon Padding scale.  The icon can be removed from the panel with the Hide Icon switch.

Text and icon padding is left and right horizontal padding in pixels.

The sensitivity of the hot corner is adjustable with the Hot Corner Sensitivity scale.  A small delay in milliseconds before activation of the hot corner can prevent an inadvertent mouse movement from toggling the Overview.  The default delay is 250 ms which seems to prevent most false Overview toggles.  The hot corner Overview switching is disabled with the Disable Hot Corner switch.  If the hot corner is disabled the Overview can be toggled with the left super key.

The Activities Button can be removed with the Remove Activities Button switch.

The workspace background may appear more aesthetically pleasing without the black panel background.  The color and transparency of the panel background is adjustable with Set Panel Background Button and Panel Transparency scale (0-100%).  The default is 0, no transparency or opaque and 100 is completely transparent.  This feature requires a workspace background of colors which contrast with icons and text displayed in the panel.

Extension settings are reset to their default values with the Extension Defaults RESET button.

The Extension Description README button displays this readme.

Conflicts with other enabled extensions can be detected with the Enable Conflict Detection switch.  This extension prefers the left-most corner of the panel.  Another extension which inserts itself in the left-most corner of the panel is considered in conflict with this preference.  This extension attempts to avoid conflicts by delaying its activation at shell startup time.  The delay appears to resolve most conflicts allowing the extensions to function normally.  Extensions which duplicate the functions of this extension may affect or be affected when both are enabled.  Try different settings for the conflicting extensions in order to avoid conflicts.  Conflict Detection is disabled by default.  Enable only if you experience problems.  When Conflict Detection is enabled, detected conflicts are usually automatically resolved.  If a conflict is detected this extension will re-establish its prefered position in the panel.  If another extension continues to create a conflict this extension will disable itself to avoid a race condition and notify the user.  The user can disable Conflict Detection if it is acceptable to have this extension not in its preferred position.  The conflict can be resolved by disabling the conflicting extension or this extension and restarting the session.

Clicking the Activities Icon or Text with the right mouse button executes GNOME Shell Extension Preferences.

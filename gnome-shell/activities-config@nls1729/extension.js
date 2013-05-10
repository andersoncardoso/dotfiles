/* -*- mode: js2 - indent-tabs-mode: nil - js2-basic-offset: 4 -*- */
/* This extension is a derived work of the Gnome Shell.
*
* Copyright (c) 2012-2013 Norman L. Smith
*
* This extension is free software; you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation; either version 2 of the License, or
* (at your option) any later version.
*
* This extension is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this extension; if not, write to the Free Software
* Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
*/
const Cairo = imports.cairo;
const Atk = imports.gi.Atk;
const Clutter = imports.gi.Clutter;
const Gio = imports.gi.Gio;
const GLib = imports.gi.GLib;
const Shell = imports.gi.Shell;
const St = imports.gi.St;
const DND = imports.ui.dnd;
const Layout = imports.ui.layout;
const Main = imports.ui.main;
const Panel = imports.ui.panel;
const PanelMenu = imports.ui.panelMenu;
const Lang = imports.lang;
const Mainloop = imports.mainloop;

const Gettext = imports.gettext.domain('nls1729-extensions');
const _ = Gettext.gettext;
const _N = function(x) { return x; };

const ExtensionUtils = imports.misc.extensionUtils;
const Me = ExtensionUtils.getCurrentExtension();
const Colors = Me.imports.colors;
const Convenience = Me.imports.convenience;
const Keys = Me.imports.keys;
const Notify = Me.imports.notify;
const Readme = Me.imports.readme;
const CONFLICT = 'Conflict Detected:';
const MIA_ICON = 'Missing Icon:';
const DEFAULT_ICO = Me.path + Keys.ICON_FILE;

const HotterCorner = new Lang.Class({
    Name: 'ActivitiesConfigurator.HotterCorner',
    Extends: Layout.HotCorner,

    _init: function() {
        this.parent(0.0);
        this._delay = 0;
    },

    destroy: function() {
        this.actor.destroy();
        this.parent();
    },

    _onCornerEntered : function() {
        if (!this._entered) {
            this._entered = true;
            if (!Main.overview.animationInProgress) {
                if (this._delay > 0) {
                    Mainloop.timeout_add(this._delay, Lang.bind(this, this._toggleTimeout));
                } else {
                    this._toggleTimeout();
                }
            }
        }
        return false;
    },

    _toggleTimeout: function() {
        if (this._entered) {
            this._activationTime = Date.now() / 1000;
            this.rippleAnimation();
            Main.overview.toggle();
        }
        return false;
    }
});

const ActivitiesIconButton = new Lang.Class({
    Name: 'ActivitiesConfigurator.ActivitiesIconButton',
    Extends: PanelMenu.Button,

    _init: function() {
        this.parent(0.0);
        this.actor.accessible_role = Atk.Role.TOGGLE_BUTTON;
        this._signals = [];
        let container = new Shell.GenericContainer();
        container.name = 'panelActivitiesIconButtonContainer';
        this._signals[0] = container.connect('get-preferred-width', Lang.bind(this, this._containerGetPreferredWidth));
        this._signals[1] = container.connect('get-preferred-height', Lang.bind(this, this._containerGetPreferredHeight));
        this._signals[2] = container.connect('allocate', Lang.bind(this, this._containerAllocate));
        this.actor.add_actor(container);
        this.actor.name = 'panelActivitiesIconButton';
        this._iconLabelBox = new St.BoxLayout();
        this._iconBin = new St.Bin();
        this._textBin = new St.Bin();
        this._iconLabelBox.add(this._iconBin);
        this._label = new St.Label();
        this._textBin.child = this._label;
        this._iconLabelBox.add(this._textBin);
        container.add_actor(this._iconLabelBox);
        this._hotCorner = new HotterCorner();
        container.add_actor(this._hotCorner.actor);
        this.menu.open = Lang.bind(this, this._onMenuOpenRequest);
        this.menu.close = Lang.bind(this, this._onMenuCloseRequest);
        this.menu.toggle = Lang.bind(this, this._onMenuToggleRequest);
        this._signals[3] = this.actor.connect('captured-event', Lang.bind(this, this._onCapturedEvent));
        this._signals[4] = this.actor.connect_after('button-release-event', Lang.bind(this, this._onButtonRelease));
        this._signals[5] = this.actor.connect_after('key-release-event', Lang.bind(this, this._onKeyRelease));
        this._signals[6] = this.actor.connect('style-changed', Lang.bind(this, this._onStyleChanged));
        this._minHPadding = this._natHPadding = 0.0;
        this._signals[7] = Main.overview.connect('showing', Lang.bind(this, this._overviewShowing));
        this._signals[8] = Main.overview.connect('hiding', Lang.bind(this, this._overviewHiding));
        this._xdndTimeOut = 0;
    },

    _onStyleChanged: function(actor) {
        this._minHPadding = this._natHPadding = 0.0;
    },

    _overviewShowing: function() {
        this.actor.add_style_pseudo_class('overview');
        this._escapeMenuGrab();
        this.actor.add_accessible_state(Atk.StateType.CHECKED);
    },

    _overviewHiding: function() {
        this.actor.remove_style_pseudo_class('overview');
        this._escapeMenuGrab();
        this.actor.remove_accessible_state(Atk.StateType.CHECKED);
    },

    _containerGetPreferredWidth: function(actor, forHeight, alloc) {
        [alloc.min_size, alloc.natural_size] = this._iconLabelBox.get_preferred_width(forHeight);
    },

    _containerGetPreferredHeight: function(actor, forWidth, alloc) {
        [alloc.min_size, alloc.natural_size] = this._iconLabelBox.get_preferred_height(forWidth);
    },

    _containerAllocate: function(actor, box, flags) {
        this._iconLabelBox.allocate(box, flags);
        let primary = Main.layoutManager.primaryMonitor;
        let hotBox = new Clutter.ActorBox();
        let ok, x, y;
        if (actor.get_text_direction() == Clutter.TextDirection.LTR)
            [ok, x, y] = actor.transform_stage_point(primary.x, primary.y);
        else
            [ok, x, y] = actor.transform_stage_point(primary.x + primary.width, primary.y);
        hotBox.x1 = Math.round(x);
        hotBox.x2 = hotBox.x1 + this._hotCorner.actor.width;
        hotBox.y1 = Math.round(y);
        hotBox.y2 = hotBox.y1 + this._hotCorner.actor.height;
        this._hotCorner.actor.allocate(hotBox, flags);
    },

    handleDragOver: function(source, actor, x, y, time) {
        if (source != Main.xdndHandler)
            return DND.DragMotionResult.CONTINUE;
        if (this._xdndTimeOut != 0)
            Mainloop.source_remove(this._xdndTimeOut);
        this._xdndTimeOut = Mainloop.timeout_add(BUTTON_DND_ACTIVATION_TIMEOUT,
                                                 Lang.bind(this, this._xdndShowOverview, actor));
        return DND.DragMotionResult.CONTINUE;
    },

    _escapeMenuGrab: function() {
        if (this.menu.isOpen)
            this.menu.close();
    },

    _onCapturedEvent: function(actor, event) {
        if (event.type() == Clutter.EventType.BUTTON_PRESS) {
            if (event.get_button() == 3) {
                Main.Util.trySpawnCommandLine('gnome-shell-extension-prefs ' + Me.metadata.uuid);
                return true;
            }
            if (!this._hotCorner.shouldToggleOverviewOnClick())
                return true;
        }
        return false;
    },

    _onMenuOpenRequest: function() {
        this.menu.isOpen = true;
        this.menu.emit('open-state-changed', true);
    },

    _onMenuCloseRequest: function() {
        this.menu.isOpen = false;
        this.menu.emit('open-state-changed', false);
    },

    _onMenuToggleRequest: function() {
        this.menu.isOpen = !this.menu.isOpen;
        this.menu.emit('open-state-changed', this.menu.isOpen);
    },

    _onButtonRelease: function() {
        if (this.menu.isOpen) {
            this.menu.close();
            Main.overview.toggle();
        }
    },

    _onKeyRelease: function(actor, event) {
        let symbol = event.get_key_symbol();
        if (symbol == Clutter.KEY_Return || symbol == Clutter.KEY_space) {
            if (this.menu.isOpen)
                this.menu.close();
            Main.overview.toggle();
        }
    },

    _xdndShowOverview: function(actor) {
        let [x, y, mask] = global.get_pointer();
        let pickedActor = global.stage.get_actor_at_pos(Clutter.PickMode.REACTIVE, x, y);
        if (pickedActor == this.actor) {
            if (!Main.overview.visible && !Main.overview.animationInProgress) {
                Main.overview.showTemporarily();
                Main.overview.beginItemDrag(actor);
            }
        }
        Mainloop.source_remove(this._xdndTimeOut);
        this._xdndTimeOut = 0;
    },

    destroy: function() {
        let child = Main.panel._leftBox.find_child_by_name('panelActivitiesIconButtonContainer');
        child.disconnect(this._signals[0]);
        child.disconnect(this._signals[1]);
        child.disconnect(this._signals[2]);
        this.actor.disconnect(this._signals[3]);
        this.actor.disconnect(this._signals[4]);
        this.actor.disconnect(this._signals[5]);
        this.actor.disconnect(this._signals[6]);
        Main.overview.disconnect(this._signals[7]);
        Main.overview.disconnect(this._signals[8]);
        this.parent();
    }
});

const Configurator = new Lang.Class({
    Name: 'ActivitiesConfigurator.Configurator',

    _init : function() {
        this._enabled = false;
        this._settings = Convenience.getSettings();
        this._savedText = this._settings.get_string(Keys.ORI_TXT);
        this._iconPath = '';
        this._checkConflictSignal = null;
        this._conflictCount = 0;
        this._timeoutId = 0;
        this._conflictDetection = false;
        this._panelColor = Colors.getColorRGB(this._settings.get_string(Keys.COLOURS));
        this._panelOpacity = (100 - this._settings.get_int(Keys.TRS_PAN)) / 100;
        this._roundedCornersHidden = false;
        this._transparencySig = null;
        this._signalIdLC = null;
        this._signalIdRC = null;
        this._activitiesIndicator = null;
        this._signalShow = null;
    },

    _connectSettings: function() {
        this._settingsSignals = [];
        this._settingsSignals.push(this._settings.connect('changed::'+Keys.REMOVED, Lang.bind(this, this._setActivities)));
        this._settingsSignals.push(this._settings.connect('changed::'+Keys.NEW_TXT, Lang.bind(this, this._setText)));
        this._settingsSignals.push(this._settings.connect('changed::'+Keys.NEW_ICO, Lang.bind(this, this._setIcon)));
        this._settingsSignals.push(this._settings.connect('changed::'+Keys.HOTC_TO, Lang.bind(this, this._setHotCornerTimeOut)));
        this._settingsSignals.push(this._settings.connect('changed::'+Keys.NO_HOTC, Lang.bind(this, this._setHotCorner)));
        this._settingsSignals.push(this._settings.connect('changed::'+Keys.NO_TEXT, Lang.bind(this, this._setText)));
        this._settingsSignals.push(this._settings.connect('changed::'+Keys.NO_ICON, Lang.bind(this, this._setIcon)));
        this._settingsSignals.push(this._settings.connect('changed::'+Keys.PAD_TXT, Lang.bind(this, this._setText)));
        this._settingsSignals.push(this._settings.connect('changed::'+Keys.PAD_ICO, Lang.bind(this, this._setIcon)));
        this._settingsSignals.push(this._settings.connect('changed::'+Keys.COLOURS, Lang.bind(this, this._setPanelColor)));
        this._settingsSignals.push(this._settings.connect('changed::'+Keys.CON_DET, Lang.bind(this, this._setConflictDetection)));
        this._settingsSignals.push(this._settings.connect('changed::'+Keys.HIDE_RC, Lang.bind(this, this._setHiddenCorners)));
        this._transparencySig = this._settings.connect('changed::'+Keys.TRS_PAN, Lang.bind(this, this._setPanelTransparency));
        this._signalIdLC = Main.panel._leftCorner.actor.connect('repaint', Lang.bind(this, this._redoLeft));
        this._signalIdRC = Main.panel._rightCorner.actor.connect('repaint', Lang.bind(this, this._redoRight));
    },

    _disconnectSignals: function() {
        if(this._checkConflictSignal != null) {
            Main.panel._leftBox.disconnect(this._checkConflictSignal);
            this._checkConflictSignal = null;
        }
        while(this._settingsSignals.length > 0) {
	    this._settings.disconnect(this._settingsSignals.pop());
        }
        if(this._transparencySig != null) {
            this._settings.disconnect(this._transparencySig);
            this._transparencySig = null;
        }
        if(this._signalIdLC != null) {
            Main.panel._leftCorner.actor.disconnect(this._signalIdLC);
            this._signalIdLC = null;
        }
        if(this._signalIdRC != null) {
            Main.panel._rightCorner.actor.disconnect(this._signalIdRC);
            this._signalIdRC = null;
        }
    },

    _setIcon: function() {
        let iconPath = this._settings.get_string(Keys.NEW_ICO);
        if(this._iconPath != iconPath) {
            if (!GLib.file_test(iconPath, GLib.FileTest.EXISTS)) {
                Notify.notifyError(_N(MIA_ICON),Readme.makeTextStr(Readme.ICON_MIA));
                iconPath = DEFAULT_ICO;
                this._settings.set_string(Keys.NEW_ICO, DEFAULT_ICO);
            }
            this._activitiesIconButton._iconBin.child = new St.Icon({ gicon: Gio.icon_new_for_string(iconPath) });
            this._activitiesIconButton._iconBin.child.style_class = 'activities-icon';
            this._iconPath = iconPath;
        }
        if(this._settings.get_boolean(Keys.NO_ICON)) {
            this._activitiesIconButton._iconBin.hide();
        } else {
            let pixels = this._settings.get_int(Keys.PAD_ICO);
            let iconStyle = 'icon-size: 1.5em; padding-left: %dpx; padding-right: %dpx'.format(pixels, pixels);
            this._activitiesIconButton._iconBin.show();
            this._activitiesIconButton._iconBin.child.set_style(iconStyle);
        }
    },

    _setText: function() {
        let labelText = this._settings.get_string(Keys.NEW_TXT) || this._savedText;
        if(this._settings.get_boolean(Keys.NO_TEXT))
            labelText = '';
        this._activitiesIconButton._label.set_text(labelText);
        if(labelText != '') {
            let pixels = this._settings.get_int(Keys.PAD_TXT);
            let textStyle = 'padding-left: %dpx; padding-right: %dpx'.format(pixels, pixels);
            this._activitiesIconButton._label.set_style(textStyle);
            let ct = this._activitiesIconButton._label.get_clutter_text();
            ct.set_use_markup(true);
        }
    },

    _setHotCornerTimeOut: function() {
        this._activitiesIconButton._hotCorner._delay = this._settings.get_int(Keys.HOTC_TO);
    },

    _setHotCorner: function() {
        if(this._settings.get_boolean(Keys.NO_HOTC))
            this._activitiesIconButton._hotCorner.actor.hide();
        else
            this._activitiesIconButton._hotCorner.actor.show();
    },

    _setActivities: function() {
        let indicator = Main.panel.statusArea['activities-icon-button'];
        if(indicator != null) {
            if(this._settings.get_boolean(Keys.REMOVED)) {
                indicator.container.hide();
            } else {
                indicator.container.show();
            }
        }
    },

    _setPanelStyle: function(backgroundStyle) {
        Main.panel.actor.set_style(backgroundStyle);
    },
 
    _removePanelStyle: function() {
        Main.panel.actor.set_style(null);
        if(this._roundedCornersHidden) {
            Main.panel._leftCorner.actor.hide();
            Main.panel._rightCorner.actor.hide();
        } else {
            Main.panel._leftCorner.actor.show();
            Main.panel._rightCorner.actor.show();
        }
    },

    _setPanelColor: function() {
        this._panelColor = Colors.getColorRGB(this._settings.get_string(Keys.COLOURS));
        this._setPanelBackground();
    },

    _setPanelTransparency: function() {
        this._panelOpacity = (100 - this._settings.get_int(Keys.TRS_PAN)) / 100;
        if(this._transparencySig != null) {
            this._settings.disconnect(this._transparencySig);
            this._transparencySig = null;
            this._setPanelBackground();
        }
    },

    _setHiddenCorners: function() {
        this._roundedCornersHidden = this._settings.get_boolean(Keys.HIDE_RC);
        this._setPanelBackground();
    },

    _setPanelBackground: function() {;
        let colorString = Colors.getColorStringCSS(this._panelColor);
        if(colorString == '0,0,0' && this._panelOpacity == 1) {
            this._removePanelStyle();
        } else {
            let backgroundStyle = 'background-color: rgba(' + colorString + ',' + this._panelOpacity.toString() + ')';
            this._setPanelStyle(backgroundStyle);
            if(this._panelOpacity < .05 || this._roundedCornersHidden) {
                Main.panel._leftCorner.actor.hide();
                Main.panel._rightCorner.actor.hide();
            } else {
                Main.panel._leftCorner.actor.show();
                Main.panel._rightCorner.actor.show();
            }
        }
        if(this._transparencySig == null) {
            this._transparencySig = this._settings.connect('changed::'+Keys.TRS_PAN, Lang.bind(this, this._setPanelTransparency));
        }
    },

    _redoLeft: function() {
        this._repaintPanelCorner(Main.panel._leftCorner);
    },

    _redoRight: function() {
        this._repaintPanelCorner(Main.panel._rightCorner);
    },

    _repaintPanelCorner: function(corner) {
        let panelBackgroundColor = Colors.getClutterColor(this._panelColor, this._panelOpacity);
        let node = corner.actor.get_theme_node();
        let cornerRadius = node.get_length('-panel-corner-radius');
        let borderWidth = node.get_length('-panel-corner-border-width');
        let borderColor = node.get_color('-panel-corner-border-color');
        let cr = corner.actor.get_context();
        cr.setOperator(Cairo.Operator.SOURCE);
        cr.moveTo(0, 0);
        if (corner._side == St.Side.LEFT)
            cr.arc(cornerRadius, borderWidth + cornerRadius, cornerRadius, Math.PI, 3 * Math.PI / 2);
        else
            cr.arc(0, borderWidth + cornerRadius, cornerRadius, 3 * Math.PI / 2, 2 * Math.PI);
        cr.lineTo(cornerRadius, 0);
        cr.closePath();
        let savedPath = cr.copyPath();
        let xOffsetDirection = corner._side == St.Side.LEFT ? -1 : 1;
        let over = Panel._over(borderColor, panelBackgroundColor);
        Clutter.cairo_set_source_color(cr, over);
        cr.fill();
        let offset = borderWidth;
        Clutter.cairo_set_source_color(cr, panelBackgroundColor);
        cr.save();
        cr.translate(xOffsetDirection * offset, - offset);
        cr.appendPath(savedPath);
        cr.fill();
        cr.restore();
        return true;
    },

    _setConflictDetection: function() {
        this._conflictDetection = this._settings.get_boolean(Keys.CON_DET);
        if(this._conflictDetection && this._enabled)
            this._conflicts();
        if(this._conflictDetection && this._checkConflictSignal == null)
            this._checkConflictSignal = Main.panel._leftBox.connect('actor-added', Lang.bind(this, this._conflicts));
        if(!this._conflictDetection && this._checkConflictSignal != null) {
            Main.panel._leftBox.disconnect(this._checkConflictSignal);
            this._checkConflictSignal = null;
        }
    },

    destroy: function() {
        this._activitiesIconButton.destroy();
        this._activitiesIconButton = null;
    },

/*  Conflict Resolution:

    This extension's ActivitiesIconButton prefers to occupy the Activities position (the leftmost) in the Panel.
    At session startup this extension delays its enable processing for 500ms to insure that it can insert itself
    in the left panel at position 0.  This solves most conflicts.  If another extension inserts an indicator in
    position 0 at a later time then the ActivitiesIconButton can be moved from its preferred place. To re-establish
    its position this function is called when an 'actor-added' signal occurs.  A race condition can occur if another
    extension follows this strategy.  This extension will stop the race if one is detected.  If the user does not
    care about the position of the ActivitiesIconButton, conflict detection can be disabled.
*/
    _conflicts: function() {
        if (Main.sessionMode.currentMode == 'user') {
            let children = Main.panel._leftBox.get_children();
            let child = children[0].find_child_by_name('panelActivitiesIconButtonContainer');
            if(child == null) {
                this._conflictCount = this._conflictCount + 1;
                if(this._conflictCount > 30) {
                    Notify.notifyError(_N(CONFLICT),Readme.makeTextStr(Readme.CONFLICTS));
                    this._conflictCount = 0;
                    this.disable();
                } else {
                    this.disable();
                    this._delayedEnable();
                }
            }
        }
    },

    _delayedEnable: function() {
        if(this._timeoutId != 0) {
            Mainloop.source_remove(this._timeoutId);
            this._timeoutId = 0;
        }
        this._activitiesIconButton = new ActivitiesIconButton();
        this._activitiesIndicator = Main.panel.statusArea['activities'];
        if(this._activitiesIndicator != null) {
            this._signalShow = this._activitiesIndicator.container.connect('show', Lang.bind(this, function() {
                this._activitiesIndicator = Main.panel.statusArea['activities'];
                if(this._activitiesIndicator != null)
                    this._activitiesIndicator.container.hide();
           }));
           this._activitiesIndicator.container.hide();
        }
        Main.panel.addToStatusArea('activities-icon-button', this._activitiesIconButton, 0, 'left');
        this._connectSettings();
        this._setText();
        this._iconPath = '';
        this._setIcon();
        this._setHotCornerTimeOut();
        this._setHotCorner();
        this._setHiddenCorners();
        this._setPanelBackground();
        this._setActivities();
        this._setConflictDetection();
        this._enabled = true;
    },

    enable: function() {
        this._conflictDetection = this._settings.get_boolean(Keys.CON_DET);
        if(this._conflictDetection && Main.sessionMode.currentMode == 'user') {
            this._timeoutId = Mainloop.timeout_add(500, Lang.bind(this, this._delayedEnable));
        } else {
            this._delayedEnable();
        }
    },

    disable: function() {
        if(this._timeoutId != 0) {
            Mainloop.source_remove(this._timeoutId);
            this._timeoutId = 0;
        }
        if (this._enabled) {
            this._disconnectSignals();
            this._removePanelStyle();;
            this._activitiesIndicator = Main.panel.statusArea['activities'];
            if(this._activitiesIndicator != null) {
                if(this._signalShow != null)
                    this._activitiesIndicator.container.disconnect(this._signalShow);
                this._activitiesIndicator.container.show();
            }
            this._activitiesIconButton.destroy();
            this._activitiesIconButton = null;
            this._enabled = false;
        }
    }
});

function init(metadata) {
    Convenience.initTranslations();
    return new Configurator();
}

// remove-bluetooth-icon - Removes the bluetooth icon from the panel
// Copyright (c) 2011-2013 Fabian Affolter <fabian at affolter-engineering.ch>
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

const Main  = imports.ui.main;

function init() {
}

function enable() {
    if(typeof Main.panel._statusArea !== 'undefined') {
        Main.panel._statusArea['bluetooth'].actor.hide();
    } else {
        Main.panel.statusArea['bluetooth'].actor.hide();
    }
}

function disable() {
    if(typeof Main.panel._statusArea !== 'undefined') {
        Main.panel._statusArea['bluetooth'].actor.show();
    } else {
        Main.panel.statusArea['bluetooth'].actor.show();
    }
}

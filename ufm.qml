import QtQuick 2.0
import QtMultimedia 5.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem

/*!
    \brief MainView with Tabs element.
           First Tab has a single Label and
           second Tab has a single ToolbarAction.
*/

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"
    applicationName: "ufm"
    
    width: units.gu(45)
    height: units.gu(80)
    
    Tabs {
        id: tabs
        anchors.fill: parent
        
        // First tab <ChannelList> begins here
        Tab {
            objectName: "ChannelTab"
            
            title: i18n.tr("频道列表")
            
            // Tab content begins here
            page: Channels { id: channel }
        }
        
        // Second tab <Player> begins here
        Tab {
            id: fm
            objectName: "FMTab"
            
            title: channel.name + "MHz"
            page: Player { id: player }
        }

        // Third tab <Setting> begins here
        Tab {
            id: setting
            objectName: "SettingTab"

            title: loginForm.logined ? loginForm.name : i18n.tr("登录")
            page: LoginForm { id: loginForm }
        }

        Component.onCompleted: selectedTabIndex = 1
    }
}

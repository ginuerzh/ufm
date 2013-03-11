import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem

Page {
    id: channel
    objectName: "ChannelList"

    property int cid: channelModel.get(channelList.currentIndex).cid
    property string name: channelModel.get(channelList.currentIndex).name

    // song start playing from here
    onCidChanged: {
        player.newChannel()
    }

    ListView {
        id: channelList
        anchors.fill: parent

        Component.onCompleted: currentIndex = 2
        ListModel {
            id: channelModel

            ListElement { cid: 0; name: "我的私人"; type: "私人电台" }
            ListElement { cid: -3; name: "我的红星"; type: "私人电台" }

            ListElement { cid: 1; name: "华语"; type: "公共电台" }
            ListElement { cid: 6; name: "粤语"; type: "公共电台" }
            ListElement { cid: 2; name: "欧美"; type: "公共电台" }
            ListElement { cid: 22; name: "法语"; type: "公共电台" }
            ListElement { cid: 17; name: "日语"; type: "公共电台" }
            ListElement { cid: 18; name: "韩语"; type: "公共电台" }
            ListElement { cid: 3; name: "70"; type: "公共电台" }
            ListElement { cid: 4; name: "80"; type: "公共电台" }
            ListElement { cid: 5; name: "90"; type: "公共电台" }
            ListElement { cid: 7; name: "摇滚"; type: "公共电台" }
            ListElement { cid: 8; name: "民谣"; type: "公共电台" }
            ListElement { cid: 9; name: "轻音乐"; type: "公共电台" }
            ListElement { cid: 10; name: "电影原声"; type: "公共电台" }
            ListElement { cid: 13; name: "爵士"; type: "公共电台" }
            ListElement { cid: 14; name: "电子"; type: "公共电台" }
            ListElement { cid: 15; name: "说唱"; type: "公共电台" }
            ListElement { cid: 16; name: "R&B"; type: "公共电台" }
            ListElement { cid: 20; name: "女生"; type: "公共电台" }
        }

        model: channelModel
        delegate: ListItem.Standard {
            text: i18n.tr(name) + " MHz"
            selected: ListView.isCurrentItem
            onClicked: {
                ListView.view.currentIndex = index
            }
        }

        section.property: "type"
        section.criteria: ViewSection.FullString
        section.labelPositioning: ViewSection.CurrentLabelAtStart | ViewSection.InlineLabels
        section.delegate: ListItem.Caption { text: i18n.tr(section) }

        Scrollbar { flickableItem: parent }
    }
}


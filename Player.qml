import QtQuick 2.0
import Ubuntu.Components 0.1
import QtMultimedia 5.0
import "Utils.js" as Utils

Page {
    id: player
    objectName: "playerPage"

    property bool rapidLoad: true

    signal rated(bool like)
    signal banned

    tools: toolbar

    SequentialAnimation {
        id: ani
        running: true
        PropertyAction { target: toolbar; property: "active"; value: "false" }
        PauseAnimation { duration: 1000 }
        PropertyAction { target: toolbar; property: "active"; value: "true" }
        PauseAnimation { duration: 3000 }
        PropertyAction { target: toolbar; property: "active"; value: "false" }
    }

    Song { id: song }

    Column {
        anchors.centerIn: parent
        spacing: units.gu(2)

        Image {
            width: units.gu(35)
            height: units.gu(38)
            anchors.horizontalCenter: parent.horizontalCenter

            source: song.picSource

            Rectangle {
                id: bgc
                anchors.fill: parent
                color: "black"
                opacity: 0.3
                visible: false
            }

            Text {
                id: pauseTip
                anchors.centerIn: parent

                text: "II"
                color: "darkorange"
                font { pointSize: 50; bold: true }

                visible: false
            }

            states:State {
                name: "PAUSE"
                PropertyChanges { target: bgc; visible: true }
                PropertyChanges { target: pauseTip; visible: true }
            }

            MouseArea {
                id: pauseClick
                anchors.fill: parent
                onClicked: {
                    if (audio.playbackState == Audio.StoppedState)
                        return
                    // Pause Play
                    if (parent.state == "") {
                        parent.state = "PAUSE"
                        audio.pause()
                    }
                    else {
                        parent.state = ""
                        audio.play()
                    }
                }
            }
        }

        Label {
            id: position
            anchors.horizontalCenter: parent.horizontalCenter
            text:"0 : 00"
        }

        Label {
            width: parent.width
            horizontalAlignment: Text.AlignHCenter

            text: song.name + " - " + song.artist + "    " + song.publicTime
            fontSize: "large"
            elide: Text.ElideMiddle
        }
    }

    ToolbarActions {
        id: toolbar

        Action {
            iconSource: song.like ? Qt.resolvedUrl("like.png") : Qt.resolvedUrl("unlike.png")
            text: song.like ? i18n.tr("喜欢") : i18n.tr("不喜欢")
            onTriggered: {
                song.like = !song.like
                player.rate(song.like)
                player.rated(song.like)
            }
        }
        Action {
            iconSource: Qt.resolvedUrl("ban.png")
            text: i18n.tr("不再收听")
            onTriggered: {
                player.ban()
                player.banned()
            }
        }
        Action {
            iconSource: Qt.resolvedUrl("next.png")
            text: i18n.tr("下一首")
            onTriggered: player.skip()
        }
    }

    Audio {
        id: audio

        source: song.source
        autoLoad: true

        onStatusChanged: {
            if (status == Audio.EndOfMedia) {
                player.endReport();
                nextSong();
            } else if (status == Audio.Loaded) {
                //Utils.log("loaded");
                play();
            } else if (status == Audio.Buffered) {
                //Utils.log("Buffered");
                timer.restart();
            }
            /*else if (status == Audio.Loading) {
                console.log("loading");
            }  else if (status == Audio.Stalled) {
                console.log("stalled");
            } else if (status == Audio.InvalidMedia) {
                console.log("InvalidMedia");
            } else if (status == Audio.UnknownStatus) {
                console.log("UnknownStatus");
            } else if (status == Audio.NoMedia) {
                console.log("NoMedia")
            }
            */
        }
    }

    Timer {
        id: timer
        interval: 250
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            var time = new Date(audio.position)
            position.text = Qt.formatTime(time, "m : ss")
        }
    }

    JSONListModel {
        id: statusModel
        query: "$"

        onJsonChanged: {
            if (count > 0) {
                var o = model.get(0);
                if (o.r === 0) {
                    songModel.json = json;
                } else {
                    Utils.log(o.err);
                }
            } else {
                console.log(json);
            }
        }
    }

    JSONListModel {
        id: songModel
        query: "$.song[*]"
        clear: false

        onJsonChanged: {
            if (count > 0) {
                player.nextSong();
            } else {
                Utils.log("error, no song in list");
            }
        }
    }

    function nextSong() {
        if (songModel.count == 0) {
            player.newSongs();  // song list is empty, request new song list.
            return false;
        }

        Utils.log("song list: " + songModel.count);

        if (!player.rapidLoad) {
            return false;
        }

       song.songInfo = songModel.model.get(0);
        songModel.model.remove(0);

        return true;
    }

    function request(type) {
        var url = "http://douban.fm/j/mine/playlist?" + parameter(type);
        Utils.log(url)
        if (type !== "e") {
            Utils.log("song list clear");
            songModel.model.clear();
        }
        statusModel.source = url;
    }

    function newChannel() {
        player.rapidLoad = true;
        request("n");
    }
    function endReport() {
        player.rapidLoad = true;
        request("e");
    }
    function skip() {
        player.rapidLoad = true;
        request("s")
    }
    function newSongs() {
        player.rapidLoad = true;
        request("p")
    }
    function ban() {

        player.rapidLoad = true;
        request("b");
    }
    function rate(like) {
        player.rapidLoad = false;

        if (like) {
            request("r");
        } else {
            request("u");
        }
    }

    function parameter(type) {
        var r = Number(Math.round(Math.random() * 0xF000000000) + 0x1000000000).toString(16);
        var s = "";
        s += ("type=" + type);
        s += ("&channel=" + channel.cid);
        s += ("&sid=" + song.sid);
        s += ("&pt=" + Math.round(audio.position / 1000));
        s += ("&r=" + r);
        s += ("&pb=64&from=mainsite");

        return s;
    }
}

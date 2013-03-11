import QtQuick 2.0

QtObject {
    objectName: "SongObject"

    property var songInfo: ({
                picture     : "douban.png",      // album picture url
                albumtitle  : "",
                //adtype      : 0,
                //company     : "",
                //rating_avg  : 0.0,
                public_time :"",
                //ssid        : "",
                album       : "",
                like        : 0,
                artist      : "",
                url         : "",
                title       : "",
                //subtype     : "",
                //length      : 0,
                sid         : "",
                //aid         : ""
    })

    property string sid
    property url source
    property url picSource
    property string album
    property url albumSource
    property string name
    property string artist
    property string publicTime
    property bool like

    onSongInfoChanged: {
        if (songInfo) {
            sid = songInfo.sid
            source = songInfo.url
            picSource = songInfo.picture.replace(/mpic/, "lpic")
            album = songInfo.albumtitle
            albumSource = songInfo.album
            name = songInfo.title
            artist = songInfo.artist
            publicTime = songInfo.public_time
            like = songInfo.like
        }
    }

}

import QtQuick 2.0

QtObject {
    id: user

    property var userInfo: ({
                                id: "",
                                name: "",
                                is_dj: false,
                                is_pro: false,
                                play_record: ({
                                                  liked: 0,
                                                  banned: 0,
                                                  played: 0,
                                              })
                            })
    property string name
    property bool isDJ
    property bool isPro
    property int liked
    property int banned
    property int played

    onUserInfoChanged: {
        if (userInfo) {
            name = userInfo.name
            isDJ = userInfo.is_dj
            isPro = userInfo.is_pro
            liked = userInfo.play_record.liked
            banned = userInfo.play_record.banned
            played = userInfo.play_record.played
        }
    }
}

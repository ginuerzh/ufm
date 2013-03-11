import QtQuick 2.0
import Ubuntu.Components 0.1
import "Utils.js" as Utils

Page {
    id: setting
    property bool logined: false
    property alias name: user.name

    tools: toolbar

    states: [
        State {
            name: "LOGIN"
            PropertyChanges { target: setting; logined: true }
            PropertyChanges { target: logoutAct; visible: true }
            PropertyChanges { target: toolbar; active: true }
            PropertyChanges { target: info; opacity: 1 }
            PropertyChanges { target: loginForm; opacity: 0 }
        },
        State {
            name: "LOGOUT"
            PropertyChanges { target: setting; logined: false }
            PropertyChanges { target: errMsg; text: " " }
            PropertyChanges { target: logoutAct; visible: false }
            PropertyChanges { target: captcha; text: "" }
            PropertyChanges { target: captchaImg; source: "" }
            PropertyChanges { target: info; opacity: 0 }
            PropertyChanges { target: loginForm; opacity: 1 }
        }
    ]
    state: "LOGOUT"
    transitions: Transition {
        NumberAnimation { property: "opacity"; duration: 500 }
    }

    Connections {
        target: player
        onRated: (setting.logined && like) ? ++user.liked : --user.liked
        onBanned: setting.logined ? ++user.banned : user.banned
    }

    Column {
        id: loginForm

        anchors.centerIn: parent
        spacing: units.gu(1)

        Label {
            id: errMsg

            color: "red"
            text: " "
        }

        Row {
            spacing: units.gu(2)

            Label {
                anchors.verticalCenter: parent.verticalCenter
                text: i18n.tr("用户名:")
            }

            TextField {
                id: username

                KeyNavigation.tab: password
                placeholderText: i18n.tr("用户名/邮箱地址")
            }
        }

        Row {
            spacing: units.gu(2)

            Label {
                anchors.verticalCenter: parent.verticalCenter
                text: i18n.tr("密    码:")
            }

            TextField {
                id: password

                echoMode: TextInput.Password
                KeyNavigation.tab: captcha
                KeyNavigation.backtab: username
            }
        }

        Row {
            spacing: units.gu(2)

            Label {
                anchors.verticalCenter: parent.verticalCenter
                text: i18n.tr("验证码:")
            }

            TextField {
                id: captcha

                KeyNavigation.tab: username
                KeyNavigation.backtab: password
            }
        }

        Row {
            spacing: units.gu(2)
            /* this function has not been implemented
            Row {
                spacing: units.gu(1)

                CheckBox {id: autoLogin }

                Label {
                    anchors.verticalCenter: parent.verticalCenter
                    text: i18n.tr("下次自动登录")
                }
            }
            */
            Row {
                spacing: units.gu(8.5)
                Rectangle {
                    width: units.gu(15)
                    height: units.gu(4)
                    color: "lightgray"

                    Label { anchors.centerIn: parent; text: i18n.tr("点击获取验证码") }
                    Image {
                        id: captchaImg
                        property string captchaId: ""

                        anchors.fill: parent
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: Utils.getCaptcha(captchaImg);
                    }
                }
                Button {
                    text: i18n.tr("登录")

                    onClicked: Utils.login(username.text,
                                             password.text,
                                             captcha.text,
                                             captchaImg.captchaId,
                                             statusModel)
                }
            }
        }


    }

    Grid {
        id: info
        anchors.centerIn: parent
        columns: 2
        spacing: units.gu(2)

        opacity: 0

        Label { text: i18n.tr("用户昵称:") }
        Label { text: user.name }

        Label { text: i18n.tr("DJ:") }
        Label { text: user.isDJ ? i18n.tr("是") : i18n.tr("不是") }

        Label { text: i18n.tr("PRO:") }
        Label { text: user.isPro ? i18n.tr("是") : i18n.tr("不是") }

        Label { text: i18n.tr("累计播放:") }
        Label { text: user.played + i18n.tr("首") }

        Label { text: i18n.tr("加红星:") }
        Label { text: user.liked + i18n.tr("首") }

        Label { text: i18n.tr("不再播放:") }
        Label { text: user.banned + i18n.tr("首") }

    }

    ToolbarActions {
        id: toolbar

        Action {
            id: logoutAct
            iconSource: Qt.resolvedUrl("logout.png")
            text: i18n.tr("退出")
            onTriggered: {
                // Logout
                Utils.logout(userModel.model.get(0).ck)
                setting.state = "LOGOUT"
            }
        }
    }

    User { id: user }

    JSONListModel {
        id: userModel
        query: "$.user_info"

        onJsonChanged: {
            if (count > 0) {
                // Login
                user.userInfo = userModel.model.get(0)
                setting.state = "LOGIN"
            }
        }
    }

    JSONListModel {
        id: statusModel
        query: "$"

        onJsonChanged: {
            if (count > 0) {
                var o = model.get(0);
                if (o.r === 0) {
                    userModel.json = json;
                } else {
                    errMsg.text = o.err_msg;
                    if (o.err_no === 1011) {    // captcha error
                        Utils.getCaptcha(captchaImg);
                    }
                }
            } else {
                Utils.log(json);
            }
        }
    }
}



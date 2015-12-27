import VPlay 2.0
import QtQuick 2.0
import "../"
import VPlayPlugins.admob 1.0
import VPlayPlugins.chartboost 1.1

SceneBase {
  id:menuScene

  // signal indicating that the gameScene should be displayed
  signal gameScenePressed

  // background image
  Rectangle {
    anchors.fill: parent
    color: "white"
  }

  Image{
      source: "../../assets/tilegame-jucking-jump.png"
      x:0
      y: 120
  }

  // column aligns its child components within a column
  Column {
    anchors.centerIn: parent
    spacing: 10

    // play button to start game
    Rectangle {
      width: gameSceneButton.width
      height: gameSceneButton.height
      Image {
        id: gameSceneButton
        source: "../../assets/playButton.png"
        anchors.centerIn: parent
      }

      MouseArea {
        id: gameSceneMouseArea
        anchors.fill: parent
        onClicked: gameScenePressed()
      }
    }

    // score button to open leaderboard
    Rectangle {
        width: scoreSceneButton.width
        height: scoreSceneButton.height
      Image {
        id: scoreSceneButton
        source: "../../assets/scoreButton.png"
        anchors.centerIn: parent
      }
      MouseArea {
        id: scoreSceneMouseArea
        anchors.fill: parent
        onClicked: frogNetworkView.visible = true
      }
    }
  }
}

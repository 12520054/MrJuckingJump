import QtQuick 2.0
import VPlay 2.0
import QtSensors 5.5
import "../"

SceneBase {
  id: gameScene

  // actual scene size
  width: 480
  height: 800

  state: "start"

  property int score: 0

  signal menuScenePressed

  // background image
  Rectangle {
    anchors.fill: parent
    color:"white"
  }

  // key input will be handled by the controller in our batMan-entity
  Keys.forwardTo: batMan.controller

  // accelerometer can be used to react to tilting the phone
  Accelerometer {
    id: accelerometer
    active: true
  }

  // add physics world to use gravity and collision detection
  PhysicsWorld {
    debugDrawVisible: false // turn it on for debugging
    updatesPerSecondForPhysics: 60
    gravity.y: 12 // how much gravity do you want?
  }

  // the repeater adds ten platforms to the scene
  Repeater {
    model: 5 // every platorm gets recycled so we define only ten of them
    Platform {
      x: utils.generateRandomValueBetween(50, gameScene.width - 150) // random value
      y: (gameScene.height / 5) * index // distribute the platforms across the screen
    }
  }

  // the batMan entity (player character)
  BatMan {
    id: batMan
    x: gameScene.width / 2
    y: gameScene.height / 2
  }

  // border at the bottom of the screen, used to check game-over
  Border {
    id: border
    x: - gameScene.width*2
    y: gameScene.height - 10 // subtract a small value to make the border just visible in our scene
  }

  // show current player score
  Image {
    id: scoreCounter
    source: "../../assets/scoreCounter.png"
    x: 0
    y: 0
    // text component to show the score
    Text {
      id: scoreText
      anchors.centerIn: parent
      color: "black"
      font.pixelSize: 17
      font.family: "Press Start 2P"
      text: score
    }
  }

  // start the game when user touches the screen
  MouseArea {
    id: mouseArea
    anchors.fill: gameScene.gameWindowAnchorItem
    onClicked: {
      if(gameScene.state === "start") { // if the game is ready and the screen is clicked we start the game
        gameScene.state = "playing"
      }
      if(gameScene.state === "gameOver") // if the batMan is dead and the screen is clicked we restart the game
      {
        gameScene.state = "start"
      }
    }
  }

  // show info text depending on state (gameover, start)
  Image {
    id: infoText
    anchors.centerIn: parent
    source: gameScene.state == "gameOver" ? "../../assets/gameOverText.png" : "../../assets/clickToPlayText.png"
    visible: gameScene.state !== "playing"
    SequentialAnimation on scale {
        loops: Animation.Infinite
        PropertyAnimation {
            to: 0.9
            duration: 500
        }
        PropertyAnimation {
            to: 1.0
            duration: 500
        }
    }
  }

  // options button to jump back to menu
  Image {
    id: menuButton
    source: "../../assets/optionsButton.png"
    x:parent.width - 75
    y: -25
    scale: 0.5

    MouseArea {
      id: menuButtonMouseArea
      anchors.fill: parent
      onClicked: {
        menuScenePressed()
        // reset the gameScene
        batMan.die()
        gameScene.state = "start"
      }
    }
  }
}

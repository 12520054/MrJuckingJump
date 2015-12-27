import VPlay 2.0
import QtQuick 2.0
import "scenes"
import VPlayPlugins.googleanalytics 1.0

GameWindow {
  id: gameWindow

  // window size
  width: 480
  height: 800

  activeScene: gameScene

  EntityManager {
    id: entityManager
    entityContainer: gameScene
  }

  // set up game network and achievements
  VPlayGameNetwork {
    id: gameNetwork
    gameId: 206
    secret: "juckingjump"
    gameNetworkView: batManNetworkView
  }

  // scene for the actual game
  GameScene {
    id: gameScene
    onMenuScenePressed: {
      gameWindow.state = "menu"
    }
  }

  // the menu scene of the game
  MenuScene {
    id: menuScene
    onGameScenePressed: {
      gameWindow.state = "game"
    }

    VPlayGameNetworkView {
      id: batManNetworkView
      visible: false
      anchors.fill: parent.gameWindowAnchorItem

      onShowCalled: {
        batManNetworkView.visible = true
      }

      onBackClicked: {
        batManNetworkView.visible = false
      }
    }
  }

  state: "menu"

  states: [
    State {
      name: "menu"
      PropertyChanges {target: menuScene; opacity: 1}
      PropertyChanges {target: gameWindow; activeScene: menuScene}
    },
    State {
      name: "game"
      PropertyChanges {target: gameScene; opacity: 1}
      PropertyChanges {target: gameWindow; activeScene: gameScene}
    }
  ]
}

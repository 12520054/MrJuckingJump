import VPlay 2.0
import QtQuick 2.0

Scene {
  id: sceneBase

  width: 480
  height: 800

  // by default, set the opacity to 0. We handle this property from Main.qml via PropertyChanges.
  opacity: 0

  // the scene is only visible if the opacity is > 0. This improves performance.
  visible: opacity > 0

  // only enable scene if it is visible.
  enabled: visible
}

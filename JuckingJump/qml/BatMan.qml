import QtQuick 2.0
import VPlay 2.0

EntityBase {

  id:batManEntity // the id we use as a reference inside this class

  entityType: "BatMan" // always name your entityTypes

  state: batManCollider.linearVelocity.y < 0 ?  "jumping" : "falling" // change state according to the batMan's y velocity

  property int impulse: y-batManCollider.linearVelocity.y // to move platforms

  property alias controller: twoAxisController // we make the batMan's twoAxisController visible and accessible for the scene

  // batManCollider uses TwoAxisController to move the batMan left or right.
  TwoAxisController {
    id: twoAxisController
  }

  // sprite for the batMan, he can either be sitting or jumping
  SpriteSequenceVPlay {
    id: batManAnimation

    defaultSource: "../assets/spritesheet.png"
    scale: 0.35 // our image is too big so we reduce the size of the original image to 35%
    anchors.centerIn: batManCollider
    // when batMan jumps it turns to the direction he moves
    rotation: batManEntity.state == "jumping" ?
                 (system.desktopPlatform ?
                    twoAxisController.xAxis * 15
                    : (accelerometer.reading !== null ? -accelerometer.reading.x * 10 : 0))
                : 0

    SpriteVPlay {
      name: "sitting"
      frameWidth: 160
      frameHeight: 160
      startFrameColumn: 2
    }

    SpriteVPlay {
      name: "jumping"
      frameCount: 4
      frameRate: 8

      frameWidth: 160
      frameHeight: 165
      frameX: 0
      frameY: 160
    }
  }

  // collider to check for collisions and apply gravity
  BoxCollider {
    id: batManCollider

    width: 30 // width of the batMan collider
    height: 50 // height of the batMan collider

    bodyType: gameScene.state == "playing" ?  Body.Dynamic : Body.Static // do not apply gravity when the batMan is dead or the game is not started

    // move the batMan left and right
    linearVelocity.x: system.desktopPlatform ?
                        twoAxisController.xAxis * 200 :  //  for desktop
                        (accelerometer.reading !== null ? -accelerometer.reading.x * 100 : 0)   // for mobile

    fixture.onContactChanged: {
      var otherEntity = other.getBody().target
      var otherEntityType = otherEntity.entityType

      if(otherEntityType === "Border") {
        batManEntity.die()
      }
      else if(otherEntityType === "Platform" && batManEntity.state == "falling") {
        batManCollider.linearVelocity.y = -400

        otherEntity.playWobbleAnimation()
      }
    }
  }

  // animations handling
  onStateChanged: {
    if(batManEntity.state == "jumping") {
      batManAnimation.jumpTo("jumping") // change the current animation to jumping
    }
    if(batManEntity.state == "falling") {
      batManAnimation.jumpTo("sitting") // change the current animation to sitting
    }
  }

  onYChanged: {
    if(y < 200) {
      y = 200 // limit the batMan's y value

      score += 1 // increase score
    }
  }

  // die and restart game
  function die() {
    // reset position
    batManEntity.x = gameScene.width / 2
    batManEntity.y = 220

    // reset velocity
    batManCollider.linearVelocity.y = 0

    // reset animation
    batManAnimation.jumpTo("sitting")

    gameNetwork.reportScore(score) // report the current score to the gameNetwork
    score = 0

    gameScene.state = "gameOver"
  }
}

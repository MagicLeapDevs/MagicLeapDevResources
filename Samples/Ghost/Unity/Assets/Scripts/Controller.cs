using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.XR.MagicLeap;

public class Controller : MonoBehaviour {

    #region Public Variables
    public MLInputController _controller; 
    public GameObject Info;
    public GameObject Ghost;
    #endregion

    #region Private Variables
    private Ghost _ghost;
    private Instructions _instructions; 
    private bool _infoMode = true;
    //private bool _bumperUp = false;
    private bool _homeButtonUp = false;
    private float _triggerThreshold = 0.2f;
    private bool _triggerPressed;
    #endregion

    #region Unity Methods
    void Awake() {
        MLInput.Start();
    }
        
    void Start() {
        _controller = MLInput.GetController(MLInput.Hand.Left);
        MLInput.OnControllerButtonUp += OnButtonUp;

        _ghost = Ghost.GetComponentInChildren<Ghost>();
        _instructions = Info.GetComponentInChildren<Instructions>();

        setInfoState(true);
    }

    void OnDestroy() {
        MLInput.OnControllerButtonDown -= OnButtonUp;
        MLInput.Stop();
    }

    void LateUpdate() {
        checkHomeButton();
        checkTrigger();
        resetFlags();
    }
    #endregion

    #region Private Methods

    // setInfoState
    // Changes the mode
    // starts info page mode(hides ghost) or hides info pages and spawns ghost
    void setInfoState(bool state) {
        _infoMode = state;
        if (_infoMode) {
            _ghost.hideGhost();
            if ( _instructions.NextPage(true)) {
                return;
            }
        }
        _infoMode = false;    
        _ghost.spawnGhost();
    }
    private void resetFlags() {
        _homeButtonUp = false;
        //_bumperUp = false;
    }
    private void checkHomeButton() {
        if (_homeButtonUp) {
            setInfoState(true);
        }
    }
    /*private void checkBumper() {
        if (_bumperUp) {
            _ghost.ToggleGhostMovement();
            _controller.StartFeedbackPatternVibe(MLInputControllerFeedbackPatternVibe.Bump, MLInputControllerFeedbackIntensity.High);
        }
    }*/

    // checkTrigger
    // Checks to see if trigger has been pressed
    // depending on mode will either advance info pages or toggle frozen state of ghost
    private void checkTrigger() {
        if (_controller.TriggerValue < _triggerThreshold) {
            _triggerPressed = false;
        }
        else {
            if (_triggerPressed == false) {
                if (_infoMode) {
                    if (!_instructions.NextPage()) {
                        setInfoState(false);
                    }
                }
                else {
                    _ghost.ToggleFreeze();
                }
                _triggerPressed = true;
            }
        }
    }
    #endregion

    public void haptic_bump(MLInputControllerFeedbackIntensity force) {
        _controller.StartFeedbackPatternVibe(MLInputControllerFeedbackPatternVibe.Bump, force);
    }
    public void haptic_buzz(MLInputControllerFeedbackIntensity force) {
        _controller.StartFeedbackPatternVibe(MLInputControllerFeedbackPatternVibe.Buzz, force);
    }


    #region Events 

    // Get Button Up states   
    void OnButtonUp(byte controller_id, MLInputControllerButton button) {
        if (button == MLInputControllerButton.Bumper) {  
            //_bumperUp = true;
        }
        else if (button == MLInputControllerButton.HomeTap) {          
            _homeButtonUp = true;
        }
    }
    #endregion
}


